import 'package:flutter/material.dart';

// Hiển thị số lượng mục và nút sắp xếp/lọc
class CountAndOption extends StatelessWidget {
  final int count;
  final String itemName;
  final bool isSort;
  final Function() onTap;

  const CountAndOption({
    super.key,
    required this.count,
    required this.itemName,
    required this.isSort,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Có',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextSpan(
                text: ' ' '$count $itemName',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        // Hiển thị nút Sắp xếp hoặc Lọc
        isSort
            ? OutlinedButton.icon(
                onPressed: () {
                  onTap(); // Gọi hàm callback khi nhấn nút
                },
                icon: const Icon(Icons.sort_rounded),
                label: const Text('Sắp xếp'),
              )
            : OutlinedButton.icon(
                onPressed: () {
                  onTap(); // Gọi hàm callback khi nhấn nút
                },
                icon: const Icon(Icons.filter_list_rounded),
                label: const Text('Lọc'), // Nhãn nút
              ),
      ],
    );
  }
}
