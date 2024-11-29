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
  // Form Key (For validation)
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // TextEditingController & FocusNode
  final TextEditingController _txtEmailAddress = TextEditingController();
  final FocusNode _fnEmailAddress = FocusNode();

  // Validation
  ValidationType validation = ValidationType.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                'Forgot Password',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // Subtitle
              Text(
                'Don\'t worry! it happens. Please enter your email address we will send an email to reset your password',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 32),

              // Input Email Address
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _txtEmailAddress,
                  focusNode: _fnEmailAddress,
                  validator: validation.emailValidation,
                  keyboardType: TextInputType.emailAddress,
                  onFieldSubmitted: (value) => FocusScope.of(context).unfocus(),
                  decoration: const InputDecoration(
                    hintText: 'Type your email address',
                    labelText: 'Email Address',
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Log In Button
              Consumer<AuthProvider>(
                builder: (context, value, child) {
                  if (value.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ElevatedButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      // Check if the form valid
                      if (_formKey.currentState!.validate() && !value.isLoading) {
                        try {
                          ScaffoldMessenger.of(context).removeCurrentMaterialBanner();

                          await value
                              .resetPassword(
                            email: _txtEmailAddress.text,
                          )
                              .whenComplete(() {
                            _formKey.currentState!.reset();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Email Sent'),
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
                    child: const Text('Reset Password'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
