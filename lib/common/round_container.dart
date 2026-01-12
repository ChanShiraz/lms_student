import 'package:flutter/material.dart';

class RoundContainer extends StatelessWidget {
  const RoundContainer({
    super.key,
    required this.child,
    this.color,
    this.padding = 10,
    this.circular = 20,
    this.width,
    this.height,
  });
  final Widget child;
  final Color? color;
  final double padding;
  final double circular;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(circular),
      ),
      child: child,
    );
  }
}

class TagChip extends StatelessWidget {
  const TagChip({super.key, required this.child, this.color});
  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}
