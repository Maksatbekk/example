// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class LogoAppbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return title();
  }
}

Widget title() {
  return Row(
    children: const [
      Text(
        'ONOI',
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
          color: Color(0xff3B4256),
        ),
      ),
      SizedBox(
        width: 12.0,
      ),
      Text(
        'Кыргызстан',
        style: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
          color: Color(0xff007AFF),
        ),
      )
    ],
  );
}
