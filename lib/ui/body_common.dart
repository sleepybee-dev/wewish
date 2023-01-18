import 'package:flutter/material.dart';

class CommonBody extends StatelessWidget {
  Widget child;
  String? title;
  bool showBackButton;
  VoidCallback? onBackPressed;
  Widget? rightButton;

  CommonBody(
      {Key? key,
        required this.child,
        this.title,
        this.showBackButton = false,
        this.onBackPressed,
        this.rightButton
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;
    return Padding(
      padding: EdgeInsets.only(top: statusBarHeight),
      child: Column(
        children: [
          hasTitleBar() ? _buildTitle(context) : Container(),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            showBackButton ? IconButton(onPressed: onBackPressed, icon: const Icon(Icons.arrow_back_ios_new)): Container(),
            title != null ? Expanded(child: Text(title!, style: Theme.of(context).textTheme.headlineMedium,)) : Expanded(child: Container()),
            rightButton != null? rightButton! : Container()
          ],
        ),
      ),
    );
  }

  bool hasTitleBar() {
    return showBackButton || title != null || rightButton != null;
  }
}
