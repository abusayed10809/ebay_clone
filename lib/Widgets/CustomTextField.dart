import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData data;
  final String hintText;
  bool isObsecure = true;
  final TextInputType textInputType;

  CustomTextField(
      {Key key, this.controller, this.data, this.hintText, this.isObsecure, this.textInputType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(width*0.05)),
      ),
      // padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(width*0.01),
      child: TextFormField(
        validator: (value){
          if(value.isEmpty){
            return "Fields must not be empty";
          }
          return null;
        },

        keyboardType: textInputType,

        controller: controller,
        obscureText: isObsecure,
        cursorColor: Colors.deepPurple,
        decoration: InputDecoration(
          fillColor: Colors.white10,
          filled: true,
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.deepPurple,
              width: 2.0,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 2.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 2.0,
            ),
          ),
          prefixIcon: Icon(
            data,
            color: Colors.deepPurple,
          ),
          focusColor: Colors.deepPurple,
          hintText: hintText,
        ),
      ),
    );
  }
}
