import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/theme/t_colors.dart';

import '../Pages/main_window.dart';

class PosAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function()? backPressed;
  const PosAppBar({super.key, required this.title, this.backPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 40.0,
      backgroundColor: TColors.blue,
      title: Text(
        title,
        style: const TextStyle(fontSize: 17.0),
      ),
      leading: IconButton(
          iconSize: 18.0,
          onPressed: () async {
            if (backPressed != null) {
              backPressed!();
            }
            await Get.offAll(const MainWindow());
          },
          icon: const Icon(Icons.arrow_back)),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(45.0);
}
