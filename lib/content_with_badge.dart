import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

enum ContentWitBadgeSlot {
  content,
  badge,
}

enum BadgeAlignment {
  topRight,
  bottomRight,
}

class ContentWithBadge extends SlottedMultiChildRenderObjectWidget<
    ContentWitBadgeSlot, RenderBox> {
  final Widget content;
  final Widget? badge;
  final BadgeAlignment alignment;

  const ContentWithBadge({
    super.key,
    required this.content,
    this.badge,
    this.alignment = BadgeAlignment.topRight,
  });

  @override
  Widget? childForSlot(ContentWitBadgeSlot slot) {
    return switch (slot) {
      ContentWitBadgeSlot.content => content,
      ContentWitBadgeSlot.badge => badge
    };
  }

  @override
  Iterable<ContentWitBadgeSlot> get slots => ContentWitBadgeSlot.values;

  @override
  SlottedContainerRenderObjectMixin<ContentWitBadgeSlot, RenderBox>
      createRenderObject(BuildContext context) =>
          RenderContentWithBadge(alignment);

  @override
  void updateRenderObject(
      BuildContext context, RenderContentWithBadge renderObject) {
    renderObject.alignment = alignment;
  }
}

class RenderContentWithBadge extends RenderBox
    with SlottedContainerRenderObjectMixin<ContentWitBadgeSlot, RenderBox> {
  RenderContentWithBadge(this._alignment);

  BadgeAlignment _alignment;
  set alignment(BadgeAlignment value) {
    if (_alignment == value) {
      return;
    }
    _alignment = value;
    markNeedsLayout();
  }

  BadgeAlignment get alignment => _alignment;

  @override
  void performLayout() {
    final content = childForSlot(ContentWitBadgeSlot.content);
    if (content == null) {
      size = constraints.smallest;
      return;
    }

    content.layout(constraints, parentUsesSize: true);

    final badge = childForSlot(ContentWitBadgeSlot.badge);
    if (badge == null) {
      return;
    }

    badge.layout(constraints, parentUsesSize: true);

    final x = 2 / 3 * content.size.width;
    final parentData = badge.parentData;
    if (parentData is BoxParentData) {
      parentData.offset = Offset(
          x,
          switch (alignment) {
            BadgeAlignment.topRight => 0,
            BadgeAlignment.bottomRight =>
              content.size.height - badge.size.height,
          });
    }

    size = content.size + const Offset(10, 10);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    for (final child in children) {
      final parentData = child.parentData;
      if (parentData is BoxParentData) {
        context.paintChild(child, parentData.offset + offset);
      }
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    final List<RenderBox> children = this.children.toList();
    final hasBadge = children.contains(childForSlot(ContentWitBadgeSlot.badge));
    if (hasBadge) {
      children.remove(childForSlot(ContentWitBadgeSlot.badge));
    }
    if (hasBadge) {
      children.add(childForSlot(ContentWitBadgeSlot.badge)!);
    }

    for (final RenderBox child in children) {
      final BoxParentData parentData = child.parentData! as BoxParentData;
      final bool isHit = result.addWithPaintOffset(
        offset: parentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - parentData.offset);
          return child.hitTest(result, position: transformed);
        },
      );
      if (isHit) {
        return true;
      }
    }
    return false;
  }
}
