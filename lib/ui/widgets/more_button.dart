import 'package:flutter/material.dart';
import 'package:onoy_kg/ui/helpers/helpers.dart';

Widget moreButton() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30.0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: Helpers.blueColor,
      ),
      height: 35.0,
      width: double.infinity,
      child: Center(
          child: Text(
        'Еще...',
        style: Helpers.header1WhiteTextStyle,
      )),
    ),
  );
}
