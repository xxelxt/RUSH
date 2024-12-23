import 'package:flutter/material.dart';

// Widget hiển thị một dòng thông tin cá nhân
class PersonalInfoTile extends StatelessWidget {
  final String personalInfo;

  final String value;

  // Hàm callback khi nhấn vào tile
  final Function() onTap;

  // Constructor
  const PersonalInfoTile({
    super.key,
    required this.personalInfo, // Truyền tiêu đề thông tin
    required this.value, // Truyền giá trị
    required this.onTap, // Truyền hàm xử lý sự kiện
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTap();
      },
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: Text(personalInfo),
      title: Text(value),
      trailing: const Icon(
        Icons.navigate_next_rounded, // Biểu tượng mũi tên
      ),
    );
  }
}
