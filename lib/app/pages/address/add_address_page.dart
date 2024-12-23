import 'package:rush/app/constants/validation_type.dart';
import 'package:rush/app/providers/address_provider.dart';
import 'package:rush/app/widgets/error_banner.dart';
import 'package:rush/core/domain/entities/address/address.dart';

import 'package:rush/utils/extension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // TextEditingController
  final TextEditingController _txtName = TextEditingController();
  final TextEditingController _txtAddress = TextEditingController();
  final TextEditingController _txtCity = TextEditingController();
  final TextEditingController _txtZipCode = TextEditingController();

  // FocusNode để quản lý focus trên các trường input
  final FocusNode _fnName = FocusNode();
  final FocusNode _fnAddress = FocusNode();
  final FocusNode _fnCity = FocusNode();
  final FocusNode _fnZipCode = FocusNode();

  // Instance của ValidationType để xác thực input
  ValidationType validation = ValidationType.instance;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  // Giải phóng bộ nhớ
  @override
  void dispose() {
    _txtName.dispose();
    _txtAddress.dispose();
    _txtCity.dispose();
    _txtZipCode.dispose();

    _fnName.dispose();
    _fnAddress.dispose();
    _fnCity.dispose();
    _fnZipCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm địa chỉ'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Form nhập địa chỉ
          Expanded(
            child: Form(
              key: _formKey, // Gắn form key để kiểm tra validation
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Input: Loại địa chỉ
                    TextFormField(
                      controller: _txtName, // Controller cho trường nhập
                      focusNode: _fnName, // FocusNode để quản lý focus
                      textCapitalization: TextCapitalization.words, // Viết hoa chữ cái đầu
                      validator: validation.emptyValidation, // Xác thực trường không rỗng
                      keyboardType: TextInputType.name, // Kiểu bàn phím cho tên
                      onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_fnAddress), // Chuyển focus
                      decoration: const InputDecoration(
                        hintText: 'Nhập loại địa chỉ của bạn (vd: Nhà riêng)',
                        labelText: 'Loại địa chỉ',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Input: Địa chỉ chi tiết
                    TextFormField(
                      controller: _txtAddress,
                      focusNode: _fnAddress,
                      validator: validation.emptyValidation,
                      keyboardType: TextInputType.streetAddress, // Kiểu bàn phím địa chỉ
                      textCapitalization: TextCapitalization.words,
                      minLines: 2, // Số dòng tối thiểu
                      maxLines: 10, // Số dòng tối đa
                      onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_fnCity),
                      decoration: const InputDecoration(
                        hintText: 'Nhập địa chỉ của bạn',
                        labelText: 'Địa chỉ',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Input: Thành phố
                    TextFormField(
                      controller: _txtCity,
                      focusNode: _fnCity,
                      validator: validation.emptyValidation,
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.text, // Kiểu bàn phím văn bản
                      onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_fnZipCode),
                      decoration: const InputDecoration(
                        hintText: 'Nhập tỉnh/thành phố',
                        labelText: 'Tỉnh/thành phố',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Input: Mã ZIP
                    TextFormField(
                      controller: _txtZipCode,
                      focusNode: _fnZipCode,
                      validator: validation.emptyValidation,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly, // Chỉ cho phép nhập số
                      ],
                      onFieldSubmitted: (value) => FocusScope.of(context).unfocus(), // Bỏ focus khi nhập xong
                      decoration: const InputDecoration(
                        hintText: 'Nhập mã ZIP',
                        labelText: 'Mã ZIP',
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),

          // Nút thêm địa chỉ
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Consumer<AddressProvider>( // Sử dụng Provider để quản lý trạng thái
              builder: (context, value, child) {
                // Nếu đang tải, hiển thị ProgressIndicator
                if (_isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ElevatedButton(
                  child: const Text('Thêm'),
                  onPressed: () async {
                    FocusScope.of(context).unfocus(); // Ẩn bàn phím

                    // Kiểm tra form hợp lệ và không đang tải
                    if (_formKey.currentState!.validate() && !_isLoading) {
                      try {
                        setState(() {
                          _isLoading = true; // Bắt đầu trạng thái loading
                        });

                        ScaffoldMessenger.of(context).removeCurrentMaterialBanner();

                        // Tạo đối tượng Address từ dữ liệu nhập
                        Address data = Address(
                          addressId: ''.generateUID(), // Tạo ID duy nhất
                          name: _txtName.text,
                          address: _txtAddress.text,
                          city: _txtCity.text,
                          zipCode: _txtZipCode.text,
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                        );

                        String accountId = FirebaseAuth.instance.currentUser!.uid; // Lấy ID người dùng hiện tại

                        // Gửi dữ liệu lên Provider để thêm địa chỉ
                        await value.add(accountId: accountId, data: data).whenComplete(() {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Thêm địa chỉ thành công'),
                            ),
                          );
                          value.getAddress(accountId: accountId); // Cập nhật danh sách địa chỉ
                        });
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
                          ScaffoldMessenger.of(context).showMaterialBanner(
                            errorBanner(context: context, msg: e.toString()),
                          );
                        }

                        setState(() {
                          _isLoading = false; // Kết thúc trạng thái loading
                        });
                      }
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
