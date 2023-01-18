import 'package:flutter/material.dart';

class CommonTextField extends StatefulWidget {
  TextEditingController? controller;
  String? validationText;
  String? hintText;
  TextInputType? keyboardType;
  VoidCallback? onEditingComplete;

  CommonTextField({Key? key,
    this.validationText,
    this.controller,
    this.hintText,
    this.keyboardType,
  this.onEditingComplete}) : super(key: key);

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

// vlidation logic 사용 가능한 TexFormField

class _CommonTextFieldState extends State<CommonTextField> {
  final _formKey = GlobalKey<FormState>();
  String _value = ''; // Form 입력 값 저장
  bool flag = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // Add TextFormField
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: SizedBox(
              height: 48,
              child: TextFormField(
                onEditingComplete: widget.onEditingComplete ?? (){},
                keyboardType: widget.keyboardType ?? TextInputType.text,
                controller: widget.controller,
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
                    return '${widget.validationText}을(를) 한 글자 이상 입력하세요';
                  }
                  return null;
                },
                onChanged: (text) {
                  setState(() {
                    flag = true;
                  });
                },
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  suffixIcon: (flag && widget.controller?.text != '')
                      ? IconButton(
                    onPressed: (){
                      setState(() {
                        flag = false;
                      });
                      widget.controller?.clear();
                      return;
                    },
                    icon: Icon(Icons.clear),)
                      : null,
                  border: inputBorder(Colors.lightBlue),
                  focusedBorder: inputBorder(Colors.lightBlueAccent),
                  enabledBorder: inputBorder(Colors.lightBlue),
                  errorBorder: inputBorder(Colors.redAccent),
                ),
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