import 'package:rush/app/pages/transaction/detail_transaction/widgets/review_product_form.dart';
import 'package:rush/app/providers/account_provider.dart';
import 'package:rush/app/providers/transaction_provider.dart';
import 'package:rush/core/domain/entities/account/account.dart';
import 'package:rush/core/domain/entities/review/review.dart';
import 'package:rush/core/domain/entities/transaction/transaction.dart';
import 'package:rush/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActionTransactionButton extends StatelessWidget {
  final int transactionStatus;
  final Transaction data;

  const ActionTransactionButton({super.key, required this.transactionStatus, required this.data});

  @override
  Widget build(BuildContext context) {
    void Function()? onPressed;
    String labelText = '';

    // Xác định trạng thái hiện tại của giao dịch
    TransactionStatus status = TransactionStatus.values.where((element) => element.value == transactionStatus).first;

    switch (status) {
      case TransactionStatus.processed:
        labelText = 'Đang xử lý';
        // Không cần hành động khi trạng thái là "Đang xử lý"
        break;

      case TransactionStatus.sent:
        labelText = 'Đã gửi hàng';
        // Không cần hành động khi trạng thái là "Đã gửi hàng"
        break;

      case TransactionStatus.arrived:
        labelText = 'Đã giao hàng';
        // Hành động khi người dùng xác nhận đã nhận hàng
        onPressed = () {
          context.read<TransactionProvider>().accept();
        };
        break;

      case TransactionStatus.done:
        labelText = 'Gửi đánh giá';
        // Hành động khi trạng thái là "Đã hoàn thành"
        onPressed = () async {
          List<Review> dataReview = [];

          // Lấy thông tin tài khoản người dùng hiện tại
          Account currentUser = context.read<AccountProvider>().account;

          // Tạo danh sách các đánh giá từ sản phẩm trong giao dịch
          dataReview.addAll(
            data.purchasedProduct.map(
                  (e) => Review(
                reviewId: ''.generateUID(),
                productId: e.productId,
                product: e.product!,
                accountId: data.accountId,
                star: 0,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
                reviewerName: currentUser.fullName,
              ),
            ),
          );

          // Hiển thị hộp thoại đánh giá sản phẩm
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ...dataReview.map(
                              (review) => ReviewProductForm(
                            data: review,
                            onTapStar: (star) {
                              // Gán số sao đánh giá cho từng sản phẩm
                              setState(() {
                                review.star = star;
                              });
                            },
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Consumer<TransactionProvider>(
                            builder: (context, value, child) {
                              if (value.isLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              return ElevatedButton(
                                onPressed: dataReview.every((element) => element.star > 0)
                                    ? () async {
                                  // Gửi đánh giá cho giao dịch
                                  await value
                                      .submitReview(
                                    transactionId: data.transactionId,
                                    data: dataReview,
                                  )
                                      .whenComplete(
                                        () => Navigator.of(context).pop(),
                                  );
                                }
                                    : null,
                                child: const Text('Gửi đánh giá'),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  );
                },
              );
            },
          );
        };
        break;

      case TransactionStatus.rejected:
        labelText = 'Không nhận hàng/Bị từ chối';
        // Không cần hành động khi trạng thái là "Bị từ chối"
        break;

      case TransactionStatus.reviewed:
        labelText = 'Đã đánh giá';
        // Không cần hành động khi trạng thái là "Đã đánh giá"
        break;

      default:
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16.0),
      child: Consumer<TransactionProvider>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ElevatedButton(
            onPressed: onPressed,
            child: Text(labelText),
          );
        },
      ),
    );
  }
}
