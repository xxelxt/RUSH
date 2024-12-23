import 'package:badges/badges.dart' as bg;
import 'package:rush/app/providers/account_provider.dart';
import 'package:rush/app/providers/checkout_provider.dart';
import 'package:rush/app/widgets/cart/cart_container.dart';
import 'package:rush/routes.dart';
import 'package:rush/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/domain/entities/cart/cart.dart';
import '../../../themes/custom_color.dart';
import '../../providers/cart_provider.dart';

// Hiển thị biểu tượng giỏ hàng cùng số lượng sản phẩm
class CartBadge extends StatelessWidget {
  const CartBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, value, child) {
        // Nếu giỏ hàng đang tải dữ liệu lần đầu
        if (value.firstLoad) {
          return Transform.scale(
            scale: 0.4,
            child: const CircularProgressIndicator(),
          );
        }

        // Hiển thị huy hiệu (badge) cho giỏ hàng
        return bg.Badge(
          badgeContent: Text(
            '${value.countCart}', // Hiển thị số lượng sản phẩm
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Colors.white,
            ),
          ),
          position: bg.BadgePosition.topEnd(),
          badgeStyle: const bg.BadgeStyle(
            badgeColor: CustomColor.error,
          ),
          showBadge: value.countCart != 0,

          child: InkWell(
            onTap: () {
              // Mở modal khi nhấn vào biểu tượng giỏ hàng
              showModalBottomSheet(
                context: context,
                isScrollControlled: true, // Cuộn nếu nội dung dài
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Tiêu đề modal
                            Text(
                              'Giỏ hàng',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),

                            if (value.listCart.isEmpty)
                              Text(
                                'Giỏ hàng trống',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),

                            if (value.listCart.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Danh sách sản phẩm trong giỏ hàng
                                  ...value.listCart.map(
                                        (e) => CartContainer(
                                      item: e, // Thông tin sản phẩm
                                      onTapAdd: () {
                                        if (e.quantity >= e.product!.stock) return; // Không thêm nếu vượt số lượng tồn

                                        Cart data = e;
                                        data.quantity += 1;

                                        setState(() {
                                          context.read<CartProvider>().updateCart(data: data); // Cập nhật giỏ hàng
                                        });
                                      },
                                      onTapRemove: () {
                                        Cart data = e;
                                        data.quantity -= 1;

                                        setState(() {
                                          context.read<CartProvider>().updateCart(data: data); // Cập nhật giỏ hàng
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 32),

                                  // Hiển thị tổng tiền
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Tổng',
                                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        value.total.toCurrency(),
                                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),

                                  // Nút Thanh toán
                                  ElevatedButton(
                                    onPressed: () {
                                      var account = context.read<AccountProvider>().account;
                                      var checkoutProvider = context.read<CheckoutProvider>();

                                      checkoutProvider.start(cart: value.listCart, account: account); // Bắt đầu thanh toán
                                      NavigateRoute.toCheckout(context: context); // Chuyển đến trang thanh toán
                                    },
                                    child: Text('Thanh toán (${value.countCart.toNumericFormat()})'),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
            child: const Icon(Icons.shopping_cart_rounded),
          ),
        );
      },
    );
  }
}
