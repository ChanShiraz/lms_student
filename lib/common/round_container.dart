import 'package:flutter/material.dart';

class RoundContainer extends StatelessWidget {
  const RoundContainer({
    super.key,
    required this.child,
    this.color,
    this.padding = 10,
    this.circular = 10,
    this.width,
  });
  final Widget child;
  final Color? color;
  final double padding;
  final double circular;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
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
