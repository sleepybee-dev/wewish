import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {

  TextEditingController? controller;
  ValueChanged<String>? onChanged;
  VoidCallback? onPressed;

  bool? enabled;
  String? hintText;

  SearchTextField({Key? key, required this.onPressed, this.controller, this.onChanged, this.hintText, this.enabled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: TextField(
          enabled: enabled,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),
          controller: controller,
          onChanged: onChanged ?? (value){},
        )),
        IconButton(onPressed: onPressed, icon: const Icon(Icons.search))
      ],
    );
  }
}