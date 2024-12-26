import 'package:rush/app/constants/colors_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../constants/validation_type.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/error_banner.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _txtEmailAddress = TextEditingController();
  final FocusNode _fnEmailAddress = FocusNode();

  // Instance của lớp ValidationType để xác thực
  ValidationType validation = ValidationType.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo SVG
                SvgPicture.asset(
                  'assets/images/logo.svg',
                  semanticsLabel: 'Logo',
                  colorFilter: ColorFilter.mode(
                    ColorsValue.primaryColor(context),
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 16),

                // Tiêu đề
                Text(
                  'Quên mật khẩu',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Vui lòng nhập địa chỉ email tài khoản bạn đã đăng ký. Chúng tôi sẽ gửi cho bạn email đặt lại mật khẩu.',
                  style: Theme.of(context).textTheme.titleSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Form nhập địa chỉ email
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _txtEmailAddress,
                    focusNode: _fnEmailAddress,
                    validator: validation.emailValidation,
                    keyboardType: TextInputType.emailAddress,
                    onFieldSubmitted: (value) => FocusScope.of(context).unfocus(),
                    decoration: const InputDecoration(
                      hintText: 'Nhập địa chỉ email của bạn',
                      labelText: 'Địa chỉ email',
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Nút đặt lại mật khẩu
                Consumer<AuthProvider>(
                  builder: (context, value, child) {
                    // Hiển thị vòng tròn loading nếu đang xử lý
                    if (value.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus(); // Ẩn bàn phím
                        // Kiểm tra form hợp lệ
                        if (_formKey.currentState!.validate() && !value.isLoading) {
                          try {
                            ScaffoldMessenger.of(context).removeCurrentMaterialBanner();

                            // Gửi yêu cầu đặt lại mật khẩu
                            await value
                                .resetPassword(
                              email: _txtEmailAddress.text, // Email nhập vào
                            )
                                .whenComplete(() {
                              _formKey.currentState!.reset(); // Reset form

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Đã gửi email'),
                                ),
                              );
                            });
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
                              ScaffoldMessenger.of(context).showMaterialBanner(
                                errorBanner(context: context, msg: e.toString()),
                              );
                            }
                          }
                        }
                      },
                      child: const Text('Đặt lại mật khẩu'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
