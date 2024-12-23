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
            text: 'Chưa có tài khoản? ',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          TextSpan(
            text: 'Đăng ký',
            style: Theme.of(context).textTheme.bodySmall!.apply(
                  color: ColorsValue.primaryColor(context),
                ),
            recognizer: TapGestureRecognizer() // Xử lý cử chỉ nhấn vào văn bản
              ..onTap = () {
                NavigateRoute.toRegister(context: context);
              },
          ),
        ],
      ),
    );
  }
}
