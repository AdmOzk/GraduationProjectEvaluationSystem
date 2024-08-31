import 'package:flutter/material.dart';
import 'package:evaluation_project/components/text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final ValueChanged<String> onChange;
  final TextEditingController controller; // Controller tanımlandı

  const RoundedInputField({
    Key? key,
    required this.hintText,
    required this.icon,
    required this.onChange,
    required this.isPassword,
    required this.controller, // Controller burada alındı
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        controller: controller, // Controller kullanıldı
        onChanged: onChange,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          icon: Icon(icon, color: Colors.black),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            gapPadding: 1.0,
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          fillColor: Colors.grey.shade200,
        ),
      ),
    );
  }
}
