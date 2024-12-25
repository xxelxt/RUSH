import 'package:rush/app/pages/checkout/widgets/checkout_product_container.dart';
import 'package:rush/app/pages/checkout/widgets/select_shipping_address.dart';
import 'package:rush/app/providers/account_provider.dart';
import 'package:rush/app/providers/checkout_provider.dart';
import 'package:rush/core/domain/entities/address/address.dart';
import 'package:rush/routes.dart';
import 'package:rush/themes/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:rush/utils/extension.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  Address? shippingAddress;

  @override
  void initState() {
    Future.microtask(() {
      setState(() {
        // Lấy địa chỉ mặc định từ tài khoản
        shippingAddress = context.read<AccountProvider>().account.primaryAddress;
        // Cập nhật tổng hóa đơn dựa trên địa chỉ giao hàng
        context.read<CheckoutProvider>().updateTotalBill(shippingAddress: shippingAddress);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đặt hàng'),
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
                      // Chọn địa chỉ giao hàng
                      SelectShippingAddress(
                        shippingAddress: shippingAddress, // Địa chỉ giao hàng hiện tại
                        selectAddress: () async {
                          // Điều hướng đến màn hình quản lý địa chỉ
                          var result = await NavigateRoute.toManageAddress(context: context, returnAddress: true);
                          setState(() {
                            shippingAddress = result; // Cập nhật địa chỉ giao hàng
                            context.read<CheckoutProvider>().updateTotalBill(shippingAddress: shippingAddress);
                          });
                        },

                        // Xóa địa chỉ giao hàng
                        removeAddress: () {
                          setState(() {
                            shippingAddress = null;
                            context.read<CheckoutProvider>().updateTotalBill(shippingAddress: shippingAddress);
                          });
                        },
                      ),

                      // Hiển thị danh sách sản phẩm đã mua
                      ...value.dataTransaction.purchasedProduct.map(
                            (item) => CheckoutProductContainer(item: item),
                      ),
                      const SizedBox(height: 8),

                      // Tổng tiền hàng
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tổng tiền',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            value.dataTransaction.subTotal?.toCurrency() ?? '-', // Hiển thị tổng tiền hàng
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Tóm tắt đơn hàng
                      Text(
                        'Tóm tắt đơn hàng',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tổng giá trị (${value.countItems} sản phẩm)',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            value.dataTransaction.totalPrice?.toCurrency() ?? '-', // Tổng giá trị sản phẩm
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      if (shippingAddress != null) // Nếu có địa chỉ giao hàng
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Phí giao hàng',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              value.dataTransaction.shippingFee?.toCurrency() ?? '-', // Hiển thị phí giao hàng
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),

              // Tổng hóa đơn & nút chọn phương thức thanh toán
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tổng giá trị đơn hàng',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          value.dataTransaction.totalBill?.toCurrency() ?? '-', // Tổng hóa đơn
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: CustomColor.error,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: shippingAddress == null
                          ? null // Vô hiệu hóa nếu không có địa chỉ giao hàng
                          : () {
                        // Cập nhật địa chỉ giao hàng và tính tổng số tiền thanh toán
                        value.dataTransaction.shippingAddress = shippingAddress;
                        value.dataTransaction.totalPay =
                            value.dataTransaction.totalBill! + value.dataTransaction.serviceFee!;

                        // Chuyển đến màn hình chọn phương thức thanh toán
                        NavigateRoute.toPayment(context: context);
                      },
                      child: const Text('Tiếp'),
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
