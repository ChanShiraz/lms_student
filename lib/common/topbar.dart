import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.type = 1,
    this.centerTitle = false,
    this.showBack = true,
  });
  final String title;
  final int type;
  final String? subtitle;
  final Widget? trailing;
  final bool centerTitle;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xffe2e8f0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              showBack
                  ? IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 18,
                        color: Colors.black,
                      ),
                    )
                  : SizedBox.shrink(),
              const SizedBox(width: 12),
              centerTitle == true
                  ? Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff0f172a),
                      ),
                    )
                  : type == 1
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subtitle ?? '',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xff94a3b8),
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff0f172a),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff0f172a),
                          ),
                        ),
                        SizedBox(height: 2),

                        Text(
                          subtitle ?? '',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xff94a3b8),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
            ],
          ),
          trailing ?? SizedBox(),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
