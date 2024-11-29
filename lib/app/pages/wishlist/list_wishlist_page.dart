import 'package:rush/app/pages/wishlist/widgets/wishlist_container.dart';
import 'package:rush/app/providers/wishlist_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/order_by_value.dart';
import '../../widgets/app_bar_search.dart';
import '../../widgets/count_and_option.dart';
import '../../widgets/sort_filter_chip.dart';

class ListWishlistPage extends StatefulWidget {
  const ListWishlistPage({super.key});

  @override
  State<ListWishlistPage> createState() => _ListWishlistPageState();
}

class _ListWishlistPageState extends State<ListWishlistPage> {
  String accountId = FirebaseAuth.instance.currentUser!.uid;

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
      // App Bar Search
      appBar: AppBarSearch(
        onChanged: (value) {
          context.read<WishlistProvider>().loadWishlist(
                accountId: accountId,
                search: _txtSearch.text,
                orderByEnum: orderByEnum,
              );
        },
        controller: _txtSearch,
        hintText: 'Search Wishlist',
      ),
      body: Consumer<WishlistProvider>(
        builder: (context, value, child) {
          if (value.isLoadData) {
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
                  count: value.listWishlist.length,
                  itemName: 'Wishlists',
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
                                  context.read<WishlistProvider>().loadWishlist(
                                        accountId: accountId,
                                        search: _txtSearch.text,
                                        orderByEnum: value,
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
                if (value.listWishlist.isEmpty && _txtSearch.text.isEmpty)
                  const Center(
                    child: Text(
                      'Wishlist is empty,\nwishlist will be shown here',
                      textAlign: TextAlign.center,
                    ),
                  ),

                if (value.listWishlist.isEmpty && _txtSearch.text.isNotEmpty)
                  const Center(
                    child: Text('Wishlist not found'),
                  ),

                if (value.listWishlist.isNotEmpty)
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await context.read<WishlistProvider>().loadWishlist(
                              accountId: accountId,
                              search: _txtSearch.text,
                              orderByEnum: orderByEnum,
                            );
                      },
                      child: ListView.builder(
                        itemCount: value.listWishlist.length,
                        itemBuilder: (_, index) {
                          final item = value.listWishlist[index];

                          return WishlistContainer(
                            wishlist: item,
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
