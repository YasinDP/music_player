import 'dart:math';

import 'package:flutter/material.dart';
import 'package:music_player/core/constants/app_colors.dart';
import 'package:music_player/core/constants/assets.dart';
import 'package:music_player/core/utils/validators.dart';
import 'package:music_player/core/utils/extensions.dart';
import 'package:music_player/auth/widgets/animated_text_field.dart';
import 'package:music_player/core/animations/shake_transition.dart';
import 'package:music_player/auth/widgets/switch_auth_mode.dart';
import 'package:music_player/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({
    Key? key,
  }) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  bool _isLogin = true;
  String _name = "";
  String _email = "";
  String _password = "";

  void proceed() async {
    if (_formKey.currentState!.validate()) {
      final String? response =
          await context.read<AuthProvider>().authenticateUser(
                name: _name,
                email: _email,
                password: _password,
                isLogin: _isLogin,
              );
      if (response != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response),
          duration: const Duration(seconds: 1),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.only(
          left: defaultPadding * 2,
          right: defaultPadding * 2,
          top: min(100, context.height * 0.1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShakeTransition(
              duration: const Duration(milliseconds: 2000),
              child: Image.asset(
                Assets.logoWithText,
                width: min(150, context.width * 0.3),
                height: min(150, context.width * 0.3),
              ),
            ),
            if (!_isLogin)
              Column(
                children: [
                  const SizedBox(height: defaultPadding),
                  AnimatedTextField(
                    hintText: "Enter Your Name",
                    keyboardType: TextInputType.text,
                    prefixIcon: Icons.person_2_outlined,
                    validator: (value) =>
                        Validator.validateName(value, isRequired: !_isLogin),
                    onChanged: (value) {
                      _name = value ?? "";
                    },
                    onSaved: (value) {
                      _name = value ?? "";
                    },
                  ),
                ],
              ),
            const SizedBox(height: defaultPadding),
            AnimatedTextField(
              hintText: "Enter Email",
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email,
              validator: Validator.validateEmail,
              onChanged: (value) {
                _email = value ?? "";
              },
              onSaved: (value) {
                _email = value ?? "";
              },
            ),
            const SizedBox(height: defaultPadding),
            AnimatedTextField(
              hintText: "Enter Password",
              keyboardType: TextInputType.visiblePassword,
              isPassword: true,
              prefixIcon: Icons.password,
              validator: Validator.validatePassword,
              onChanged: (value) {
                _password = value ?? "";
              },
              onSaved: (value) {
                _password = value ?? "";
              },
            ),
            const SizedBox(height: defaultPadding),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: proceed,
                style: const ButtonStyle(
                  padding: MaterialStatePropertyAll(
                    EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                child: AnimatedText(
                  _isLogin ? "LOGIN" : "SIGNUP",
                  scale: true,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
            const SizedBox(height: defaultPadding),
            SwitchAuthMode(
              isLogin: _isLogin,
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
