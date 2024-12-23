import 'package:rush/app/pages/payment/widgets/select_payment_method.dart';
import 'package:rush/app/providers/account_provider.dart';
import 'package:rush/app/providers/cart_provider.dart';
import 'package:rush/app/providers/checkout_provider.dart';
import 'package:rush/app/providers/transaction_provider.dart';
import 'package:rush/app/widgets/error_banner.dart';
import 'package:rush/core/domain/entities/payment_method/payment_method.dart';
import 'package:rush/routes.dart';
import 'package:rush/themes/custom_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rush/utils/extension.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  // Phương thức thanh toán hiện tại
  PaymentMethod? paymentMethod;

  @override
  void initState() {
    // Lấy phương thức thanh toán mặc định từ tài khoản
    Future.microtask(() {
      setState(() {
        paymentMethod = context.read<AccountProvider>().account.primaryPaymentMethod;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán'),
      ),
      body: Consumer<CheckoutProvider>(
        builder: (context, value, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Chọn phương thức thanh toán
                      SelectPaymentMethod(
                        paymentMethod: paymentMethod,
                        selectPaymentMethod: () async {
                          // Chuyển đến màn hình quản lý phương thức thanh toán
                          var result = await NavigateRoute.toManagePaymentMethod(context: context, returnPaymentMethod: true);
                          setState(() {
                            paymentMethod = result; // Cập nhật phương thức thanh toán
                          });
                        },
                        // Xóa phương thức thanh toán hiện tại
                        removePaymentMethod: () {
                          setState(() {
                            paymentMethod = null;
                          });
                        },
                      ),
                      const SizedBox(height: 12),

                      // Tóm tắt thanh toán
                      Text(
                        'Phương thức thanh toán',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tổng giá trị đơn hàng',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            value.dataTransaction.totalBill?.toCurrency() ?? '-', // Hiển thị tổng giá trị đơn hàng
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Phí dịch vụ',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            value.dataTransaction.serviceFee?.toCurrency() ?? '-', // Hiển thị phí dịch vụ
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Tổng số tiền phải trả & nút thanh toán
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tổng tiền phải trả',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          value.dataTransaction.totalPay?.toCurrency() ?? '-', // Hiển thị tổng tiền phải trả
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: CustomColor.error,
                          ),
                        ),
                      ],
                    ),
                    Consumer<CheckoutProvider>(
                      builder: (context, value, child) {
                        // Hiển thị vòng tròn loading khi đang xử lý thanh toán
                        if (value.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return ElevatedButton(
                          onPressed: paymentMethod == null
                              ? null // Vô hiệu hóa nếu chưa chọn phương thức thanh toán
                              : () async {
                            if (value.isLoading) return; // Ngăn người dùng nhấn nhiều lần

                            try {
                              ScaffoldMessenger.of(context).removeCurrentMaterialBanner();

                              value.dataTransaction.paymentMethod = paymentMethod; // Gắn phương thức thanh toán
                              await value.payCheckout().whenComplete(() {
                                // Làm mới giỏ hàng sau khi thanh toán
                                context.read<CartProvider>().getCart(accountId: FirebaseAuth.instance.currentUser!.uid);

                                // Quay về màn hình đầu tiên
                                Navigator.of(context).popUntil((route) => route.isFirst);

                                // Hiển thị thông báo thành công
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Thanh toán đơn hàng thành công! Vui lòng xem lại chi tiết đơn hàng tại trang Đơn hàng',
                                    ),
                                  ),
                                );

                                // Tải lại danh sách giao dịch
                                context.read<TransactionProvider>().loadAccountTransaction();
                              });
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
                                ScaffoldMessenger.of(context).showMaterialBanner(
                                  errorBanner(context: context, msg: e.toString()),
                                );
                              }
                            }
                          },
                          child: const Text('Thanh toán'),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
