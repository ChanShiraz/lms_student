import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {
  final String label;
  const TagChip(
    this.label, {
    super.key,
    this.color = const Color(0xFFF1F5F9),
    this.textColor = const Color(0xFF475569),
    this.showBorder = false,
    this.borderColor,
  });
  final Color color;
  final Color textColor;
  final bool showBorder;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 4, bottom: 4),
      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        border: showBorder
            ? BoxBorder.all(color: borderColor ?? Colors.grey.shade50)
            : null,
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: TextStyle(fontSize: 12, color: textColor)),
    );
  }
}
