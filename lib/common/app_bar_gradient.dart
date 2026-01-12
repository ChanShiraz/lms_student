import 'package:flutter/material.dart';

class AppBarGradient extends StatelessWidget {
  const AppBarGradient({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xff00a2f5), Color(0xff125ffb)],
        ),
      ),
    );
  }
}
