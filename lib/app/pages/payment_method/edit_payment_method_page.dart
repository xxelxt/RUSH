import 'package:rush/app/constants/validation_type.dart';
import 'package:rush/app/providers/payment_method_provider.dart';
import 'package:rush/app/widgets/error_banner.dart';
import 'package:rush/core/domain/entities/payment_method/payment_method.dart';
import 'package:rush/utils/card_expiration_formatter.dart';
import 'package:rush/utils/card_number_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EditPaymentMethodPage extends StatefulWidget {
  const EditPaymentMethodPage({super.key});

  @override
  State<EditPaymentMethodPage> createState() => _EditPaymentMethodPageState();
}

class _EditPaymentMethodPageState extends State<EditPaymentMethodPage> {
  // Lưu trữ thông tin phương thức thanh toán được chỉnh sửa
  late PaymentMethod paymentMethod;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // TextEditingController
  final TextEditingController _txtCardNumber = TextEditingController();
  final TextEditingController _txtCardholderName = TextEditingController();
  final TextEditingController _txtExpiryDate = TextEditingController();
  final TextEditingController _txtCVV = TextEditingController();

  // FocusNode
  final FocusNode _fnCardNumber = FocusNode();
  final FocusNode _fnCardholderName = FocusNode();
  final FocusNode _fnExpiryDate = FocusNode();
  final FocusNode _fnCVV = FocusNode();

  ValidationType validation = ValidationType.instance;

  bool _isLoading = false;

  @override
  void initState() {
    // Lấy thông tin phương thức thanh toán được truyền từ màn hình trước
    Future.microtask(() {
      paymentMethod = ModalRoute.of(context)!.settings.arguments as PaymentMethod;

      // Gán dữ liệu vào các TextEditingController
      _txtCardNumber.text = paymentMethod.cardNumber;
      _txtCardholderName.text = paymentMethod.cardholderName;
      _txtExpiryDate.text = paymentMethod.expiryDate;
      _txtCVV.text = paymentMethod.cvv;
    });

    super.initState();
  }

  @override
  void dispose() {
    _txtCardNumber.dispose();
    _txtCardholderName.dispose();
    _txtExpiryDate.dispose();
    _txtCVV.dispose();

    _fnCardNumber.dispose();
    _fnCardholderName.dispose();
    _fnExpiryDate.dispose();
    _fnCVV.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cập nhật phương thức thanh toán'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Form nhập liệu
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nhập số thẻ
                    TextFormField(
                      controller: _txtCardNumber,
                      focusNode: _fnCardNumber,
                      validator: validation.emptyValidation,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CardNumberFormatter(), // Định dạng số thẻ
                        LengthLimitingTextInputFormatter(19), // Giới hạn độ dài
                      ],
                      onFieldSubmitted: (value) =>
                          FocusScope.of(context).requestFocus(_fnCardholderName),
                      decoration: const InputDecoration(
                        hintText: 'Nhập số thẻ của bạn',
                        labelText: 'Số thẻ',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Nhập tên chủ thẻ
                    TextFormField(
                      controller: _txtCardholderName,
                      focusNode: _fnCardholderName,
                      validator: validation.emptyValidation,
                      keyboardType: TextInputType.name,
                      onFieldSubmitted: (value) =>
                          FocusScope.of(context).requestFocus(_fnExpiryDate),
                      decoration: const InputDecoration(
                        hintText: 'Nhập tên chủ thẻ',
                        labelText: 'Chủ thẻ',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Nhập ngày hết hạn
                    TextFormField(
                      controller: _txtExpiryDate,
                      focusNode: _fnExpiryDate,
                      validator: validation.emptyValidation,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CardExpirationFormatter(), // Định dạng MM/YY
                        LengthLimitingTextInputFormatter(7),
                      ],
                      onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_fnCVV),
                      decoration: const InputDecoration(
                        hintText: 'MM/YY',
                        labelText: 'Ngày hết hạn',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Nhập CVV
                    TextFormField(
                      controller: _txtCVV,
                      focusNode: _fnCVV,
                      validator: validation.cvvValidation,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      onFieldSubmitted: (value) => FocusScope.of(context).unfocus(),
                      decoration: const InputDecoration(
                        hintText: 'Nhập số CVV',
                        labelText: 'CVV',
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),

          // Nút cập nhật phương thức thanh toán
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Consumer<PaymentMethodProvider>(
              builder: (context, value, child) {
                // Hiển thị vòng tròn loading khi đang xử lý
                if (_isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ElevatedButton(
                  child: const Text('Cập nhật'),
                  onPressed: () async {
                    FocusScope.of(context).unfocus(); // Ẩn bàn phím

                    // Kiểm tra form hợp lệ trước khi xử lý
                    if (_formKey.currentState!.validate() && !_isLoading) {
                      try {
                        setState(() {
                          _isLoading = true; // Bật trạng thái loading
                        });

                        ScaffoldMessenger.of(context).removeCurrentMaterialBanner();

                        // Tạo đối tượng PaymentMethod mới
                        PaymentMethod data = PaymentMethod(
                          paymentMethodId: paymentMethod.paymentMethodId, // Giữ nguyên ID
                          cardNumber: _txtCardNumber.text,
                          cardholderName: _txtCardholderName.text,
                          expiryDate: _txtExpiryDate.text,
                          cvv: _txtCVV.text,
                          createdAt: paymentMethod.createdAt, // Giữ nguyên thời gian tạo
                          updatedAt: DateTime.now(), // Cập nhật thời gian chỉnh sửa
                        );

                        // Lấy ID tài khoản hiện tại
                        String accountId = FirebaseAuth.instance.currentUser!.uid;

                        // Gửi dữ liệu lên Provider để cập nhật
                        await value.update(accountId: accountId, data: data).whenComplete(() {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Cập nhật phương thức thanh toán thành công'),
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
