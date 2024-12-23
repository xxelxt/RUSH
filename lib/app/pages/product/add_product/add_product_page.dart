import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:rush/app/constants/validation_type.dart';
import 'package:rush/app/pages/product/add_product/widgets/image_file_preview.dart';
import 'package:rush/app/providers/product_provider.dart';
import 'package:rush/app/widgets/error_banner.dart';
import 'package:rush/app/widgets/pick_image_source.dart';
import 'package:rush/core/domain/entities/product/product.dart';
import 'package:rush/utils/compress_image.dart';
import 'package:rush/utils/extension.dart';
import 'package:rush/utils/numeric_text_formatter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // TextEditingController
  final TextEditingController _txtProductName = TextEditingController();
  final TextEditingController _txtPrice = TextEditingController();
  final TextEditingController _txtDescription = TextEditingController();
  final TextEditingController _txtStock = TextEditingController();

  // FocusNode
  final FocusNode _fnProductName = FocusNode();
  final FocusNode _fnPrice = FocusNode();
  final FocusNode _fnDescription = FocusNode();
  final FocusNode _fnStock = FocusNode();

  // ImagePicker
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _productImages = []; // Danh sách ảnh sản phẩm

  ValidationType validation = ValidationType.instance;

  @override
  void dispose() {
    _txtProductName.dispose();
    _txtPrice.dispose();
    _txtDescription.dispose();
    _txtStock.dispose();

    _fnProductName.dispose();
    _fnPrice.dispose();
    _fnDescription.dispose();
    _fnStock.dispose();
    super.dispose();
  }

  Future<String> uploadImageToCloudinary(Uint8List imageBytes, String fileName) async {
    const String cloudName = 'rush-elt';
    const String uploadPreset = 'product_upload';

    final Uri uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    // Tạo request
    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: fileName,
      ));

    // Gửi request
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await http.Response.fromStream(response);
      final responseData = json.decode(responseBody.body);

      // Lấy URL ảnh sau khi tải lên thành công
      return responseData['secure_url'];
    } else {
      throw Exception('Tải ảnh lên Cloudinary thất bại với mã lỗi ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm sản phẩm'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Form nhập liệu
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tên sản phẩm
                    TextFormField(
                      controller: _txtProductName,
                      focusNode: _fnProductName,
                      validator: validation.emptyValidation,
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.name,
                      onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_fnPrice),
                      decoration: const InputDecoration(
                        hintText: 'Nhập tên sản phẩm',
                        labelText: 'Tên sản phẩm',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Giá sản phẩm
                    TextFormField(
                      controller: _txtPrice,
                      focusNode: _fnPrice,
                      validator: validation.emptyValidation,
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_fnDescription),
                      decoration: const InputDecoration(
                        hintText: 'Nhập giá của sản phẩm',
                        labelText: 'Giá sản phẩm',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Mô tả sản phẩm
                    TextFormField(
                      controller: _txtDescription,
                      focusNode: _fnDescription,
                      validator: validation.emptyValidation,
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.multiline,
                      minLines: 2,
                      maxLines: 10,
                      onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_fnStock),
                      decoration: const InputDecoration(
                        hintText: 'Nhập mô tả sản phẩm',
                        labelText: 'Mô tả sản phẩm',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Số lượng sản phẩm
                    TextFormField(
                      controller: _txtStock,
                      focusNode: _fnStock,
                      validator: validation.emptyValidation,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        NumericTextFormatter(),
                      ],
                      onFieldSubmitted: (value) => FocusScope.of(context).unfocus(),
                      decoration: const InputDecoration(
                        hintText: 'Nhập số lượng sản phẩm',
                        labelText: 'Số lượng',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Hình ảnh sản phẩm
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Ảnh sản phẩm'),
                        TextButton(
                          onPressed: () async {
                            if (_productImages.length >= 5) return; // Giới hạn 5 ảnh

                            ImageSource? pickImageSource = await showDialog(
                              context: context,
                              builder: (context) {
                                return const PickImageSource(); // Hộp thoại chọn nguồn ảnh
                              },
                            );

                            if (pickImageSource != null) {
                              XFile? image = await _picker.pickImage(source: pickImageSource);
                              if (image != null) {
                                setState(() {
                                  _productImages.add(image);
                                });
                              }
                            }
                          },
                          child: const Text('Thêm ảnh'),
                        ),
                      ],
                    ),
                    _productImages.isEmpty
                        ? Text(
                      'Tải lên tối đa 5 ảnh',
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                        : Wrap(
                      children: [
                        ..._productImages.map((e) {
                          return ImageFilePreview(
                            imageFile: File(e.path), // Hiển thị ảnh từ file
                            onTap: () {
                              setState(() {
                                _productImages.remove(e); // Xóa ảnh khỏi danh sách
                              });
                            },
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Nút thêm sản phẩm
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Consumer<ProductProvider>(
              builder: (context, value, child) {
                if (value.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ElevatedButton(
                  child: const Text('Thêm'),
                  onPressed: () async {
                    FocusScope.of(context).unfocus();

                    if (_productImages.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Bạn phải thêm tối thiểu 1 ảnh và tối đa 5 ảnh sản phẩm'),
                        ),
                      );
                      return;
                    }

                    if (_formKey.currentState!.validate() && !value.isLoading) {
                      try {
                        value.setLoading = true;

                        ScaffoldMessenger.of(context).removeCurrentMaterialBanner();

                        List<String> productImage = [];

                        for (var element in _productImages) {
                          Uint8List image = await element.readAsBytes();

                          // Nén ảnh
                          image = await CompressImage.startCompress(image);

                          try {
                            // Gửi ảnh lên Cloudinary
                            String imageUrl = await uploadImageToCloudinary(image, element.name);
                            productImage.add(imageUrl);
                          } catch (e) {
                            throw Exception('Lỗi khi tải ảnh lên Cloudinary: $e');
                          }
                        }

                        // Tạo đối tượng sản phẩm
                        Product data = Product(
                          productId: ''.generateUID(),
                          productName: _txtProductName.text,
                          productPrice: NumberFormat().parse(_txtPrice.text).toDouble(),
                          productDescription: _txtDescription.text,
                          productImage: productImage,
                          totalReviews: 0,
                          rating: 0,
                          isDeleted: false,
                          stock: int.parse(_txtStock.text),
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                        );

                        await value.add(data: data).whenComplete(() {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Thêm sản phẩm thành công'),
                            ),
                          );
                          value.loadListProduct(); // Tải lại danh sách sản phẩm
                        });
                      } catch (e) {
                        value.setLoading = false;
                        if (mounted) {
                          ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
                          ScaffoldMessenger.of(context).showMaterialBanner(
                            errorBanner(context: context, msg: e.toString()),
                          );
                        }
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
