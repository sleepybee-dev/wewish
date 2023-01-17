import 'package:flutter/material.dart';

class CommonTextField extends StatefulWidget {
  String validationText;
  String? hintText;

  CommonTextField({Key? key, required this.validationText, this.hintText}) : super(key: key);

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

// vlidation logic 사용 가능한 TexFormField

class _CommonTextFieldState extends State<CommonTextField> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  String _value = ''; // Form 입력 값 저장

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // Add TextFormField
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              onFieldSubmitted: (String value) { // TextFormField 입력값 반환
                final formKeyState = _formKey.currentState!;
                if (formKeyState.validate()) {
                  formKeyState.save();
                }
              },
              onSaved: (value){
                setState(() {
                  _value = value as String;
                  print('value = $_value 저장');
                });
              },
              validator: (value){
                if (value == null || value.isEmpty){
                  return '${widget.validationText} 을(를) 입력하세요';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: widget.hintText,
                suffixIcon: IconButton(
                  onPressed: _controller.clear,
                  icon: Icon(Icons.clear),
                ),
                focusedBorder: inputBorder(Colors.lightBlueAccent),
                enabledBorder: inputBorder(Colors.lightBlue),
              ),
            ),
          )
        ],
      ),
    );
  }
}

OutlineInputBorder inputBorder(Color color){
  return OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide(
      color: color,
      width: 1.0,
    ),
  );
}