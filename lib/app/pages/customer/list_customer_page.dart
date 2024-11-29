import 'package:rush/app/pages/customer/widgets/customer_container.dart';
import 'package:rush/app/providers/account_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/order_by_value.dart';
import '../../widgets/app_bar_search.dart';
import '../../widgets/count_and_option.dart';
import '../../widgets/sort_filter_chip.dart';

class ListCustomerPage extends StatefulWidget {
  const ListCustomerPage({super.key});

  @override
  State<ListCustomerPage> createState() => _ListCustomerPageState();
}

class _ListCustomerPageState extends State<ListCustomerPage> {
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
          context.read<AccountProvider>().getListAccount(
                search: _txtSearch.text,
                orderByEnum: orderByEnum,
              );
        },
        controller: _txtSearch,
        hintText: 'Search Customer',
      ),
      body: Consumer<AccountProvider>(
        builder: (context, value, child) {
          if (value.isLoadListAccount) {
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
                  count: value.listAccount.length,
                  itemName: 'Customer',
                  isSort: true,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return SortFilterChip(
                              dataEnum: OrderByEnum.values.take(2).toList(),
                              onSelected: (value) {
                                setState(() {
                                  orderByEnum = value;
                                  orderByValue = getEnumValue(value);
                                  context.read<AccountProvider>().getListAccount(
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
                if (value.listAccount.isEmpty && _txtSearch.text.isEmpty)
                  const Center(
                    child: Text(
                      'Customer is empty,\ncustomer will be shown here',
                      textAlign: TextAlign.center,
                    ),
                  ),

                if (value.listAccount.isEmpty && _txtSearch.text.isNotEmpty)
                  const Center(
                    child: Text('Customer not found'),
                  ),

                if (value.listAccount.isNotEmpty)
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await context.read<AccountProvider>().getListAccount(
                              search: _txtSearch.text,
                              orderByEnum: orderByEnum,
                            );
                      },
                      child: ListView.builder(
                        itemCount: value.listAccount.length,
                        itemBuilder: (_, index) {
                          final customer = value.listAccount[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: CustomerContainer(customer: customer),
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
