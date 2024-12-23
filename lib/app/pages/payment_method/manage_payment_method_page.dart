import 'package:rush/app/providers/account_provider.dart';
import 'package:rush/app/providers/payment_method_provider.dart';
import 'package:rush/app/widgets/radio_card.dart';
import 'package:rush/core/domain/entities/payment_method/payment_method.dart';
import 'package:rush/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManagePaymentMethodPage extends StatefulWidget {
  const ManagePaymentMethodPage({super.key});

  @override
  State<ManagePaymentMethodPage> createState() => _ManagePaymentMethodPageState();
}

class _ManagePaymentMethodPageState extends State<ManagePaymentMethodPage> {
  // Có trả về phương thức thanh toán đã chọn không
  bool returnPaymentMethod = false;

  // ID người dùng hiện tại
  String accountId = FirebaseAuth.instance.currentUser!.uid;

  // Phương thức thanh toán đã chọn
  PaymentMethod? selectedPaymentMethod;

  bool _isLoading = false;

  @override
  void initState() {
    Future.microtask(
          () {
        // Nhận tham số xác định có cần trả về phương thức đã chọn không
        returnPaymentMethod = ModalRoute.of(context)!.settings.arguments as bool;

        // Lấy phương thức thanh toán chính hiện tại
        selectedPaymentMethod = context.read<AccountProvider>().account.primaryPaymentMethod;

        // Lấy danh sách phương thức thanh toán
        context.read<PaymentMethodProvider>().getPaymentMethod(accountId: accountId);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý phương thức thanh toán'),
        actions: [
          TextButton(
            onPressed: () {
              NavigateRoute.toAddPaymentMethod(context: context); // Chuyển tới trang thêm phương thức thanh toán
            },
            child: const Text('Thêm'),
          ),
        ],
      ),
      body: Consumer<PaymentMethodProvider>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return const Center(
              child: CircularProgressIndicator(), // Hiển thị vòng tròn loading nếu đang tải dữ liệu
            );
          }

          return Column(
            children: [
              // Danh sách phương thức thanh toán
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    children: [
                      // Nếu danh sách rỗng
                      if (value.listPaymentMethod.isEmpty)
                        Center(
                          child: Text(
                            'Bạn chưa thêm phương thức thanh toán nào',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),

                      // Hiển thị danh sách phương thức thanh toán
                      if (value.listPaymentMethod.isNotEmpty)
                        ...value.listPaymentMethod.map(
                              (e) => Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: RadioCard<PaymentMethod>(
                              title: e.cardholderName,
                              subtitle: e.cardNumber,
                              value: e,
                              selectedValue: selectedPaymentMethod,
                              onChanged: (value) {
                                setState(() {
                                  selectedPaymentMethod = value; // Cập nhật giá trị đã chọn
                                });
                              },

                              // Xóa phương thức thanh toán
                              onDelete: () {
                                value.delete(accountId: accountId, paymentMethodId: e.paymentMethodId);

                                // Nếu phương thức bị xóa là phương thức chính
                                if (selectedPaymentMethod == e) {
                                  selectedPaymentMethod = null;
                                  context.read<AccountProvider>().update(data: {
                                    'primary_payment_method': null,
                                  });
                                }
                              },
                              onEdit: () {
                                // Chuyển tới trang chỉnh sửa phương thức thanh toán
                                NavigateRoute.toEditPaymentMethod(context: context, paymentMethod: e);
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              if (value.listPaymentMethod.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: ElevatedButton(
                    onPressed: selectedPaymentMethod == null
                        ? null // Vô hiệu hóa nếu chưa chọn phương thức
                        : () async {
                      if (_isLoading) return;

                      // Nếu cần trả về phương thức đã chọn
                      if (returnPaymentMethod) {
                        Navigator.of(context).pop(selectedPaymentMethod);
                        return;
                      }

                      setState(() {
                        _isLoading = true; // Hiển thị trạng thái loading
                      });

                      PaymentMethod? oldData = context.read<AccountProvider>().account.primaryPaymentMethod;

                      // Đặt phương thức thanh toán làm mặc định
                      await value
                          .changePrimary(accountId: accountId, data: selectedPaymentMethod!, oldData: oldData)
                          .whenComplete(() async {
                        context.read<AccountProvider>().getProfile(); // Làm mới dữ liệu tài khoản
                        setState(() {
                          _isLoading = false;
                        });
                        Navigator.of(context).pop();
                      });
                    },
                    child: _isLoading
                        ? const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      ),
                    )
                        : returnPaymentMethod
                        ? const Text('Chọn phương thức thanh toán')
                        : const Text('Đặt làm mặc định'),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
