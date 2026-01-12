import 'package:flutter/material.dart';

class GlossyCircleBackButton extends StatelessWidget {
  final VoidCallback? onTap;

  const GlossyCircleBackButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: IconButton(
        style: IconButton.styleFrom(
          shadowColor: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white12, width: 1),
            borderRadius: BorderRadiusGeometry.circular(20),
          ),
          backgroundColor: Colors.white10,
        ),
        onPressed: () {},
        icon: Icon(Icons.arrow_back_rounded, size: 20),
      ),
    );
  }
}
