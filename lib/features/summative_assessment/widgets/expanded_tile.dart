import 'package:flutter/material.dart';

class ExpandableTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? trailing;

  const ExpandableTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: const Color(0xFFF8FAFC),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: trailing != null
          ? Chip(label: Text(trailing!))
          : const Icon(Icons.expand_more),
    );
  }
}
