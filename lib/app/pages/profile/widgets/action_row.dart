import 'package:flutter/material.dart';

class ActionRow extends StatelessWidget {
  final String label;
  final Function() onTap;
  const ActionRow({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
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
                  child: Text(label),
                ),
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
