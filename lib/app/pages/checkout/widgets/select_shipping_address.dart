import 'package:rush/core/domain/entities/address/address.dart';
import 'package:flutter/material.dart';

import '../../../../themes/custom_color.dart';
import '../../../constants/colors_value.dart';

class SelectShippingAddress extends StatelessWidget {
  // Địa chỉ giao hàng hiện tại
  final Address? shippingAddress;

  // Hàm callback khi người dùng muốn chọn địa chỉ khác
  final Function() selectAddress;

  // Hàm callback khi người dùng muốn xóa địa chỉ giao hàng
  final Function() removeAddress;

  const SelectShippingAddress({
    super.key,
    this.shippingAddress,
    required this.selectAddress,
    required this.removeAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tiêu đề và nút chọn địa chỉ khác
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Địa chỉ giao hàng',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (shippingAddress != null) // Hiển thị nếu có địa chỉ giao hàng
              TextButton(
                onPressed: () {
                  selectAddress(); // Gọi hàm chọn địa chỉ khác
                },
                child: const Text('Lựa chọn địa chỉ khác'),
              ),
          ],
        ),

        // Nút thêm địa chỉ mới khi chưa có địa chỉ giao hàng
        if (shippingAddress == null)
          TextButton.icon(
            onPressed: () {
              selectAddress(); // Gọi hàm chọn địa chỉ
            },
            icon: Icon(
              Icons.add_rounded,
              color: ColorsValue.primaryColor(context),
            ),
            label: const Text('Thêm địa chỉ mới'),
          ),

        // Hiển thị thông tin địa chỉ giao hàng khi đã có địa chỉ
        if (shippingAddress != null)
          ListTile(
            dense: true,
            title: Text(shippingAddress!.name),
            contentPadding: EdgeInsets.zero,
            visualDensity: const VisualDensity(vertical: -4),
            subtitle: Text(
              '${shippingAddress!.address} ${shippingAddress!.city} ${shippingAddress!.zipCode}',
            ),
            trailing: IconButton(
              onPressed: () {
                removeAddress(); // Gọi hàm xóa địa chỉ
              },
              icon: const Icon(
                Icons.clear_rounded,
                color: CustomColor.error,
              ),
            ),
          ),

        const SizedBox(height: 16),
      ],
    );
  }
}
