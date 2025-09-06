import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TextShimmer extends StatelessWidget {
  final int lines; // how many lines shimmer should show (2–4)
  final double spacing;

  const TextShimmer({super.key, this.lines = 3, this.spacing = 4});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(lines, (index) {
          // Vary width a little for realism
          double widthFactor = 1.0;
          if (index == lines - 1) widthFactor = 0.6; // last line shorter
          return Container(
            margin: EdgeInsets.only(bottom: spacing),
            width: MediaQuery.of(context).size.width * widthFactor,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }
}
