import 'package:flutter/material.dart';

Widget title() {
  return Row(
    children: const[
      Text(
        'DOLON',
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
          fontSize: 14.0,
          letterSpacing: 1,
          fontWeight: FontWeight.w600,
          color: Color(0xff007AFF),
        ),
      )
    ],
  );
}
