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
  final TextEditingController _txtSearch = TextEditingController();

  // Giá trị sắp xếp
  OrderByEnum orderByEnum = OrderByEnum.newest; // Mặc định là mới nhất
  OrderByValue orderByValue = getEnumValue(OrderByEnum.newest);

  String search = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarSearch(
        onChanged: (value) {
          // Gọi hàm lấy danh sách tài khoản khi thay đổi dữ liệu tìm kiếm
          context.read<AccountProvider>().getListAccount(
            search: _txtSearch.text,
            orderByEnum: orderByEnum,
          );
        },
        controller: _txtSearch, // Quản lý dữ liệu nhập vào
        hintText: 'Tìm kiếm khách hàng',
      ),

      body: Consumer<AccountProvider>(
        builder: (context, value, child) {
          // Hiển thị vòng tròn loading khi danh sách đang tải
          if (value.isLoadListAccount) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                // Hiển thị số lượng khách hàng và nút lọc sắp xếp
                CountAndOption(
                  count: value.listAccount.length, // Số lượng khách hàng
                  itemName: 'khách hàng',
                  isSort: true, // Cho phép sắp xếp
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

                // Hiển thị danh sách khách hàng
                if (value.listAccount.isEmpty && _txtSearch.text.isEmpty)
                  const Center(
                    child: Text(
                      'Không có khách hàng nào',
                      textAlign: TextAlign.center,
                    ),
                  ),

                if (value.listAccount.isEmpty && _txtSearch.text.isNotEmpty)
                  const Center(
                    child: Text('Không tìm thấy khách hàng'),
                  ),

                if (value.listAccount.isNotEmpty)
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        // Làm mới danh sách khách hàng khi kéo xuống
                        await context.read<AccountProvider>().getListAccount(
                          search: _txtSearch.text,
                          orderByEnum: orderByEnum,
                        );
                      },
                      child: ListView.builder(
                        itemCount: value.listAccount.length, // Số lượng khách hàng
                        itemBuilder: (_, index) {
                          final customer = value.listAccount[index]; // Lấy từng khách hàng

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: CustomerContainer(customer: customer), // Hiển thị thông tin khách hàng
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
