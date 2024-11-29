import 'dart:io';

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
  // Form Key (For validation)
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

  // Images
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _productImages = [];

  // Validation
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Form
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
                    // Input Product Name
                    TextFormField(
                      controller: _txtProductName,
                      focusNode: _fnProductName,
                      validator: validation.emptyValidation,
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.name,
                      onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_fnPrice),
                      decoration: const InputDecoration(
                        hintText: 'Type your product name',
                        labelText: 'Product Name',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Input Price
                    TextFormField(
                      controller: _txtPrice,
                      focusNode: _fnPrice,
                      validator: validation.emptyValidation,
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_fnDescription),
                      decoration: const InputDecoration(
                        hintText: 'Type your product price',
                        labelText: 'Product Price',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Input Description
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
                        hintText: 'Type product description',
                        labelText: 'Description',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Input Product Stock
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
                        hintText: 'Type your product stock',
                        labelText: 'Stock',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Product Images
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Product Image'),
                        TextButton(
                          onPressed: () async {
                            if (_productImages.isNotEmpty && _productImages.length >= 5) return;

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
                          child: const Text('Add Image'),
                        ),
                      ],
                    ),
                    _productImages.isEmpty
                        ? Text(
                            'Maximum 5 images',
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        : Wrap(
                            children: [
                              ..._productImages.map((e) {
                                return ImageFilePreview(
                                  imageFile: File(e.path),
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

          // Add Product Button
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
                  child: const Text('Add Product'),
                  onPressed: () async {
                    FocusScope.of(context).unfocus();

                    if (_productImages.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('You must add at least 1 to 5 product images'),
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

                          image = await CompressImage.startCompress(image);

                          Reference ref = FirebaseStorage.instance.ref().child('Products/${element.name}');

                          // Save the image to firebase storage
                          final dataImage = await ref.putData(image);

                          // Get the img url from Firebase Storage
                          String imageUrl = await dataImage.ref.getDownloadURL();
                          productImage.add(imageUrl);
                        }

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
                              content: Text('Product Added Successfully'),
                            ),
                          );
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
