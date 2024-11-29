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
  // Form Key (For validation)
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // TextEditingController & FocusNode
  final TextEditingController _txt = TextEditingController();
  final FocusNode _fn = FocusNode();

  @override
  void initState() {
    _txt.text = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(
              height: 16,
            ),
            // Input Email Address
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _txt,
                focusNode: _fn,
                validator: widget.validation,
                keyboardType: widget.isPhone ? TextInputType.phone : TextInputType.text,
                inputFormatters: widget.isPhone
                    ? [
                        FilteringTextInputFormatter.digitsOnly,
                      ]
                    : null,
                onFieldSubmitted: (value) => FocusScope.of(context).unfocus(),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  labelText: widget.labelText,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Update Button
            Consumer<AccountProvider>(
              builder: (context, value, child) {
                if (value.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ElevatedButton(
                  onPressed: () async {
                    FocusScope.of(context).unfocus();

                    // If the value isn't changed
                    if (_txt.text == widget.initialValue) {
                      Navigator.of(context).pop();
                      return;
                    }

                    // Check if the form valid
                    if (_formKey.currentState!.validate() && !value.isLoading) {
                      try {
                        ScaffoldMessenger.of(context).removeCurrentMaterialBanner();

                        await value.update(
                          data: {widget.fieldName: _txt.text},
                        ).whenComplete(() {
                          _formKey.currentState!.reset();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Update Success'),
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
                  child: const Text('Update'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
