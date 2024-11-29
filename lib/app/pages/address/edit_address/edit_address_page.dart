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
  late Address address;

  // Form Key (For validation)
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // TextEditingController
  final TextEditingController _txtName = TextEditingController();
  final TextEditingController _txtAddress = TextEditingController();
  final TextEditingController _txtCity = TextEditingController();
  final TextEditingController _txtZipCode = TextEditingController();

  // FocusNode
  final FocusNode _fnName = FocusNode();
  final FocusNode _fnAddress = FocusNode();
  final FocusNode _fnCity = FocusNode();
  final FocusNode _fnZipCode = FocusNode();

  // Validation
  ValidationType validation = ValidationType.instance;

  bool _isLoading = false;

  @override
  void initState() {
    Future.microtask(() {
      address = ModalRoute.of(context)!.settings.arguments as Address;

      _txtName.text = address.name;
      _txtAddress.text = address.address;
      _txtCity.text = address.city;
      _txtZipCode.text = address.zipCode;
    });
    super.initState();
  }

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
        title: const Text('Edit Address'),
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
                    // Input Address Name
                    TextFormField(
                      controller: _txtName,
                      focusNode: _fnName,
                      validator: validation.emptyValidation,
                      keyboardType: TextInputType.name,
                      onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_fnAddress),
                      decoration: const InputDecoration(
                        hintText: 'Type your address name (ex: Home)',
                        labelText: 'Name',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Input Street Address
                    TextFormField(
                      controller: _txtAddress,
                      focusNode: _fnAddress,
                      validator: validation.emptyValidation,
                      keyboardType: TextInputType.streetAddress,
                      minLines: 2,
                      maxLines: 10,
                      onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_fnCity),
                      decoration: const InputDecoration(
                        hintText: 'Type your street address',
                        labelText: 'Address',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Input Address City
                    TextFormField(
                      controller: _txtCity,
                      focusNode: _fnCity,
                      validator: validation.emptyValidation,
                      keyboardType: TextInputType.text,
                      onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_fnZipCode),
                      decoration: const InputDecoration(
                        hintText: 'Type address city',
                        labelText: 'City',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Input Address Zip Code
                    TextFormField(
                      controller: _txtZipCode,
                      focusNode: _fnZipCode,
                      validator: validation.emptyValidation,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onFieldSubmitted: (value) => FocusScope.of(context).unfocus(),
                      decoration: const InputDecoration(
                        hintText: 'Type your address zip code',
                        labelText: 'Zip Code',
                      ),
                    ),
                    const SizedBox(height: 16),
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
            child: Consumer<AddressProvider>(
              builder: (context, value, child) {
                if (_isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ElevatedButton(
                  child: const Text('Edit Address'),
                  onPressed: () async {
                    FocusScope.of(context).unfocus();

                    if (_formKey.currentState!.validate() && !_isLoading) {
                      try {
                        setState(() {
                          _isLoading = true;
                        });

                        ScaffoldMessenger.of(context).removeCurrentMaterialBanner();

                        Address data = Address(
                          addressId: address.addressId,
                          name: _txtName.text,
                          address: _txtAddress.text,
                          city: _txtCity.text,
                          zipCode: _txtZipCode.text,
                          createdAt: address.createdAt,
                          updatedAt: DateTime.now(),
                        );

                        String accountId = FirebaseAuth.instance.currentUser!.uid;

                        await value.update(accountId: accountId, data: data).whenComplete(() {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Address Updated Successfully'),
                            ),
                          );
                          value.getAddress(accountId: accountId);
                        });
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
                          ScaffoldMessenger.of(context).showMaterialBanner(
                            errorBanner(context: context, msg: e.toString()),
                          );
                        }
                        setState(() {
                          _isLoading = false;
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
