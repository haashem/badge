import 'package:badge/content_with_badge.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Body(),
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  double contentSize = 80;
  double badgeValue = 52;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Text('Content Size'),
          Slider(
            min: 40,
            max: 200,
            value: contentSize,
            onChanged: (newSize) {
              setState(() {
                contentSize = newSize;
              });
            },
          ),
          const SizedBox(height: 16),
          const Text('Badge Value'),
          Slider(
            min: 0,
            max: 1000,
            value: badgeValue,
            onChanged: (newValue) {
              setState(() {
                badgeValue = newValue;
              });
            },
          ),
          const SizedBox(height: 40),
          ContentWithBadge(
            content: _Content(size: contentSize),
            badge: _Badge(value: badgeValue.toInt()),
            alignment: BadgeAlignment.topRight,
          ),
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final double size;
  const _Content({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('content tapped');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Icon(
          Icons.message,
          size: size,
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final int value;
  const _Badge({required this.value});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        print('Badge tapped');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(32),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Text(
          value.toString(),
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
