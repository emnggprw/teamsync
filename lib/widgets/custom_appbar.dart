import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuTap;

  const CustomAppBar({required this.onMenuTap, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("TeamSync"),
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: onMenuTap,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
