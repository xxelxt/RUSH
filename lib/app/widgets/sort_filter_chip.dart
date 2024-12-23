import 'package:rush/app/constants/order_by_value.dart'; // Import enum sắp xếp
import 'package:flutter/material.dart';

// Hiển thị các tùy chọn sắp xếp và cho phép người dùng chọn
class SortFilterChip extends StatelessWidget {
  final List<OrderByEnum> dataEnum; // Danh sách các giá trị sắp xếp (enum)
  final Function(OrderByEnum value) onSelected; // Hàm callback khi chọn một giá trị
  final OrderByEnum selectedEnum; // Giá trị sắp xếp đang được chọn

  const SortFilterChip({
    super.key,
    required this.dataEnum,
    required this.onSelected,
    required this.selectedEnum,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề filter
          Text(
            'Sắp xếp',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          Wrap(
            spacing: 16,
            children: dataEnum.map((e) {
              // Tạo danh sách FilterChip từ `dataEnum`
              return FilterChip(
                label: Text(e.toString()), // Hiển thị tên của enum
                selected: selectedEnum == e, // Kiểm tra xem giá trị này có được chọn không
                onSelected: (value) {
                  onSelected(e); // Gọi hàm callback với giá trị được chọn
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
