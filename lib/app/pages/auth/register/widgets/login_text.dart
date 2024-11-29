import 'package:rush/app/constants/colors_value.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginText extends StatelessWidget {
  const LoginText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Already have an account? ',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          TextSpan(
            text: ' Log In',
            style: Theme.of(context).textTheme.bodySmall!.apply(
                  color: ColorsValue.primaryColor(context),
                ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.of(context).pop();
              },
          ),
        ],
      ),
    );
  }
}
