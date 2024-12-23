import 'package:rush/app/providers/account_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../widgets/error_banner.dart';

class EditProfileDialog extends StatefulWidget {
  final String title;
  final String hintText;
  final String labelText;
  final String initialValue;
  final String fieldName;
  final String? Function(String?) validation;
  final bool isPhone;

  const EditProfileDialog({
    super.key,
    required this.title,
    required this.hintText,
    required this.labelText,
    required this.initialValue,
    required this.fieldName,
    required this.validation,
    this.isPhone = false,
  });

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _txt = TextEditingController();
  final FocusNode _fn = FocusNode();

  @override
  void initState() {
    // Gán giá trị ban đầu cho ô nhập liệu
    _txt.text = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // Hiển thị nội dung dialog
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hiển thị tiêu đề
            Text(
              widget.title,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 16),

            // Form nhập liệu
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _txt,
                focusNode: _fn,
                validator: widget.validation,
                keyboardType: widget.isPhone ? TextInputType.phone : TextInputType.text, // Loại bàn phím nhập liệu
                inputFormatters: widget.isPhone
                    ? [FilteringTextInputFormatter.digitsOnly] // Chỉ cho phép nhập số nếu là số điện thoại
                    : null,
                onFieldSubmitted: (value) => FocusScope.of(context).unfocus(), // Bỏ focus khi nhấn Enter
                decoration: InputDecoration(
                  hintText: widget.hintText, // Gợi ý trong ô nhập liệu
                  labelText: widget.labelText, // Nhãn của ô nhập liệu
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Nút cập nhật
            Consumer<AccountProvider>(
              builder: (context, value, child) {
                // Hiển thị loading khi đang cập nhật
                if (value.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ElevatedButton(
                  onPressed: () async {
                    FocusScope.of(context).unfocus(); // Bỏ focus khi nhấn nút

                    // Nếu giá trị không thay đổi, đóng dialog
                    if (_txt.text == widget.initialValue) {
                      Navigator.of(context).pop();
                      return;
                    }

                    // Xác thực dữ liệu
                    if (_formKey.currentState!.validate() && !value.isLoading) {
                      try {
                        ScaffoldMessenger.of(context).removeCurrentMaterialBanner(); // Xóa banner lỗi nếu có

                        // Gửi yêu cầu cập nhật
                        await value.update(
                          data: {widget.fieldName: _txt.text}, // Gửi dữ liệu cần cập nhật
                        ).whenComplete(() {
                          _formKey.currentState!.reset(); // Xóa dữ liệu form

                          // Hiển thị thông báo thành công
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Cập nhật thành công'),
                            ),
                          );

                          Navigator.of(context).pop();
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
                  child: const Text('Cập nhật'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
