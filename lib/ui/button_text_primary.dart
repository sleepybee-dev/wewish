import 'package:flutter/material.dart';

class PrimaryTextButton extends StatelessWidget {
  String label;
  VoidCallback onPressed;
  double? width;
  double? height;

  PrimaryTextButton(
      {Key? key,
      required this.label,
      required this.onPressed,
      this.width,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: Container(
            color: Theme.of(context).primaryColor,
            alignment: Alignment.center,
            width: double.infinity,
            height: height ?? 56,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white),
            )));
  }
}
