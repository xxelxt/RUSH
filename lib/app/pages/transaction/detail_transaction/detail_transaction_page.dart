import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rush/app/pages/transaction/detail_transaction/widgets/action_transaction_button.dart';
import 'package:rush/app/pages/transaction/detail_transaction/widgets/admin_action_transaction_button.dart';
import 'package:rush/app/pages/transaction/detail_transaction/widgets/customer_information.dart';
import 'package:rush/app/pages/transaction/detail_transaction/widgets/detail_transaction_product.dart';
import 'package:rush/app/pages/transaction/detail_transaction/widgets/order_summary_column.dart';
import 'package:rush/app/pages/transaction/detail_transaction/widgets/payment_summary_column.dart';
import 'package:rush/app/pages/transaction/detail_transaction/widgets/purchased_date.dart';
import 'package:rush/app/pages/transaction/detail_transaction/widgets/subtotal_row.dart';
import 'package:rush/app/pages/transaction/detail_transaction/widgets/transaction_status_row.dart';
import 'package:rush/app/providers/transaction_provider.dart';
import 'package:rush/config/flavor_config.dart';

class DetailTransactionPage extends StatefulWidget {
  const DetailTransactionPage({super.key});

  @override
  State<DetailTransactionPage> createState() => _DetailTransactionPageState();
}

class _DetailTransactionPageState extends State<DetailTransactionPage> {
  FlavorConfig flavor = FlavorConfig.instance;

  @override
  void initState() {
    Future.microtask(() {
      String transactionId = ModalRoute.of(context)!.settings.arguments as String;
      context.read<TransactionProvider>().loadDetailTransaction(transactionId: transactionId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết đơn hàng'),
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, value, child) {
          if (value.isLoadingDetail) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Trạng thái đơn hàng
                      _buildRoundedContainer(
                        context,
                        child: TransactionStatusRow(
                          status: value.detailTransaction!.transactionStatus!,
                          transactionID: value.detailTransaction!.transactionId,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Ngày mua hàng
                      _buildRoundedContainer(
                        context,
                        child: PurchasedDate(
                          date: value.detailTransaction!.createdAt!,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Thông tin khách hàng (admin)
                      if (flavor.flavor == Flavor.admin)
                        _buildRoundedContainer(
                          context,
                          child: CustomerInformation(
                            customer: value.detailTransaction!.account!,
                          ),
                        ),
                      if (flavor.flavor == Flavor.admin) const SizedBox(height: 12),

                      // Chi tiết sản phẩm đã mua
                      _buildRoundedContainer(
                        context,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Chi tiết sản phẩm',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            const SizedBox(height: 8),
                            ...value.detailTransaction!.purchasedProduct.map(
                                  (item) => DetailTransactionProduct(item: item),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Tổng giá trị phụ
                      _buildRoundedContainer(
                        context,
                        child: SubtotalRow(
                          subtotal: value.detailTransaction!.subTotal!,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Tổng giá trị đơn hàng và phí dịch vụ
                      _buildRoundedContainer(
                        context,
                        child: OrderSummaryColumn(
                          countItems: value.countItems,
                          totalPrice: value.detailTransaction!.totalPrice!,
                          shippingFee: value.detailTransaction!.shippingFee!,
                          shippingAddress: value.detailTransaction!.shippingAddress!,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Thông tin thanh toán
                      _buildRoundedContainer(
                        context,
                        child: PaymentSummaryColumn(
                          totalBill: value.detailTransaction!.totalBill!,
                          serviceFee: value.detailTransaction!.serviceFee!,
                          totalPay: value.detailTransaction!.totalPay!,
                          paymentMethod: value.detailTransaction!.paymentMethod!,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Nút hành động
              flavor.flavor == Flavor.admin
                  ? AdminActionTransactionButton(
                transactionID: value.detailTransaction!.transactionId,
                transactionStatus: value.detailTransaction!.transactionStatus!,
              )
                  : ActionTransactionButton(
                transactionStatus: value.detailTransaction!.transactionStatus!,
                data: value.detailTransaction!,
              ),
            ],
          );
        },
      ),
    );
  }

  // Hàm tiện ích để tạo Container bo tròn
  Widget _buildRoundedContainer(BuildContext context, {required Widget child}) {
    // Kiểm tra trạng thái chế độ tối
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // Áp dụng màu nền dựa trên chế độ sáng/tối
        color: isDarkMode ? Color(0xFF201710) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // Thay đổi độ mờ của bóng dựa trên chế độ sáng/tối
            color: isDarkMode ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
