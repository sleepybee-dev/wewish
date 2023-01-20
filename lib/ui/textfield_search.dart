import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  TextEditingController? controller;
  ValueChanged<String>? onChanged;
  ValueChanged<String>? onSubmitted;
  VoidCallback? onPressed;

  bool? enabled;
  bool autofocus = false;
  String? hintText;

  SearchTextField(
      {Key? key,
      required this.onPressed,
      this.controller,
      this.onChanged,
      this.hintText,
      this.enabled,
      this.autofocus = false,
      this.onSubmitted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor, width: 2),
            borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            children: [
              Expanded(
                  child: TextField(
                textInputAction: TextInputAction.search,
                onSubmitted: onSubmitted,
                autofocus: autofocus,
                enabled: enabled,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText,
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
                controller: controller,
                onChanged: onChanged ?? (value) {},
              )),
              IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    Icons.search,
                    color: Theme.of(context).primaryColor,
                    size: 32,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
