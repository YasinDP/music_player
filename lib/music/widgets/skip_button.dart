import 'package:flutter/material.dart';
import 'package:music_player/core/constants/app_colors.dart';
import 'package:music_player/core/utils/extensions.dart';

class SkipButton extends StatelessWidget {
  const SkipButton({
    super.key,
    required this.onTap,
    this.isForward = true,
  });

  final Function() onTap;
  final bool isForward;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [
              AppColor.secondaryGradient,
              AppColor.infoTextColor,
            ])),
        child: Icon(
          isForward ? Icons.forward_10_rounded : Icons.replay_10_rounded,
          color: context.themeData.primaryColor,
          size: 32,
        ),
      ),
    );
  }
}
