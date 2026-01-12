import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerTile extends StatelessWidget {
  const ShimmerTile({
    super.key,
    required this.width,
    required this.height,
    this.circular = 20,
  });

  final double width;
  final double height;
  final double circular;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(circular),
        ),
      ),
    );
  }
}
