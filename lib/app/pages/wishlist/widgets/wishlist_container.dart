import 'package:cached_network_image/cached_network_image.dart';
import 'package:rush/app/providers/cart_provider.dart';
import 'package:rush/app/providers/wishlist_provider.dart';
import 'package:rush/core/domain/entities/wishlist/wishlist.dart';
import 'package:rush/utils/extension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/domain/entities/cart/cart.dart';
import '../../../../routes.dart';
import '../../../../themes/custom_color.dart';

class WishlistContainer extends StatelessWidget {
  final Wishlist wishlist;
  const WishlistContainer({super.key, required this.wishlist});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8.0),
      onTap: () {
        NavigateRoute.toDetailProduct(context: context, productId: wishlist.productId);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        width: double.infinity,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                imageUrl: wishlist.product!.productImage.first,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (_, child, loadingProgress) {
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.progress,
                    ),
                  );
                },
                errorWidget: (context, error, stackTrace) {
                  return const Icon(Icons.error);
                },
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Text(
                      wishlist.product!.productName,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    wishlist.product!.productPrice.toCurrency(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Consumer2<WishlistProvider, CartProvider>(
                    builder: (context, wishlistProvider, cartProvider, child) {
                      return Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              await wishlistProvider.delete(
                                accountId: FirebaseAuth.instance.currentUser!.uid,
                                wishlistId: wishlist.wishlistId,
                              );
                            },
                            icon: const Icon(Icons.delete_rounded),
                          ),
                          const SizedBox(width: 16.0),
                          ElevatedButton(
                            onPressed: wishlist.product!.stock > 0
                                ? () async {
                                    String accountId = FirebaseAuth.instance.currentUser!.uid;

                                    // Check if product exist in cart
                                    // If exist add the quantity
                                    if (cartProvider.countCart != 0) {
                                      for (var element in cartProvider.listCart) {
                                        if (element.productId == wishlist.product!.productId) {
                                          Cart data = element;
                                          data.quantity += 1;
                                          data.total = data.product!.productPrice * data.quantity;
                                          await cartProvider.updateCart(data: data);
                                          return;
                                        }
                                      }
                                    }

                                    // Add Cart
                                    Cart data = Cart(
                                      cartId: ''.generateUID(),
                                      product: wishlist.product,
                                      productId: wishlist.productId,
                                      quantity: 1,
                                      total: wishlist.product!.productPrice,
                                      createdAt: DateTime.now(),
                                      updatedAt: DateTime.now(),
                                    );
                                    await cartProvider.addCart(accountId: accountId, data: data);
                                  }
                                : null,
                            child: wishlist.product!.stock > 0 ? const Text('Thêm vào giỏ hàng') : const Text('Hết hàng'),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  if (wishlist.product!.rating != 0)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: CustomColor.warning,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${wishlist.product!.rating}' ' ' '(${wishlist.product!.totalReviews} Reviews)',
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
