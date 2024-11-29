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

class CartBadge extends StatelessWidget {
  const CartBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, value, child) {
        if (value.firstLoad) {
          return Transform.scale(
            scale: 0.4,
            child: const CircularProgressIndicator(),
          );
        }

        return bg.Badge(
          badgeContent: Text(
            '${value.countCart}',
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
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
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
                            Text(
                              'Shopping Cart',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            if (value.listCart.isEmpty)
                              Text(
                                'Cart is Empty',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            if (value.listCart.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ...value.listCart.map(
                                    (e) => CartContainer(
                                      item: e,
                                      onTapAdd: () {
                                        if (e.quantity >= e.product!.stock) return;

                                        Cart data = e;
                                        data.quantity += 1;

                                        setState(() {
                                          context.read<CartProvider>().updateCart(data: data);
                                        });
                                      },
                                      onTapRemove: () {
                                        Cart data = e;
                                        data.quantity -= 1;

                                        setState(() {
                                          context.read<CartProvider>().updateCart(data: data);
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total',
                                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        value.total.toCurrency(),
                                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      var account = context.read<AccountProvider>().account;

                                      var checkoutProvider = context.read<CheckoutProvider>();

                                      checkoutProvider.start(cart: value.listCart, account: account);

                                      NavigateRoute.toCheckout(context: context);
                                    },
                                    child: Text('Checkout (${value.countCart.toNumericFormat()})'),
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
