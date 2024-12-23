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
            text: 'Đã có tài khoản?',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          TextSpan(
            text: ' Đăng nhập',
            style: Theme.of(context).textTheme.bodySmall!.apply(
              color: ColorsValue.primaryColor(context),
            ),
            recognizer: TapGestureRecognizer() // Xử lý cử chỉ nhấn vào văn bản
              ..onTap = () {
                Navigator.of(context).pop();
              },
          ),
        ],
      ),
    );
  }
}
