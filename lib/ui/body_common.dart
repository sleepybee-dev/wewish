import 'package:flutter/material.dart';

class CommonBody extends StatelessWidget {
  Widget child;
  String? title;
  bool showBackButton;

  CommonBody(
      {Key? key,
        required this.child,
        this.title,
        this.showBackButton = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _buildTitle(context),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:16, top:8.0),
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            showBackButton ? IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_back_ios_new)): Container(),
            title != null ? Expanded(child: Text(title!, style: Theme.of(context).textTheme.headlineMedium,)) : Container(),
          ],
        ),
      ),
    );
  }
}
