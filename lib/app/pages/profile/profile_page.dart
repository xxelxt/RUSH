import 'package:rush/app/constants/colors_value.dart';
import 'package:rush/app/constants/validation_type.dart';
import 'package:rush/app/pages/profile/widgets/action_row.dart';
import 'package:rush/app/pages/profile/widgets/edit_profile_dialog.dart';
import 'package:rush/app/pages/profile/widgets/personal_info_tile.dart';
import 'package:rush/app/pages/profile/widgets/profile_picture_avatar.dart';
import 'package:rush/app/providers/account_provider.dart';
import 'package:rush/app/providers/auth_provider.dart';
import 'package:rush/app/providers/dark_mode_provider.dart';
import 'package:rush/app/widgets/pick_image_source.dart';
import 'package:rush/config/flavor_config.dart';
import 'package:rush/routes.dart';

import 'package:rush/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';

import '../../widgets/error_banner.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Image Picker
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AccountProvider>(
        builder: (context, value, child) {
          if (value.isLoadProfile) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  // Profile Picture
                  Center(
                    child: ProfilePictureAvatar(
                      photoProfileUrl: value.account.photoProfileUrl,
                      isLoading: value.isLoading,
                      onTapCamera: () {
                        pickImage();
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Personal Info
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Personal info",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Name
                  PersonalInfoTile(
                    personalInfo: 'Name',
                    value: value.account.fullName,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditProfileDialog(
                          title: 'Edit Your Name',
                          hintText: 'Type your name',
                          labelText: 'Name',
                          initialValue: value.account.fullName,
                          fieldName: 'full_name',
                          validation: ValidationType.instance.emptyValidation,
                        ),
                      );
                    },
                  ),
                  // Email Address
                  PersonalInfoTile(
                    personalInfo: 'Email',
                    value: value.account.emailAddress,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditProfileDialog(
                          title: 'Edit Your Email Address',
                          hintText: 'Type your Email Address',
                          labelText: 'Email Address',
                          initialValue: value.account.emailAddress,
                          fieldName: 'email_address',
                          validation: ValidationType.instance.emailValidation,
                        ),
                      );
                    },
                  ),
                  // Phone Number
                  PersonalInfoTile(
                    personalInfo: 'Phone',
                    value: value.account.phoneNumber.separateCountryCode(),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditProfileDialog(
                          title: 'Edit Your Phone Number',
                          hintText: 'Type your Phone Number',
                          labelText: 'Phone Number',
                          initialValue: value.account.phoneNumber,
                          fieldName: 'phone_number',
                          validation: ValidationType.instance.emptyValidation,
                          isPhone: true,
                        ),
                      );
                    },
                  ),

                  // Action
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Action",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Reset Password
                  ActionRow(
                    label: 'Reset Password',
                    onTap: () {
                      resetPassword(emailAddress: value.account.emailAddress);
                    },
                  ),
                  const Divider(height: 1),

                  // Manage Adress
                  if (flavor.flavor == Flavor.user)
                    ActionRow(
                      label: 'Manage Address',
                      onTap: () {
                        NavigateRoute.toManageAddress(context: context);
                      },
                    ),
                  if (flavor.flavor == Flavor.user) const Divider(height: 1),

                  // Manage Payment Method
                  if (flavor.flavor == Flavor.user)
                    ActionRow(
                      label: 'Manage Payment Method',
                      onTap: () {
                        NavigateRoute.toManagePaymentMethod(context: context);
                      },
                    ),
                  if (flavor.flavor == Flavor.user) const Divider(height: 1),

                  // Dark Mode Switch
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text('Dark Mode'),
                        ),
                        Consumer<DarkModeProvider>(
                          builder: (context, darkMode, child) {
                            return Switch(
                              value: darkMode.isDarkMode,
                              onChanged: (value) {
                                darkMode.setDarkMode(value);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // About Appliction
                  ActionRow(
                    label: 'About Application',
                    onTap: () {
                      showAboutDialog(context: context);
                    },
                  ),
                  const Divider(height: 1),

                  // Logout
                  ActionRow(
                    label: 'Log Out',
                    onTap: () {
                      context.read<AuthProvider>().logout();
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  pickImage() async {
    try {
      ScaffoldMessenger.of(context).removeCurrentMaterialBanner();

      ImageSource? pickImageSource = await showDialog(
        context: context,
        builder: (context) {
          return const PickImageSource();
        },
      );

      if (pickImageSource != null) {
        await _picker.pickImage(source: pickImageSource).then((image) {
          if (image != null) {
            context.read<AccountProvider>().updatePhotoProfile(image);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
        ScaffoldMessenger.of(context).showMaterialBanner(
          errorBanner(context: context, msg: e.toString()),
        );
      }
    }
  }

  resetPassword({required String emailAddress}) async {
    try {
      ScaffoldMessenger.of(context).removeCurrentMaterialBanner();

      await context
          .read<AuthProvider>()
          .resetPassword(
            email: emailAddress,
          )
          .whenComplete(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email For Reset Password Sent'),
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
}
