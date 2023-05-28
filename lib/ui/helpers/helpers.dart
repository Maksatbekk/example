// ignore_for_file: dead_code

import 'package:flutter/material.dart';

class Helpers {
  static TextStyle hintStyle = const TextStyle(
    fontSize: 12.0,
    color: Color(0xff909090),
  );

  static TextStyle titleTextStyle = const TextStyle(
    fontSize: 24.0,
    //fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static TextStyle header1TextStyle = const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static TextStyle header1RedTextStyle = const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: Colors.red,
  );

  static TextStyle header1CardTextStyle = const TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );
  static TextStyle header2CardTextStyle = const TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    color: Color(0xff909090),
  );
  static TextStyle header1BlueTextStyle = const TextStyle(
    fontSize: 16.0,
    color: blueColor,
  );
  static TextStyle header2BlueTextStyle = const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: blueColor,
  );
  static TextStyle header1WhiteTextStyle = const TextStyle(
    fontSize: 16.0,
    //fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  static TextStyle header2WhiteTextStyle = const TextStyle(
    fontSize: 12.0,
    //fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle header2TextStyle = const TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );
  static TextStyle bottomSheetTextStyle = const TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: Color(0xff404040),
  );

  static TextStyle smallBlueTextStyle = const TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    color: blueColor,
  );

  static const Color blueColor = Color(0xff007AFF);
  static const Color blueLightColor = Color.fromARGB(255, 216, 239, 252);
  static const Color greenColor = Color(0xff0FA958);
  static const Color greyColor = Color(0xffE0E0E0);
  static const Color hintColor = Color(0xff909090);

  static const pattern = r'(^((\+996)+([0-9]){9})$)';
  static const pattern2 = r'(^((\+20)+([0-9]){10})$)';

  static String validateMobile(String value) {
    final regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'Неправильно введенный формат номера телефона';
    } else if (!regExp.hasMatch(value)) {
      return 'Неправильно введенный формат номера телефона';
    }
    return value;
  }

  static String validatePassword(String value) {
    const pattern = r'(^[a-zA-Z0-9$@$!%*?&#^-_. +]+$)';

    final regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'Пароль должен быть от 8 символов длиной,'
          ' содержать \n одну латинскую букву и число';
    } else if (!regExp.hasMatch(value) || value.length < 8) {
      return 'Пароль должен быть от 8 символов длиной, '
          'содержать \n одну латинскую букву и число';
    }
    return value;
  }

  static String getMonth(int month) {
    switch (month) {
      case 1:
        {
          return 'Январь';
        }
        break;
      case 2:
        {
          return 'Февраль';
        }
        break;
      case 3:
        {
          return 'Март';
        }
        break;
      case 4:
        {
          return 'Апрель';
        }
        break;
      case 5:
        {
          return 'Май';
        }
        break;
      case 6:
        {
          return 'Июнь';
        }
        break;
      case 7:
        {
          return 'Июль';
        }
        break;
      case 8:
        {
          return 'Август';
        }
        break;
      case 9:
        {
          return 'Сентябрь';
        }
        break;
      case 10:
        {
          return 'Октябрь';
        }
        break;
      case 11:
        {
          return 'Ноябрь';
        }
        break;
      case 12:
        {
          return 'Декабрь';
        }
        break;
      default:
        {
          return '';
        }
        break;
    }
  }
}
