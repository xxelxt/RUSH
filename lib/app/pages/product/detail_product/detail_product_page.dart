import 'package:rush/app/pages/product/detail_product/widgets/detail_action_button.dart';
import 'package:rush/app/pages/product/detail_product/widgets/detail_product_image_card.dart';
import 'package:rush/app/pages/product/detail_product/widgets/detail_rating_review.dart';
import 'package:rush/app/pages/product/detail_product/widgets/detail_text_space_between.dart';
import 'package:rush/app/pages/product/detail_product/widgets/user_action_button.dart';
import 'package:rush/app/providers/product_provider.dart';
import 'package:rush/app/providers/wishlist_provider.dart';
import 'package:rush/app/widgets/cart/cart_badge.dart';
import 'package:rush/app/widgets/product_review_card.dart';
import 'package:rush/config/flavor_config.dart';
import 'package:rush/core/domain/entities/cart/cart.dart';
import 'package:rush/core/domain/entities/wishlist/wishlist.dart';
import 'package:rush/routes.dart';
import 'package:rush/utils/extension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../providers/cart_provider.dart';

class DetailProductPage extends StatefulWidget {
  const DetailProductPage({super.key});

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  final FlavorConfig _flavorConfig = FlavorConfig.instance;

  String accountId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    // Lấy dữ liệu chi tiết sản phẩm và danh sách yêu thích khi khởi tạo
    Future.microtask(() {
      // Lấy productId từ tham số truyền vào
      String productId = ModalRoute.of(context)!.settings.arguments as String;

      // Gọi hàm trong `ProductProvider` để tải chi tiết sản phẩm
      context.read<ProductProvider>().loadDetailProduct(productId: productId);

      // Gọi hàm trong `WishlistProvider` để tải danh sách yêu thích (nếu chưa có)
      var wishlistProvider = context.read<WishlistProvider>();
      if (wishlistProvider.listWishlist.isEmpty) {
        wishlistProvider.loadWishlist(accountId: accountId);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết sản phẩm'),
        // Hiển thị biểu tượng giỏ hàng nếu là user
        actions: _flavorConfig.flavor == Flavor.user
            ? [
          const CartBadge(),
          const SizedBox(width: 32),
        ]
            : null,
      ),

      // Consumer2 để listen thay đổi từ `ProductProvider` và `WishlistProvider`
      body: Consumer2<ProductProvider, WishlistProvider>(
        builder: (context, value, value2, child) {
          if (value.isLoading ||
              value.detailProduct == null ||
              value2.isLoadData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            children: [
              // Phần chi tiết sản phẩm
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Danh sách ảnh sản phẩm
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ...value.detailProduct!.productImage.map((imgUrl) {
                              int index = value.detailProduct!.productImage
                                  .indexOf(imgUrl);
                              return DetailProductImageCard(
                                  imgUrl: imgUrl, index: index);
                            })
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Tên sản phẩm và giá
                      DetailTextSpaceBetween(
                        leftText: value.detailProduct!.productName,
                        rightText: NumberFormat.currency(
                            locale: 'vi_VN', symbol: 'đ')
                            .format(value.detailProduct!.productPrice),
                      ),
                      const SizedBox(height: 12),

                      // Số lượng còn trong kho
                      DetailTextSpaceBetween(
                        leftText: 'Số lượng hàng còn',
                        rightText: value.detailProduct!.stock.toNumericFormat(),
                      ),
                      const SizedBox(height: 12),

                      // Mô tả sản phẩm
                      Text(
                        'Mô tả sản phẩm',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        value.detailProduct!.productDescription,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),

                      // Đánh giá và nhận xét
                      DetailRatingReview(
                        rating: value.detailProduct!.rating,
                        totalReview: value.detailProduct!.totalReviews,
                        onTapSeeAll: () {
                          // Điều hướng đến trang tất cả nhận xét
                          NavigateRoute.toProductReview(
                              context: context,
                              productReview: value.listProductReview);
                        },
                      ),
                      const SizedBox(height: 12),

                      // Danh sách review (nếu có)
                      if (value.listProductReview.isEmpty)
                        Center(
                          child: Text(
                            'Chưa có đánh giá cho sản phẩm này',
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ),

                      if (value.listProductReview.isNotEmpty)
                        Column(
                          children: [
                            ...value.listProductReview.map((item) {
                              return ProductReviewCard(item: item);
                            })
                          ],
                        ),
                    ],
                  ),
                ),
              ),

              // Phần nút hành động
              _flavorConfig.flavor == Flavor.user
                  ? Consumer2<CartProvider, WishlistProvider>(
                builder:
                    (context, cartProvider, wishlistProvider, child) {
                  if (cartProvider.isLoading ||
                      wishlistProvider.isLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  // Kiểm tra sản phẩm có trong danh sách yêu thích hay không
                  bool isWishlisted = wishlistProvider.listWishlist.any(
                          (element) =>
                      element.productId ==
                          value.detailProduct!.productId);

                  return UserActionButton(
                    isWishlisted: isWishlisted,
                    // Xử lý thêm hoặc xóa sản phẩm khỏi danh sách yêu thích
                    onTapFavorite: () async {
                      if (isWishlisted) {
                        String wishlistId = wishlistProvider.listWishlist
                            .where((element) =>
                        element.productId ==
                            value.detailProduct!.productId)
                            .first
                            .wishlistId;
                        await wishlistProvider.delete(
                            accountId: accountId, wishlistId: wishlistId);
                        return;
                      }

                      var data = Wishlist(
                        wishlistId: ''.generateUID(),
                        productId: value.detailProduct!.productId,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                      );

                      await wishlistProvider.add(
                          accountId: accountId, data: data);
                    },

                    // Xử lý thêm sản phẩm vào giỏ hàng
                    onTapAddToCart: value.detailProduct!.stock == 0
                        ? null
                        : () async {
                      String accountId =
                          FirebaseAuth.instance.currentUser!.uid;

                      // Kiểm tra sản phẩm đã có trong giỏ hàng chưa
                      if (cartProvider.countCart != 0) {
                        for (var element in cartProvider.listCart) {
                          if (element.productId ==
                              value.detailProduct!.productId) {
                            Cart data = element;
                            data.quantity += 1;
                            data.total =
                                data.product!.productPrice *
                                    data.quantity;
                            await cartProvider.updateCart(
                                data: data);
                            return;
                          }
                        }
                      }

                      // Thêm sản phẩm mới vào giỏ hàng
                      Cart data = Cart(
                        cartId: ''.generateUID(),
                        product: value.detailProduct,
                        productId: value.detailProduct!.productId,
                        quantity: 1,
                        total: value.detailProduct!.productPrice,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                      );
                      await cartProvider.addCart(
                          accountId: accountId, data: data);
                    },
                  );
                },
              )

              // Nút hành động của admin
                  : DetailActionButton(
                onTapDeleteProduct: () async {
                  var response = await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Xoá sản phẩm này?'),
                        content: const Text(
                            'Thông tin về sản phẩm sẽ bị xoá vĩnh viễn'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Huỷ'),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.of(context).pop(true),
                            child: const Text('Xoá'),
                          ),
                        ],
                      );
                    },
                  );

                  if (response != null) {
                    await value
                        .delete(productId: value.detailProduct!.productId)
                        .whenComplete(() {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Xoá sản phẩm thành công'),
                        ),
                      );
                      value.loadListProduct();
                    });
                  }
                },

                // Chuyển đến trang chỉnh sửa sản phẩm
                onTapEditProduct: () {
                  NavigateRoute.toEditProduct(
                      context: context, product: value.detailProduct!);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
