import 'package:rush/app/constants/colors_value.dart';
import 'package:rush/app/constants/validation_type.dart';
import 'package:rush/app/providers/auth_provider.dart';
import 'package:rush/app/widgets/error_banner.dart';
import 'package:rush/config/flavor_config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/login_text.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  FlavorConfig flavor = FlavorConfig.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // TextEditingController
  final TextEditingController _txtFullName = TextEditingController();
  final TextEditingController _txtEmailAddress = TextEditingController();
  final TextEditingController _txtPhoneNumber = TextEditingController();
  final TextEditingController _txtPassword = TextEditingController();
  final TextEditingController _txtConfirmPassword = TextEditingController();

  // FocusNode
  final FocusNode _fnFullName = FocusNode();
  final FocusNode _fnEmailAddress = FocusNode();
  final FocusNode _fnPhoneNumber = FocusNode();
  final FocusNode _fnPassword = FocusNode();
  final FocusNode _fnConfirmPassword = FocusNode();

  // Ẩn/hiện mật khẩu
  bool _obsecureText = true;
  bool _obsecureConfirm = true;

  bool _agreeToTermOfService = false;

  // Instance của lớp ValidationType để xác thực
  ValidationType validation = ValidationType.instance;

  // Giải phóng bộ nhớ
  @override
  void dispose() {
    _txtFullName.dispose();
    _txtEmailAddress.dispose();
    _txtPhoneNumber.dispose();
    _txtPassword.dispose();
    _txtConfirmPassword.dispose();

    _fnFullName.dispose();
    _fnEmailAddress.dispose();
    _fnPhoneNumber.dispose();
    _fnPassword.dispose();
    _fnConfirmPassword.dispose();
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

                // Logo SVG (tự động thay đổi màu theo primaryColor)
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
                  'Tạo tài khoản mới',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  'Khám phá RUSH với tài khoản cá nhân của bạn',
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
                        // Trường nhập họ và tên
                        TextFormField(
                          controller: _txtFullName,
                          focusNode: _fnFullName,
                          validator: validation.emptyValidation,
                          onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_fnEmailAddress),
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            hintText: 'Nhập họ và tên của bạn',
                            labelText: 'Họ và tên',
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Trường nhập email
                        TextFormField(
                          controller: _txtEmailAddress,
                          focusNode: _fnEmailAddress,
                          validator: validation.emailValidation,
                          onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_fnPhoneNumber),
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'Nhập địa chỉ email của bạn',
                            labelText: 'Địa chỉ email',
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Trường nhập số điện thoại
                        TextFormField(
                          controller: _txtPhoneNumber,
                          focusNode: _fnPhoneNumber,
                          validator: validation.phoneNumberValidation,
                          onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_fnPassword),
                          keyboardType: TextInputType.phone,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          maxLength: 14,
                          decoration: const InputDecoration(
                            hintText: 'Nhập số điện thoại của bạn',
                            labelText: 'Số điện thoại',
                            counterText: '',
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Trường nhập mật khẩu
                        TextFormField(
                          controller: _txtPassword,
                          focusNode: _fnPassword,
                          obscureText: _obsecureText, // Ẩn/hiện mật khẩu
                          validator: validation.passwordValidation,
                          onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_fnConfirmPassword),
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(_obsecureText ? Icons.visibility_rounded : Icons.visibility_off_rounded),
                              onPressed: () {
                                setState(() {
                                  _obsecureText = !_obsecureText; // Đổi trạng thái ẩn/hiện
                                });
                              },
                            ),
                            hintText: 'Nhập mật khẩu của bạn',
                            labelText: 'Mật khẩu',
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Trường xác nhận mật khẩu
                        TextFormField(
                          controller: _txtConfirmPassword,
                          focusNode: _fnConfirmPassword,
                          obscureText: _obsecureConfirm, // Ẩn/hiện mật khẩu
                          validator: (value) {
                            return validation.confirmPasswordValidation(value, _txtPassword.text); // Xác thực khớp mật khẩu
                          },
                          onFieldSubmitted: (value) => FocusScope.of(context).unfocus(),
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(_obsecureConfirm ? Icons.visibility_rounded : Icons.visibility_off_rounded),
                              onPressed: () {
                                setState(() {
                                  _obsecureConfirm = !_obsecureConfirm;
                                });
                              },
                            ),
                            hintText: 'Nhập lại mật khẩu của bạn',
                            labelText: 'Xác nhận mật khẩu',
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Đồng ý với điều khoản sử dụng
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                              activeColor: ColorsValue.primaryColor(context),
                              value: _agreeToTermOfService,
                              onChanged: (value) {
                                setState(() {
                                  _agreeToTermOfService = value!; // Cập nhật trạng thái
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Tôi đồng ý với các ', style: Theme.of(context).textTheme.bodySmall),
                                    TextSpan(
                                      text: 'Điều khoản sử dụng',
                                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                        color: ColorsValue.primaryColor(context),
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          Uri url = Uri.parse('https://generator.lorem-ipsum.info/terms-and-conditions');
                                          if (!await launchUrl(url)) {
                                            throw 'Không thể mở $url';
                                          }
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Nút đăng ký
                        Consumer<AuthProvider>(
                          builder: (context, value, child) {
                            if (value.isLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return ElevatedButton(
                              onPressed: _agreeToTermOfService // Chỉ cho phép đăng ký nếu đồng ý điều khoản
                                  ? () async {
                                FocusScope.of(context).unfocus();
                                // Kiểm tra form hợp lệ
                                if (_formKey.currentState!.validate() && !value.isLoading) {
                                  try {
                                    ScaffoldMessenger.of(context).removeCurrentMaterialBanner();

                                    await value
                                        .register(
                                      emailAddress: _txtEmailAddress.text,
                                      password: _txtPassword.text,
                                      fullName: _txtFullName.text,
                                      phoneNumber: _txtPhoneNumber.text,
                                    )
                                        .then((value) {
                                      Navigator.of(context).pop();
                                    });
                                  } catch (e) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showMaterialBanner(
                                        errorBanner(context: context, msg: e.toString()),
                                      );
                                    }
                                  }
                                }
                              }
                                  : null, // Vô hiệu hóa nút nếu chưa đồng ý điều khoản
                              child: const Text('Bắt đầu thôi!'),
                            );
                          },
                        ),
                        const SizedBox(height: 16),

                        // Liên kết class LoginText()
                        const LoginText(),
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
