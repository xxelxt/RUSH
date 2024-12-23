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

  @override
  Widget build(BuildContext context) {
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

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            child: Column(
              children: [
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
                        // Làm mới danh sách sản phẩm
                        await value.loadListProduct(
                          search: search,
                          orderByEnum: orderByEnum,
                        );
                      },
                      child: GridView.builder(
                        itemCount: value.listProduct.length, // Số lượng sản phẩm
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 8,
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height / 1.4),
                        ),
                        itemBuilder: (_, index) {
                          final item = value.listProduct[index]; // Sản phẩm hiện tại

                          return ProductContainer(
                            item: item, // Hiển thị sản phẩm
                            onTap: () {
                              NavigateRoute.toDetailProduct(context: context, productId: item.productId); // Điều hướng đến chi tiết sản phẩm
                            },
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
