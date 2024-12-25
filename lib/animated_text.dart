
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedTextWidget extends StatelessWidget {
  final bool isLargeScreen;
  const AnimatedTextWidget({super.key, this.isLargeScreen = false});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isLargeScreen?Alignment.centerLeft : Alignment.topCenter,
      child: AnimatedText(
        text: "Merry Christmas",
        style:TextStyle(
          fontFamily: 'GreatVibes',
          color: Colors.red,
          fontSize: 24.sp,
        ),
        delay: const Duration(seconds: 1),
        letterDelay: const Duration(milliseconds: 200),
      ).animate(),
    );
  }
}


class AnimatedText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Duration delay;
  final Duration letterDelay;

  const AnimatedText({
    required this.text,
    required this.style,
    this.delay = Duration.zero,
    this.letterDelay = const Duration(milliseconds: 150),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(text.length, (index) {
        return Text(
          text[index],
          style: style,
        )
            .animate(
          delay: delay + letterDelay * index,
        )
            .fadeIn(duration: 300.ms)
            .slideX(begin: 0.5, end: 0.0, curve: Curves.easeOut);
      }),
    );
  }
}
