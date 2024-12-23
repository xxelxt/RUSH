import 'package:rush/app/constants/colors_value.dart';
import 'package:rush/app/constants/validation_type.dart';
import 'package:rush/app/providers/auth_provider.dart';
import 'package:rush/app/widgets/error_banner.dart';
import 'package:rush/config/flavor_config.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../routes.dart';
import 'widgets/sign_up_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FlavorConfig flavor = FlavorConfig.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // TextEditingController
  final TextEditingController _txtEmailAddress = TextEditingController();
  final TextEditingController _txtPassword = TextEditingController();

  // FocusNode
  final FocusNode _fnEmailAddress = FocusNode();
  final FocusNode _fnPassword = FocusNode();

  // Trạng thái ẩn/hiện mật khẩu
  bool _obsecureText = true;

  // Instance của lớp ValidationType để xác thực
  ValidationType validation = ValidationType.instance;

  // Giải phóng bộ nhớ
  @override
  void dispose() {
    _txtEmailAddress.dispose();
    _txtPassword.dispose();

    _fnEmailAddress.dispose();
    _fnPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
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
                  'Đăng nhập tài khoản RUSH',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  'Chào mừng bạn quay trở lại!',
                  style: Theme.of(context).textTheme.titleSmall,
                ),

                // Form nhập thông tin
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Trường nhập email
                        TextFormField(
                          controller: _txtEmailAddress,
                          focusNode: _fnEmailAddress,
                          validator: validation.emailValidation,
                          keyboardType: TextInputType.emailAddress,
                          onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_fnPassword),
                          decoration: const InputDecoration(
                            hintText: 'Nhập địa chỉ email của bạn',
                            labelText: 'Địa chỉ email',
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Trường nhập mật khẩu
                        TextFormField(
                          controller: _txtPassword,
                          focusNode: _fnPassword,
                          obscureText: _obsecureText, // Ẩn/hiện mật khẩu
                          validator: validation.passwordValidation,
                          onFieldSubmitted: (value) => FocusScope.of(context).unfocus(),
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(_obsecureText ? Icons.visibility_rounded : Icons.visibility_off_rounded),
                              onPressed: () {
                                setState(() {
                                  _obsecureText = !_obsecureText; // Chuyển trạng thái ẩn/hiện
                                });
                              },
                            ),
                            hintText: 'Nhập mật khẩu của bạn',
                            labelText: 'Mật khẩu',
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Liên kết Quên mật khẩu
                        InkWell(
                          onTap: () {
                            NavigateRoute.toForgotPassword(context: context); // Chuyển đến màn hình quên mật khẩu
                          },
                          child: Text(
                            'Quên mật khẩu?',
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.end,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Nút đăng nhập
                        Consumer<AuthProvider>(
                          builder: (context, value, child) {
                            // Hiển thị vòng tròn tải nếu đang loading
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

                                    await value
                                        .login(
                                      emailAddress: _txtEmailAddress.text, // Email nhập vào
                                      password: _txtPassword.text, // Mật khẩu nhập vào
                                    )
                                        .then((e) {
                                      // Kiểm tra quyền tài khoản
                                      if (!value.isRoleValid) {
                                        _formKey.currentState!.reset(); // Reset form

                                        ScaffoldMessenger.of(context).showMaterialBanner(
                                          errorBanner(context: context, msg: 'Tài khoản của bạn không có quyền truy cập'),
                                        );
                                      }
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
                              child: const Text('Đăng nhập'),
                            );
                          },
                        ),
                        const SizedBox(height: 16),

                        // Liên kết class SignUpText()
                        const SignUpText(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
