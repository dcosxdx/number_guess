import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GuessAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onCheck;
  final TextEditingController controller;

  const GuessAppBar({
    super.key,
    required this.onCheck,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
      ),
      titleSpacing: 0,
      leading: Icon(Icons.menu, color: Colors.black),
      actions: [
        IconButton(
          splashRadius: 20,
          onPressed: onCheck,
          icon: Icon(Icons.run_circle_outlined, color: Colors.blue),
        ),
      ],
      backgroundColor: Colors.white,
      elevation: 0,
      title: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFFF3F6F9),
          constraints: BoxConstraints(maxHeight: 35),
          border: OutlineInputBorder(
            // borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          labelText: "Enter a number 0-100",
          // hintText: "Enter a number 0-100",
          hintStyle: TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
