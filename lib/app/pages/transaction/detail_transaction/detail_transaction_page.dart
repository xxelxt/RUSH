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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      // Lấy transactionId từ tham số truyền
      String transactionId = ModalRoute.of(context)!.settings.arguments as String;
      // Gọi hàm để tải chi tiết giao dịch dựa trên transactionId
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

          // Hiển thị nội dung chi tiết đơn hàng
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hiển thị trạng thái đơn hàng và ID đơn hàng
                      TransactionStatusRow(
                        status: value.detailTransaction!.transactionStatus!,
                        transactionID: value.detailTransaction!.transactionId,
                      ),
                      const SizedBox(height: 8),

                      // Ngày mua hàng
                      PurchasedDate(
                        date: value.detailTransaction!.createdAt!,
                      ),
                      const SizedBox(height: 12),

                      // Thông tin khách hàng (admin)
                      if (flavor.flavor == Flavor.admin)
                        CustomerInformation(customer: value.detailTransaction!.account!),
                      if (flavor.flavor == Flavor.admin) const SizedBox(height: 12),

                      // Chi tiết sản phẩm đã mua
                      Text(
                        'Chi tiết sản phẩm',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      ...value.detailTransaction!.purchasedProduct.map(
                            (item) => DetailTransactionProduct(item: item),
                      ),

                      // Hiển thị tổng giá trị phụ
                      SubtotalRow(
                        subtotal: value.detailTransaction!.subTotal!,
                      ),
                      const SizedBox(height: 16),

                      // Tóm tắt đơn hàng
                      OrderSummaryColumn(
                        countItems: value.countItems,
                        totalPrice: value.detailTransaction!.totalPrice!,
                        shippingFee: value.detailTransaction!.shippingFee!,
                        shippingAddress: value.detailTransaction!.shippingAddress!,
                      ),
                      const SizedBox(height: 16),

                      // Tóm tắt thanh toán
                      PaymentSummaryColumn(
                        totalBill: value.detailTransaction!.totalBill!,
                        serviceFee: value.detailTransaction!.serviceFee!,
                        totalPay: value.detailTransaction!.totalPay!,
                        paymentMethod: value.detailTransaction!.paymentMethod!,
                      ),
                      const SizedBox(height: 16),
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
}
