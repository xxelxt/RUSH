import 'package:flutter/material.dart';

class ActionRow extends StatelessWidget {
  final String label;

  // Hàm callback `onTap` để xử lý sự kiện khi người dùng nhấn vào dòng này
  final Function() onTap;

  // Constructor
  const ActionRow({
    super.key,
    required this.label, // Bắt buộc phải truyền nhãn
    required this.onTap, // Bắt buộc phải truyền hàm xử lý sự kiện
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap(); // Gọi hàm callback khi người dùng nhấn vào
      },
      child: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  // Nhãn hiển thị tên
                  child: Text(label),
                ),
                // Biểu tượng mũi tên
                const Icon(
                  Icons.navigate_next_rounded,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
