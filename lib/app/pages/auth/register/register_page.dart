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
  // Flavor
  FlavorConfig flavor = FlavorConfig.instance;

  // Form Key (For validation)
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // TextEditingController
  final TextEditingController _txtFullName = TextEditingController();
  final TextEditingController _txtEmailAddress = TextEditingController();
  final TextEditingController _txtPhoneNumber = TextEditingController();
  final TextEditingController _txtPassword = TextEditingController();
  final TextEditingController _txtConfirmPassword = TextEditingController();

  // Focus Node
  final FocusNode _fnFullName = FocusNode();
  final FocusNode _fnEmailAddress = FocusNode();
  final FocusNode _fnPhoneNumber = FocusNode();
  final FocusNode _fnPassword = FocusNode();
  final FocusNode _fnConfirmPassword = FocusNode();

  // Obsecure Text
  bool _obsecureText = true;
  bool _obsecureConfirm = true;

  // Agree to Term of Service
  bool _agreeToTermOfService = false;

  // Validation
  ValidationType validation = ValidationType.instance;

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
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo must svg, so we can changed the color based on primaryColor
                SvgPicture.asset(
                  'assets/images/logo.svg',
                  semanticsLabel: 'Logo',
                  colorFilter: ColorFilter.mode(
                    ColorsValue.primaryColor(context),
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  'Create an Account',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                // Subtitle
                Text(
                  'Sign up now to get started with an account.',
                  style: Theme.of(context).textTheme.titleSmall,
                ),

                // Form
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Input Full Name
                        TextFormField(
                          controller: _txtFullName,
                          focusNode: _fnFullName,
                          validator: validation.emptyValidation,
                          onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_fnEmailAddress),
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            hintText: 'Type your full name',
                            labelText: 'Full Name',
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Input Email Address
                        TextFormField(
                          controller: _txtEmailAddress,
                          focusNode: _fnEmailAddress,
                          validator: validation.emailValidation,
                          onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_fnPhoneNumber),
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'Type your email address',
                            labelText: 'Email Address',
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Input Phone Number
                        TextFormField(
                          controller: _txtPhoneNumber,
                          focusNode: _fnPhoneNumber,
                          validator: validation.phoneNumberValidation,
                          onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_fnPassword),
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          maxLength: 14,
                          decoration: const InputDecoration(
                            hintText: 'Country Code + Phone Number (ex: 628973642)',
                            labelText: 'Phone Number',
                            counterText: '',
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Input Password
                        TextFormField(
                          controller: _txtPassword,
                          focusNode: _fnPassword,
                          obscureText: _obsecureText,
                          validator: validation.passwordValidation,
                          onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_fnConfirmPassword),
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(_obsecureText ? Icons.visibility_rounded : Icons.visibility_off_rounded),
                              onPressed: () {
                                setState(() {
                                  _obsecureText = !_obsecureText;
                                });
                              },
                            ),
                            hintText: 'Type your password',
                            labelText: 'Password',
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Input Confirm Password
                        TextFormField(
                          controller: _txtConfirmPassword,
                          focusNode: _fnConfirmPassword,
                          obscureText: _obsecureConfirm,
                          validator: (value) {
                            return validation.confirmPasswordValidation(value, _txtPassword.text);
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
                            hintText: 'Type again your password',
                            labelText: 'Confirm Password',
                          ),
                        ),
                        const SizedBox(height: 16),
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
                                  _agreeToTermOfService = value!;
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(text: 'I have read and agree to the', style: Theme.of(context).textTheme.bodySmall),
                                    TextSpan(
                                      text: ' Terms of Service',
                                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                            color: ColorsValue.primaryColor(context),
                                          ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          // TODO: Change your terms of service
                                          Uri url = Uri.parse('https://generator.lorem-ipsum.info/terms-and-conditions');
                                          if (!await launchUrl(url)) {
                                            throw 'Could not launch $url';
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

                        // Sign Up Button
                        Consumer<AuthProvider>(
                          builder: (context, value, child) {
                            if (value.isLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return ElevatedButton(
                              onPressed: _agreeToTermOfService
                                  ? () async {
                                      FocusScope.of(context).unfocus();
                                      // Check if the form valid
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
                                  : null,
                              child: const Text('Get Started'),
                            );
                          },
                        ),
                        const SizedBox(height: 16),

                        // Login Text
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
