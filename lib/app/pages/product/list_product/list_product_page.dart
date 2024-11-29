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
  // Flavor
  FlavorConfig flavor = FlavorConfig.instance;

  // Text Editing Controller
  final TextEditingController _txtSearch = TextEditingController();

  // Sort
  OrderByEnum orderByEnum = OrderByEnum.newest;
  OrderByValue orderByValue = getEnumValue(OrderByEnum.newest);

  // Search
  String search = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: flavor.flavor == Flavor.admin
          ? FloatingActionButton(
              onPressed: () {
                NavigateRoute.toAddProduct(context: context);
              },
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
              ),
            )
          : null,
      // App Bar Search
      appBar: AppBarSearch(
        onChanged: (value) {
          search = value!;
          context.read<ProductProvider>().loadListProduct(
                search: search,
                orderByEnum: orderByEnum,
              );
        },
        controller: _txtSearch,
        hintText: 'Search Product',
      ),
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
                // Product Count & Filter
                CountAndOption(
                  count: value.listProduct.length,
                  itemName: 'Products',
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

                // Product List
                if (value.listProduct.isEmpty && _txtSearch.text.isEmpty)
                  const Center(
                    child: Text(
                      'Products is empty,\navailable product will be shown here',
                      textAlign: TextAlign.center,
                    ),
                  ),

                if (value.listProduct.isEmpty && _txtSearch.text.isNotEmpty)
                  const Center(
                    child: Text('Products not found'),
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
                          childAspectRatio:
                              MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 1.4),
                        ),
                        itemBuilder: (_, index) {
                          final item = value.listProduct[index];

                          return ProductContainer(
                            item: item,
                            onTap: () {
                              NavigateRoute.toDetailProduct(context: context, productId: item.productId);
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
