import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomNavBar extends StatelessWidget {
  final double width;
  const BottomNavBar({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          width > 923 ? 4 : width < 968 && width > 768 ? 3 : width <= 425 ? 1 : 3,
              (index) => Row(
                children: [
                  Image.asset(
                    'assets/im/Christmas_Gift.png',
                    scale: width <= 425 ? 20/3.w : 20/1.w,
                  ).animate(
                    delay: 1000.ms,
                    onPlay: (controller) => controller.repeat(),
                  ).moveY(duration: 1.seconds, begin: 0, end: 10),

                  SizedBox(height: 10.h),

                  Image.asset(
                    'assets/im/Christmas_Gifts.png',
                    scale: width <= 425 ? 20/3.w : 20/1.w,
                  ).animate(
                    delay: 1000.ms,
                    onPlay: (controller) => controller.repeat(),
                  ).moveY(duration: 2.seconds, begin: -10, end: 10, curve: Curves.decelerate),

                  SizedBox(height: 10.h),

                  Image.asset(
                    'assets/im/Present.png',
                    scale: width <= 425 ? 20/3.w : 20/1.w,
                  ).animate(
                    delay: 1000.ms,
                    onPlay: (controller) => controller.repeat(),
                  ).moveY(duration: 3.seconds, begin: 0, end: 10),
                ],
              ),
        ),
      ),
    );
  }
}
