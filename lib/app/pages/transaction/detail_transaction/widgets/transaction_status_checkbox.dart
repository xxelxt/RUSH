import 'package:rush/app/constants/colors_value.dart';
import 'package:rush/core/domain/entities/transaction/transaction.dart';
import 'package:rush/utils/extension.dart';
import 'package:flutter/material.dart';

class TransactionStatusCheckbox extends StatefulWidget {
  // Trạng thái hiện tại được chọn
  final TransactionStatus selectedStatus;
  const TransactionStatusCheckbox({super.key, required this.selectedStatus});

  @override
  State<TransactionStatusCheckbox> createState() => _TransactionStatusCheckboxState();
}

class _TransactionStatusCheckboxState extends State<TransactionStatusCheckbox> {
  // Trạng thái được chọn (có thể thay đổi trong widget)
  TransactionStatus? selectedStatus;

  // Danh sách các trạng thái có thể chọn (lọc từ TransactionStatus)
  List<TransactionStatus> statuses = [];

  @override
  void initState() {
    // Gán trạng thái ban đầu từ widget
    selectedStatus = widget.selectedStatus;

    // Lọc danh sách các trạng thái để loại trừ trạng thái done và reviewed
    for (var status in TransactionStatus.values) {
      if (status != TransactionStatus.done && status != TransactionStatus.reviewed) {
        statuses.add(status);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          // Tiêu đề
          Text(
            'Trạng thái đơn hàng',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Danh sách các trạng thái với CheckboxListTile
          ...statuses.map((status) {
            return CheckboxListTile(
              title: Text(
                status.description,
              ),
              value: selectedStatus == status, // Xác định checkbox có được chọn hay không
              activeColor: ColorsValue.primaryColor(context),
              onChanged: (value) {
                // Khi checkbox được thay đổi
                setState(() {
                  if (value!) {
                    selectedStatus = status; // Cập nhật trạng thái được chọn
                  } else {
                    selectedStatus = null;
                  }
                });
              },
            );
          }),
          const SizedBox(height: 16),

          // Nút thay đổi trạng thái
          ElevatedButton(
            onPressed: selectedStatus == null
                ? null // Nếu không có trạng thái được chọn, vô hiệu hóa nút
                : () {
              Navigator.of(context).pop(selectedStatus); // Trả về trạng thái đã chọn
            },
            child: const Text('Thay đổi trạng thái'),
          ),
        ],
      ),
    );
  }
}
