import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChristmasTreeSection extends StatefulWidget {
  const ChristmasTreeSection({super.key});

  @override
  ChristmasTreeSectionState createState() => ChristmasTreeSectionState();
}

class ChristmasTreeSectionState extends State<ChristmasTreeSection> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            size: Size(200.w, 500.h),
            painter: ChristmasTreePainter(animationValue: _animation.value),
          );
        },
      ),
    );
  }
}

class ChristmasTreePainter extends CustomPainter {
  final double animationValue;

  ChristmasTreePainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final centerX = size.width / 2;
    final centerY = size.height;

    const int turns = 20;
    const double height = 500;
    const double baseRadius = 120;

    final maxCircles = (turns * 20 * pi * animationValue).toInt();

    for (double t = 0; t < maxCircles * 0.1; t += 0.1) {
      final double radius = baseRadius * (1 - t / (turns * 2 * pi));
      final double x = centerX + radius * cos(t);
      final double y = centerY - (height * t / (turns * 2 * pi));

      paint.color = (t ~/ (2 * pi) % 2 == 0) ? Colors.green : Colors.red;

      canvas.drawCircle(Offset(x, y), 5, paint);
    }

    if (animationValue == 1.0) {
      paint.color = Colors.yellow;

      Path starPath = Path();
      final starRadius = 15.0;
      final angle = pi / 5;
      for (int i = 0; i < 5; i++) {
        final x1 = centerX + starRadius * cos(angle * i);
        final y1 = centerY - height - starRadius * sin(angle * i);
        final x2 = centerX + starRadius / 2 * cos(angle * i + angle / 2);
        final y2 = centerY - height - starRadius / 2 * sin(angle * i + angle / 2);

        if (i == 0) {
          starPath.moveTo(x1, y1);
        } else {
          starPath.lineTo(x1, y1);
        }

        starPath.lineTo(x2, y2);
      }
      starPath.close();
      canvas.drawPath(starPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
