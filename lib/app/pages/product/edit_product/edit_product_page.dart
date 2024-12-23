import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:rush/app/constants/validation_type.dart';
import 'package:rush/utils/compress_image.dart';
import 'widgets/image_product_preview.dart';
import 'package:rush/app/providers/product_provider.dart';
import 'package:rush/app/widgets/error_banner.dart';
import 'package:rush/app/widgets/pick_image_source.dart';
import 'package:rush/core/domain/entities/product/product.dart';
import 'package:rush/utils/numeric_text_formatter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditProductPage extends StatefulWidget {
  const EditProductPage({super.key});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late Product dataProduct;

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
  final List<XFile> _productImages = []; // Danh sách ảnh mới được chọn

  ValidationType validation = ValidationType.instance;

  Future<String> uploadImageToCloudinary(Uint8List imageBytes, String fileName) async {
    const String cloudName = 'rush-elt';
    const String uploadPreset = 'product_upload';

    final Uri uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    // Tạo yêu cầu gửi ảnh
    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = uploadPreset
      ..fields['folder'] = 'Products'
      ..files.add(http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: fileName,
      ));

    // Thực hiện gửi yêu cầu
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await http.Response.fromStream(response);
      final responseData = json.decode(responseBody.body);

      // Trả về URL của ảnh trên Cloudinary
      return responseData['secure_url'];
    } else {
      throw Exception('Tải ảnh lên Cloudinary thất bại với mã lỗi ${response.statusCode}');
    }
  }

  @override
  void initState() {
    // Lấy dữ liệu sản phẩm từ tham số truyền vào và khởi tạo các trường nhập liệu
    Future.microtask(() {
      setState(() {
        dataProduct = ModalRoute.of(context)!.settings.arguments as Product;

        _txtProductName.text = dataProduct.productName;
        _txtPrice.text = '${dataProduct.productPrice}';
        _txtDescription.text = dataProduct.productDescription;
        _txtStock.text = NumberFormat('#,###').format(dataProduct.stock);
      });
    });
    super.initState();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cập nhật sản phẩm'),
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
                    // Nhập tên sản phẩm
                    TextFormField(
                      controller: _txtProductName,
                      focusNode: _fnProductName,
                      validator: validation.emptyValidation,
                      keyboardType: TextInputType.name,
                      onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_fnPrice),
                      decoration: const InputDecoration(
                        hintText: 'Nhập tên sản phẩm',
                        labelText: 'Tên sản phẩm',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Nhập giá sản phẩm
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

                    // Nhập mô tả sản phẩm
                    TextFormField(
                      controller: _txtDescription,
                      focusNode: _fnDescription,
                      validator: validation.emptyValidation,
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

                    // Nhập số lượng sản phẩm
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

                    // Khu vực quản lý ảnh sản phẩm
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Ảnh sản phẩm'),
                        TextButton(
                          onPressed: () async {
                            // Chọn ảnh từ thư viện hoặc máy ảnh
                            int countImage = dataProduct.productImage.length;
                            countImage += _productImages.length;
                            if (_productImages.isNotEmpty && countImage >= 5) return;

                            ImageSource? pickImageSource = await showDialog(
                              context: context,
                              builder: (context) {
                                return const PickImageSource();
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
                    _productImages.isEmpty && (dataProduct.productImage.isEmpty)
                        ? Text(
                      'Tải lên tối đa 5 ảnh',
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                        : Wrap(
                      children: [
                        ...dataProduct.productImage.map(
                              (e) => ImageProductPreview(
                            image: CachedNetworkImage(
                              imageUrl: e,
                              fit: BoxFit.cover,
                              width: 64,
                              height: 64,
                              progressIndicatorBuilder: (_, child, loadingProgress) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.progress,
                                  ),
                                );
                              },
                              errorWidget: (context, error, stackTrace) {
                                return const Icon(Icons.error);
                              },
                            ),
                            onTap: () {
                              setState(() {
                                dataProduct.productImage.remove(e);
                              });
                            },
                          ),
                        ),
                        ..._productImages.map((e) {
                          return ImageProductPreview(
                            image: Image.file(
                              File(e.path),
                              fit: BoxFit.cover,
                              width: 64,
                              height: 64,
                            ),
                            onTap: () {
                              setState(() {
                                _productImages.remove(e);
                              });
                            },
                          );
                        })
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Nút cập nhật sản phẩm
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            child: Consumer<ProductProvider>(
              builder: (context, value, child) {
                if (value.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ElevatedButton(
                  child: const Text('Cập nhật'),
                  onPressed: () async {
                    FocusScope.of(context).unfocus();

                    // Kiểm tra nếu không có ảnh sản phẩm
                    if (_productImages.isEmpty && (dataProduct.productImage.length + _productImages.length) == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Bạn phải thêm tối thiểu 1 ảnh và tối đa 5 ảnh sản phẩm'),
                        ),
                      );
                      return;
                    }

                    // Xử lý nếu tất cả dữ liệu hợp lệ
                    if (_formKey.currentState!.validate() && !value.isLoading) {
                      try {
                        value.setLoading = true;

                        ScaffoldMessenger.of(context).removeCurrentMaterialBanner();

                        List<String> productImage = [...dataProduct.productImage];

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

                        // Cập nhật thông tin sản phẩm
                        Product data = Product(
                          productId: dataProduct.productId,
                          productName: _txtProductName.text,
                          productPrice: NumberFormat().parse(_txtPrice.text).toDouble(),
                          productDescription: _txtDescription.text,
                          productImage: productImage,
                          totalReviews: dataProduct.totalReviews,
                          rating: dataProduct.rating,
                          isDeleted: false,
                          stock: int.parse(_txtStock.text),
                          createdAt: dataProduct.createdAt,
                          updatedAt: DateTime.now(),
                        );

                        await value.update(data: data).whenComplete(() {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Cập nhật sản phẩm thành công'),
                            ),
                          );
                          value.loadDetailProduct(productId: data.productId);
                          value.loadListProduct();
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
