import 'package:rush/app/constants/validation_type.dart';
import 'package:rush/app/providers/address_provider.dart';
import 'package:rush/app/widgets/error_banner.dart';
import 'package:rush/core/domain/entities/address/address.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EditAddressPage extends StatefulWidget {
  const EditAddressPage({super.key});

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  // Lưu trữ địa chỉ cần chỉnh sửa
  late Address address;

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

  // ValidationType instance để xác thực dữ liệu
  ValidationType validation = ValidationType.instance;

  bool _isLoading = false;

  @override
  void initState() {
    // Lấy dữ liệu địa chỉ từ tham số truyền vào khi mở trang
    Future.microtask(() {
      address = ModalRoute.of(context)!.settings.arguments as Address;

      // Gán giá trị ban đầu cho các trường nhập
      _txtName.text = address.name;
      _txtAddress.text = address.address;
      _txtCity.text = address.city;
      _txtZipCode.text = address.zipCode;
    });
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
        title: const Text('Cập nhật địa chỉ'),
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

                    TextFormField(
                      controller: _txtName,
                      focusNode: _fnName,
                      validator: validation.emptyValidation,
                      keyboardType: TextInputType.name,
                      onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_fnAddress), // Chuyển focus
                      decoration: const InputDecoration(
                        hintText: 'Nhập loại địa chỉ của bạn (vd: Nhà riêng)',
                        labelText: 'Loại địa chỉ',
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _txtAddress,
                      focusNode: _fnAddress,
                      validator: validation.emptyValidation,
                      keyboardType: TextInputType.streetAddress,
                      minLines: 2,
                      maxLines: 10,
                      onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_fnCity),
                      decoration: const InputDecoration(
                        hintText: 'Nhập địa chỉ của bạn',
                        labelText: 'Địa chỉ',
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _txtCity,
                      focusNode: _fnCity,
                      validator: validation.emptyValidation,
                      keyboardType: TextInputType.text,
                      onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_fnZipCode),
                      decoration: const InputDecoration(
                        hintText: 'Nhập tỉnh/thành phố',
                        labelText: 'Tỉnh/thành phố',
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _txtZipCode,
                      focusNode: _fnZipCode,
                      validator: validation.emptyValidation,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
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

          // Nút cập nhật địa chỉ
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Consumer<AddressProvider>( // Sử dụng Provider để quản lý trạng thái địa chỉ
              builder: (context, value, child) {
                // Hiển thị ProgressIndicator nếu đang tải
                if (_isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ElevatedButton(
                  child: const Text('Cập nhật'),
                  onPressed: () async {
                    FocusScope.of(context).unfocus(); // Ẩn bàn phím

                    // Kiểm tra form hợp lệ và không đang tải
                    if (_formKey.currentState!.validate() && !_isLoading) {
                      try {
                        setState(() {
                          _isLoading = true; // Chuyển trạng thái loading
                        });

                        ScaffoldMessenger.of(context).removeCurrentMaterialBanner();

                        // Tạo đối tượng Address với dữ liệu mới
                        Address data = Address(
                          addressId: address.addressId, // Giữ nguyên ID địa chỉ
                          name: _txtName.text,
                          address: _txtAddress.text,
                          city: _txtCity.text,
                          zipCode: _txtZipCode.text,
                          createdAt: address.createdAt, // Giữ nguyên thời gian tạo
                          updatedAt: DateTime.now(), // Cập nhật thời gian chỉnh sửa
                        );

                        String accountId = FirebaseAuth.instance.currentUser!.uid; // Lấy ID người dùng hiện tại

                        // Cập nhật địa chỉ qua Provider
                        await value.update(accountId: accountId, data: data).whenComplete(() {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Cập nhật địa chỉ thành công'),
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
