import 'package:rush/app/constants/order_by_value.dart';
import 'package:flutter/material.dart';

class SortFilterChip extends StatelessWidget {
  final List<OrderByEnum> dataEnum;
  final Function(OrderByEnum value) onSelected;
  final OrderByEnum selectedEnum;
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
          Text(
            'Sort',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            children: dataEnum.map((e) {
              return FilterChip(
                label: Text(e.toString()),
                selected: selectedEnum == e,
                onSelected: (value) {
                  onSelected(e);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
