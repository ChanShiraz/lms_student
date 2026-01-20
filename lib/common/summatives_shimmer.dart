import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SummativesShimmer extends StatelessWidget {
  const SummativesShimmer({
    super.key,
    this.quantity = 4,
    this.height = 12,
    this.borderRadius = 15,
    this.padding = 3,
  });
  final int quantity;
  final double height;
  final double borderRadius;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LIST ROW SHIMMERS (10 rows)
          ...List.generate(quantity, (index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: padding),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  color: const Color(0xfff8fafc),
                  border: const Border(
                    bottom: BorderSide(color: Color(0xffe2e8f0)),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(flex: 2, child: ShimmerBox(width: 80, height: 12)),
                    Expanded(
                      flex: 2,
                      child: ShimmerBox(width: 100, height: 12),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ShimmerBox(width: 60, height: height),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class ShimmerBox extends StatelessWidget {
  final double? width;
  final double height;

  const ShimmerBox({super.key, this.width, this.height = 14});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
