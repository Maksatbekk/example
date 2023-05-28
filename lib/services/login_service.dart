// ignore_for_file: missing_return

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:onoy_kg/models/create_model.dart';
import 'package:onoy_kg/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _authority = '159.65.122.49';
const _path = '/api/auth/jwt/create';
const _pathRegister = '/api/auth/users/';
const _pathGetUser = '/api/auth/users/me/';

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

abstract class LoginService {
  Future<Response> createUser(UserModel user);

  Future<Response> registerUser(UserModel user);

  Future<UserModel> getUser();

  Future<UserModel> setUser(UserModel userModel);
}

class LoginServiceImplementation implements LoginService {
  final logger = Logger();

  @override
  Future<Response> createUser(UserModel user) async {
    final prefs = await _prefs;
    logger.d(user.phoneNumber);
    logger.d(user);

    try {
      final _uri = Uri.http(_authority, _path);
      user.phoneNumber = user.phoneNumber;
      user.password = user.password;
      final body = json.encode(user);
      logger.d(user.password);
      logger.d(user.phoneNumber);

      final response = await post(_uri, headers: {'Content-Type': 'application/json'}, body: body);

      print(response.statusCode);


      final jsonData = json.decode(response.body);
      print(jsonData);

      final create = Create.fromJson(jsonData);
      logger.d('Login Page Response ${create.access}');
      final tokenValue = 'Bearer ${create.access}';
      await prefs.setString('jwt', tokenValue);

      final tokenResponse = prefs.getString('jwt');
      logger.d('Login Page Token Response $tokenResponse');

      return response;

    } on PlatformException catch (err) {
      var message = 'An error occured, please check your credentials!';
      print(message);
      if (err.message != null) {
        message = err.message!;
      }
      throw Exception(message);
    }
  }

  @override
  Future<Response> registerUser(UserModel user) async {
    final _uri = Uri.http(_authority, _pathRegister);
    final body = json.encode(user);
    logger.d(body);
    final response = await post(_uri, headers: {'Content-Type': 'application/json'}, body: body);

    print(response.statusCode);
    logger.d(response.body);
    if (response.statusCode == 400) {
      final jsonData = json.decode(response.body);
      logger.d(jsonData);
      return response;
    }
    if (response.statusCode == 201) {
      final jsonData = json.decode(response.body);
      print(jsonData);

      return response;
    }  if (response.statusCode == 500) {
      final jsonData = json.decode(response.body);
      logger.d(jsonData);
      return response;
    } else {
      throw Exception('Failed to register user');
    }
  }

  @override
  Future<UserModel> getUser() async {
    final prefs = await _prefs;
    final token = prefs.getString('jwt');
    //logger.d(token);

    final _uri = Uri.http(_authority, _pathGetUser);
    final response = await get(_uri, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token??'',
    });

   // logger.d(response.body);
   // logger.d(response.statusCode);
    if (response.statusCode == 200) {
      final jsonString = utf8.decode(response.bodyBytes);

      final jsonData = json.decode(jsonString);
      print(jsonData);
      final create = UserModel.fromJson(jsonData);
      return create;
    } else if (response.statusCode == 401) {
      final create = UserModel();
      await prefs.setString('jwt', '');
      return create;
    } else {
      throw Exception('Failed to register user');
    }
  }

  @override
  Future<UserModel> setUser(UserModel userModel) async {
    final prefs = await _prefs;
    final token = prefs.getString('jwt');
    final _uri = Uri.http(_authority, _pathGetUser);
    final body = json.encode(userModel);
    logger.d(body);
    final response = await put(_uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token??'',
        },
        body: body);

    print(response.statusCode);

    if (response.statusCode == 400) {
      final jsonData = json.decode(response.body);
      logger.d(jsonData);
    }
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print(jsonData);
      final create = UserModel.fromJson(jsonData);
      return create;
    } else {
      throw Exception('Failed to register user');
    }
  }
}
