import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({
    super.key,
    required this.title,
    this.subtitle,
    this.height = 70,
    this.onBackPressed,
    this.showBackButton,
    this.gradient,
  });

  final String title;
  final String? subtitle;
  final double height;
  final VoidCallback? onBackPressed;
  final bool? showBackButton;
  final Gradient? gradient;

  @override
  Size get preferredSize => Size.fromHeight(height);

  bool get _canShowBack =>
      showBackButton ?? (Get.key.currentState?.canPop() ?? false);

  void _handleBack() {
    if (onBackPressed != null) {
      onBackPressed!();
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCentered = subtitle == null;
    return AppBar(
      elevation: 0,
      centerTitle: false,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient:
              gradient ??
              const LinearGradient(
                colors: [Color(0xFF0EA5E9), Color(0xFF2563EB)],
              ),
        ),
      ),
      leading: _canShowBack
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
              child: InkWell(
                hoverColor: Colors.transparent,
                onTap: _handleBack,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
            )
          : null,
      title: Column(
        crossAxisAlignment: isCentered
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (subtitle != null) ...[
            Text(subtitle!, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
          ],
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
