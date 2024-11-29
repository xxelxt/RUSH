import 'package:rush/app/constants/colors_value.dart';
import 'package:rush/routes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpText extends StatelessWidget {
  const SignUpText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Don\'t have an account? ',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          TextSpan(
            text: ' Sign Up',
            style: Theme.of(context).textTheme.bodySmall!.apply(
                  color: ColorsValue.primaryColor(context),
                ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                NavigateRoute.toRegister(context: context);
              },
          ),
        ],
      ),
    );
  }
}
