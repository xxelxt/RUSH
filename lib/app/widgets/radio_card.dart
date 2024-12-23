import 'package:rush/app/constants/colors_value.dart';
import 'package:flutter/material.dart';

// Hiển thị card với lựa chọn radio, tiêu đề, mô tả và các hành động (xoá, chỉnh sửa)
class RadioCard<T> extends StatelessWidget {
  final T value; // Giá trị của thẻ hiện tại
  final T? selectedValue; // Giá trị đang được chọn
  final void Function(T?) onChanged; // Hàm callback khi giá trị được chọn
  final String title; // Tiêu đề hiển thị
  final String subtitle; // Mô tả hiển thị
  final Function() onDelete; // Hàm callback khi nhấn nút xoá
  final Function() onEdit; // Hàm callback khi nhấn nút chỉnh sửa

  const RadioCard({
    super.key,
    required this.value,
    required this.selectedValue,
    required this.onChanged,
    required this.onDelete,
    required this.onEdit,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    // Kiểm tra thẻ hiện tại có được chọn không
    bool isSelected = value == selectedValue;

    return InkWell(
      onTap: () {
        // Thay đổi trạng thái được chọn khi nhấn vào thẻ
        isSelected ? onChanged(null) : onChanged(value);
      },
      borderRadius: BorderRadius.circular(8),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            // Viền thay đổi khi thẻ được chọn
            color: isSelected ? ColorsValue.primaryColor(context) : Theme.of(context).colorScheme.outline,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),

        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Radio<T>(
                    value: value, // Giá trị của radio
                    groupValue: selectedValue, // Giá trị đang được chọn
                    onChanged: onChanged, // Callback khi thay đổi giá trị
                    toggleable: true, // Cho phép bỏ chọn radio
                    activeColor: ColorsValue.primaryColor(context),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // Thu nhỏ vùng nhấn
                    visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Nội dung
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: onDelete, // Callback khi nhấn nút xoá
                    child: const Text('Xoá'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: onEdit, // Callback khi nhấn nút chỉnh sửa
                    child: const Text('Chỉnh sửa'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
