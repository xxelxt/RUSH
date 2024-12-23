import 'package:rush/app/constants/order_by_value.dart';
import 'package:rush/app/pages/transaction/list_transaction/widgets/transaction_container.dart';
import 'package:rush/app/providers/transaction_provider.dart';
import 'package:rush/app/widgets/app_bar_search.dart';
import 'package:rush/app/widgets/count_and_option.dart';
import 'package:rush/app/widgets/sort_filter_chip.dart';
import 'package:rush/config/flavor_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListTransactionPage extends StatefulWidget {
  const ListTransactionPage({super.key});

  @override
  State<ListTransactionPage> createState() => _ListTransactionPageState();
}

class _ListTransactionPageState extends State<ListTransactionPage> {
  FlavorConfig flavor = FlavorConfig.instance;

  final TextEditingController _txtSearch = TextEditingController();

  // Giá trị sắp xếp mặc định
  OrderByEnum orderByEnum = OrderByEnum.newest;
  OrderByValue orderByValue = getEnumValue(OrderByEnum.newest);

  String search = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Thanh tìm kiếm
      appBar: AppBarSearch(
        onChanged: (value) {
          search = value!;
          if (flavor.flavor == Flavor.admin) {
            // Tải tất cả giao dịch (admin)
            context.read<TransactionProvider>().loadAllTransaction(
              search: search,
              orderByEnum: orderByEnum,
            );
          } else {
            // Tải giao dịch của user đang đăng nhập
            context.read<TransactionProvider>().loadAccountTransaction(
              search: search,
              orderByEnum: orderByEnum,
            );
          }
        },
        controller: _txtSearch,
        hintText: 'Tìm kiếm đơn hàng',
      ),
      body: Consumer<TransactionProvider>(
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
                // Hiển thị số lượng giao dịch và tùy chọn sắp xếp
                CountAndOption(
                  count: value.listTransaction.length, // Số lượng giao dịch
                  itemName: 'đơn hàng',
                  isSort: true,
                  onTap: () {
                    // Modal để chọn kiểu sắp xếp
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return SortFilterChip(
                              dataEnum: OrderByEnum.values.take(4).toList(), // Các tùy chọn sắp xếp
                              onSelected: (value) {
                                setState(() {
                                  orderByEnum = value;
                                  orderByValue = getEnumValue(value);
                                  if (flavor.flavor == Flavor.admin) {
                                    context.read<TransactionProvider>().loadAllTransaction(
                                      search: search,
                                      orderByEnum: orderByEnum,
                                    );
                                  } else {
                                    context.read<TransactionProvider>().loadAccountTransaction(
                                      search: search,
                                      orderByEnum: orderByEnum,
                                    );
                                  }
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

                // Hiển thị danh sách giao dịch
                if (value.listTransaction.isEmpty && _txtSearch.text.isEmpty)
                  const Center(
                    child: Text(
                      'Không có đơn hàng nào',
                      textAlign: TextAlign.center,
                    ),
                  ),

                if (value.listTransaction.isEmpty && _txtSearch.text.isNotEmpty)
                  const Center(
                    child: Text('Không tìm thấy đơn hàng'),
                  ),

                if (value.listTransaction.isNotEmpty)
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        // Làm mới danh sách giao dịch
                        if (flavor.flavor == Flavor.admin) {
                          value.loadAllTransaction(
                            search: search,
                            orderByEnum: orderByEnum,
                          );
                        } else {
                          value.loadAccountTransaction(
                            search: search,
                            orderByEnum: orderByEnum,
                          );
                        }
                      },
                      child: ListView.builder(
                        itemCount: value.listTransaction.length, // Số lượng giao dịch
                        itemBuilder: (_, index) {
                          final item = value.listTransaction[index];

                          // Hiển thị từng giao dịch bằng TransactionContainer
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: TransactionContainer(item: item),
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
