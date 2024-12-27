import 'package:rush/app/constants/order_by_value.dart';
import 'package:rush/app/providers/product_provider.dart';
import 'package:rush/app/widgets/app_bar_search.dart';
import 'package:rush/app/widgets/count_and_option.dart';
import 'package:rush/app/widgets/sort_filter_chip.dart';
import 'package:rush/config/flavor_config.dart';
import 'package:rush/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/product_container.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ListProductPage extends StatefulWidget {
  const ListProductPage({super.key});

  @override
  State<ListProductPage> createState() => _ListProductPageState();
}

class _ListProductPageState extends State<ListProductPage> {
  FlavorConfig flavor = FlavorConfig.instance;

  final TextEditingController _txtSearch = TextEditingController();

  // Giá trị sắp xếp mặc định
  OrderByEnum orderByEnum = OrderByEnum.newest;
  OrderByValue orderByValue = getEnumValue(OrderByEnum.newest);

  String search = '';

  final List<String> sliderImages = [
    'assets/images/static_banners/banner_1.jpg',
    'assets/images/static_banners/banner_2.jpg',
    'assets/images/static_banners/banner_3.jpg',
  ];

  @override
  void dispose() {
    _txtSearch.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    // Kiểm tra chế độ Dark Mode
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Nút thêm sản phẩm cho admin flavor
      floatingActionButton: flavor.flavor == Flavor.admin
          ? FloatingActionButton(
        onPressed: () {
          NavigateRoute.toAddProduct(context: context); // Điều hướng đến trang thêm sản phẩm
        },
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
        ),
      )
          : null,

      // Thanh tìm kiếm
      appBar: AppBarSearch(
        onChanged: (value) {
          search = value!;
          context.read<ProductProvider>().loadListProduct(
            search: search,
            orderByEnum: orderByEnum,
          );
        },
        controller: _txtSearch,
        hintText: 'Tìm kiếm sản phẩm',
      ),

      // Nội dung chính của trang
      body: Consumer<ProductProvider>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Thêm RefreshIndicator bọc CustomScrollView
          return RefreshIndicator(
            onRefresh: () async {
              // Làm mới danh sách sản phẩm
              await value.loadListProduct(
                search: search,
                orderByEnum: orderByEnum,
              );
            },
            child: CustomScrollView(
              slivers: [
                // Phần carousel
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 130,
                        autoPlay: true,
                        enlargeCenterPage: true,
                      ),
                      items: sliderImages.map((url) {
                        return Builder(
                          builder: (BuildContext context) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                url,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),

                // Phần CountAndOption (cố định khi cuộn)
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverPersistentHeaderDelegate(
                    child: Container(
                      color: isDarkMode ? Color(0xFF1A130D) : Color(0xFFFFF8F5), // Nền thay đổi theo chế độ sáng/tối
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: CountAndOption(
                        count: value.listProduct.length,
                        itemName: 'sản phẩm',
                        isSort: true,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return SortFilterChip(
                                    dataEnum: OrderByEnum.values.take(4).toList(), // Các kiểu sắp xếp
                                    onSelected: (value) {
                                      setState(() {
                                        orderByEnum = value; // Cập nhật kiểu sắp xếp
                                        orderByValue = getEnumValue(value);
                                        context.read<ProductProvider>().loadListProduct(
                                          search: _txtSearch.text, // Áp dụng tìm kiếm hiện tại
                                          orderByEnum: orderByEnum,
                                        );
                                      });
                                    },
                                    selectedEnum: orderByEnum,
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // Phần danh sách sản phẩm
                value.listProduct.isNotEmpty
                    ? SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 8,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 1.4),
                    ),
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final item = value.listProduct[index];
                        return ProductContainer(
                          item: item,
                          onTap: () {
                            NavigateRoute.toDetailProduct(
                              context: context,
                              productId: item.productId,
                            );
                          },
                        );
                      },
                      childCount: value.listProduct.length,
                    ),
                  ),
                )
                    : SliverFillRemaining(
                  child: Center(
                    child: Text(
                      value.listProduct.isEmpty && _txtSearch.text.isEmpty
                          ? 'Không có sản phẩm nào'
                          : 'Không tìm thấy sản phẩm',
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverPersistentHeaderDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 60.0; // Chiều cao tối đa
  @override
  double get minExtent => 60.0; // Chiều cao tối thiểu
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

