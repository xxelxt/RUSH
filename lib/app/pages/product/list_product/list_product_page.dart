import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:rush/app/constants/order_by_value.dart';
import 'package:rush/app/providers/product_provider.dart';
import 'package:rush/app/widgets/app_bar_search.dart';
import 'package:rush/app/widgets/count_and_option.dart';
import 'package:rush/app/widgets/sort_filter_chip.dart';
import 'package:rush/config/flavor_config.dart';
import 'package:rush/routes.dart';

import 'widgets/product_container.dart';

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

  // Dữ liệu ảnh slider
  final List<String> sliderImages = [
   ' https://png.pngtree.com/template/20210728/ourlarge/pngtree-coffee-discount-promotion-advertisement-banner-illustration-image_552264.jpg',
    'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-ll37a6c8ra2ec6',
    'https://lzd-img-global.slatic.net/g/p/9472d83f67bc32e3e0ebcd1f1a79ff91.jpg_720x720q80.jpg',
    'https://touraneroastery.com/cdn/shop/files/IMG_3277_74952a27-3d0a-49b7-a588-734ea74a5193.jpg?v=1733900270&width=990',
  ];

  @override
  void dispose() {
    _txtSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Nút thêm sản phẩm cho admin flavor
      floatingActionButton: flavor.flavor == Flavor.admin
          ? FloatingActionButton(
        onPressed: () {
          NavigateRoute.toAddProduct(context: context);
        },
        child: const Icon(
          Icons.coffee_outlined,
          color: Colors.white,
        ),
      )
          : null,

      // Thanh tìm kiếm
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'RUSH',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white54, // Màu đỏ để làm nổi bật logo
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBarSearch(
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
        ),
      ),

      // Nội dung chính của trang
      body: Consumer<ProductProvider>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            child: Column(
              children: [
                // Slider quảng cáo
                CarouselSlider(
                  options: CarouselOptions(
                    height: 200,
                    autoPlay: true,
                    enlargeCenterPage: true,
                  ),
                  items: sliderImages.map((url) {
                    return Builder(
                      builder: (BuildContext context) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Image.network(
                            url,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // Bộ đếm sản phẩm và tùy chọn sắp xếp
                CountAndOption(
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
                              dataEnum: OrderByEnum.values.take(4).toList(),
                              onSelected: (value) {
                                setState(() {
                                  orderByEnum = value;
                                  orderByValue = getEnumValue(value);
                                  context.read<ProductProvider>().loadListProduct(
                                    search: _txtSearch.text,
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
                const SizedBox(height: 16),

                // Danh sách sản phẩm
                if (value.listProduct.isEmpty && _txtSearch.text.isEmpty)
                  const Center(
                    child: Text(
                      'Không có sản phẩm nào',
                      textAlign: TextAlign.center,
                    ),
                  ),

                if (value.listProduct.isEmpty && _txtSearch.text.isNotEmpty)
                  const Center(
                    child: Text('Không tìm thấy sản phẩm'),
                  ),

                if (value.listProduct.isNotEmpty)
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await value.loadListProduct(
                          search: search,
                          orderByEnum: orderByEnum,
                        );
                      },
                      child: GridView.builder(
                        itemCount: value.listProduct.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 8,
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height / 1.4),
                        ),
                        itemBuilder: (_, index) {
                          final item = value.listProduct[index];

                          return AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: 1.0,
                            child: ProductContainer(
                              item: item,
                              onTap: () {
                                NavigateRoute.toDetailProduct(
                                  context: context,
                                  productId: item.productId,
                                );
                              },
                            ),
                          );
                        },
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
