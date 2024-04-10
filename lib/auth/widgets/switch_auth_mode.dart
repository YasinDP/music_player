import 'package:flutter/material.dart';
import 'package:music_player/core/utils/extensions.dart';

class SwitchAuthMode extends StatelessWidget {
  final bool isLogin;
  final Function()? onPressed;
  const SwitchAuthMode({
    Key? key,
    this.isLogin = true,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String userMsg =
        isLogin ? "Don’t have an Account ? " : "Already have an Account ? ";
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AnimatedText(
          userMsg,
          scale: true,
          style: TextStyle(color: context.primaryColor),
        ),
        InkWell(
          onTap: onPressed,
          child: AnimatedText(
            isLogin ? "Sign Up" : "Sign In",
            scale: true,
            style: TextStyle(
              color: context.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}

class AnimatedText extends StatelessWidget {
  const AnimatedText(
    this.text, {
    super.key,
    this.style,
    this.scale = false,
  });

  final String text;
  final TextStyle? style;
  final bool scale;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (Widget child, Animation<double> animation) {
        if (scale) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        }
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: Text(
        text,
        key: ValueKey<String>(text),
        style: style,
      ),
    );
  }
}
