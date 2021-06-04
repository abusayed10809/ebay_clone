import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

Widget appBarTitle(String title, double globalFontSize){
  return AutoSizeText(
    title,
    style: TextStyle(
      fontSize: globalFontSize*15,
    ),
  );
}