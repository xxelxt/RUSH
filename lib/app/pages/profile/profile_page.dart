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
  // ImagePicker để chọn ảnh
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Tải thông tin người dùng khi trang được khởi tạo
    context.read<AccountProvider>().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AccountProvider>(
        builder: (context, value, child) {
          // Hiển thị vòng tròn loading nếu đang tải thông tin
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

                  // Avatar hiển thị ảnh đại diện
                  Center(
                    child: ProfilePictureAvatar(
                      photoProfileUrl: value.account.photoProfileUrl, // Đường dẫn ảnh đại diện
                      isLoading: value.isLoading, // Trạng thái loading khi cập nhật ảnh
                      onTapCamera: () {
                        pickImage(); // Mở dialog chọn ảnh
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Hiển thị thông tin cá nhân
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Thông tin tài khoản",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Hiển thị và chỉnh sửa họ tên
                  PersonalInfoTile(
                    personalInfo: 'Họ và tên',
                    value: value.account.fullName,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditProfileDialog(
                          title: 'Cập nhật tên của bạn',
                          hintText: 'Nhập họ và tên của bạn',
                          labelText: 'Họ và tên',
                          initialValue: value.account.fullName,
                          fieldName: 'full_name',
                          validation: ValidationType.instance.emptyValidation,
                        ),
                      );
                    },
                  ),

                  // Hiển thị và chỉnh sửa email
                  PersonalInfoTile(
                    personalInfo: 'Email',
                    value: value.account.emailAddress,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditProfileDialog(
                          title: 'Cập nhật địa chỉ email của bạn',
                          hintText: 'Nhập địa chỉ email của bạn',
                          labelText: 'Địa chỉ email',
                          initialValue: value.account.emailAddress,
                          fieldName: 'email_address',
                          validation: ValidationType.instance.emailValidation,
                        ),
                      );
                    },
                  ),

                  // Hiển thị và chỉnh sửa số điện thoại
                  PersonalInfoTile(
                    personalInfo: 'Số điện thoại',
                    value: value.account.phoneNumber.formatPhoneNumber(),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditProfileDialog(
                          title: 'Cập nhật số điện thoại của bạn',
                          hintText: 'Nhập số điện thoại của bạn',
                          labelText: 'Số điện thoại',
                          initialValue: value.account.phoneNumber,
                          fieldName: 'phone_number',
                          validation: ValidationType.instance.emptyValidation,
                          isPhone: true,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Thay đổi thông tin",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Đặt lại mật khẩu
                  ActionRow(
                    label: 'Đặt lại mật khẩu',
                    onTap: () {
                      resetPassword(emailAddress: value.account.emailAddress);
                    },
                  ),
                  const Divider(height: 1),

                  // Quản lý địa chỉ
                  if (flavor.flavor == Flavor.user)
                    ActionRow(
                      label: 'Địa chỉ giao hàng',
                      onTap: () {
                        NavigateRoute.toManageAddress(context: context);
                      },
                    ),
                  if (flavor.flavor == Flavor.user) const Divider(height: 1),

                  // Quản lý phương thức thanh toán
                  if (flavor.flavor == Flavor.user)
                    ActionRow(
                      label: 'Phương thức thanh toán',
                      onTap: () {
                        NavigateRoute.toManagePaymentMethod(context: context);
                      },
                    ),
                  if (flavor.flavor == Flavor.user) const Divider(height: 1),

                  // Chế độ tối
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text('Chế độ tối'),
                        ),
                        Consumer<DarkModeProvider>(
                          builder: (context, darkMode, child) {
                            return Switch(
                              value: darkMode.isDarkMode,
                              onChanged: (value) {
                                darkMode.setDarkMode(value); // Bật hoặc tắt chế độ tối
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // Thông tin ứng dụng
                  ActionRow(
                    label: 'Thông tin ứng dụng',
                    onTap: () {
                      showAboutDialog(context: context);
                    },
                  ),
                  const Divider(height: 1),

                  // Đăng xuất
                  ActionRow(
                    label: 'Đăng xuất',
                    onTap: () {
                      context.read<AuthProvider>().logout(); // Gọi hàm đăng xuất
                      context.read<AccountProvider>().getProfile();
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

  // Hàm chọn ảnh từ máy hoặc camera
  pickImage() async {
    try {
      ScaffoldMessenger.of(context).removeCurrentMaterialBanner();

      ImageSource? pickImageSource = await showDialog(
        context: context,
        builder: (context) {
          return const PickImageSource(); // Dialog chọn nguồn ảnh
        },
      );

      if (pickImageSource != null) {
        await _picker.pickImage(source: pickImageSource).then((image) {
          if (image != null) {
            context.read<AccountProvider>().updatePhotoProfile(image); // Cập nhật ảnh đại diện
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

  // Hàm đặt lại mật khẩu
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
            content: Text('Đã gửi email đặt lại mật khẩu'),
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
