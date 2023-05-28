// ignore_for_file: lines_longer_than_80_chars, unused_local_variable

import 'dart:convert';

import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:onoy_kg/models/cargo.dart';
import 'package:onoy_kg/models/users/cargo_types/cargo_types_model.dart';
import 'package:onoy_kg/models/users/register_driver_model.dart';
import 'package:onoy_kg/models/users/vehicle_types_model.dart';
import 'package:onoy_kg/models/users/vehicle_types_results.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _authority = '159.65.122.49';
const _pathGetCargoTypes = '/api/users/cargo-types/';
const _pathRegisterDriver = '/api/users/drivers/register/';
const _pathPublishedAds = '/api/users/proflie/published-ads/';
const _pathGetVehicleTypes = '/api/users/vehicle-types/';
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

abstract class UsersService {
  Future<CargoTypes> getCargoTypes();

  Future<int> registerDriver(RegisterDriver registerDriver);

  Future<Cargo> getPublishedAdds();

  Future<List<VehicleTypesResult>> getVehicleTypes();
}

class UsersServiceImplementation implements UsersService {
  var logger = Logger();

  @override
  Future<CargoTypes> getCargoTypes() async {
    final _uri = Uri.http(_authority, _pathGetCargoTypes);
    final response = await http.get(_uri, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      final jsonString = utf8.decode(response.bodyBytes);

      final json = jsonDecode(jsonString);
      final cargo = CargoTypes.fromJson(json);

      return cargo;
    } else {
      print(response.statusCode);
    }
    throw UnimplementedError();
  }

  @override
  Future<int> registerDriver(RegisterDriver registerDriver) async {
    final driverLicenseFile = await FlutterNativeImage.compressImage(registerDriver.driverLicense.path,
        quality: 80, targetWidth: 600, targetHeight: 300);

    final vehiclePassportFile = await FlutterNativeImage
        .compressImage(registerDriver.vehicle.path,
        quality: 80, targetWidth: 600, targetHeight: 300);

    final idPassportFile = await FlutterNativeImage
        .compressImage(registerDriver.idPassport.path,
        quality: 80, targetWidth: 600, targetHeight: 300);

    final _uri = Uri.http(_authority, _pathRegisterDriver);
    // final body = json.encode(registerDriver);
    final prefs = await _prefs;
    final token = prefs.getString('jwt');
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token??'',
    }; // ignore this headers if there is no authentication

    //create multipart request for POST or PATCH method
    final request = http.MultipartRequest('POST', _uri);
    //add text fields
    request.fields['carrying_capacity'] = registerDriver.carryingCapacity;
    request.fields['vehicle_type'] = registerDriver.vehicleType;
    request.fields['cargo_type'] = registerDriver.cargoType;
    //create multipart using filepath, string or bytes
    final vehiclePassport = await http.MultipartFile.fromPath(
      'vehicle_passport',
      vehiclePassportFile.path,
    );
    //add multipart to request
    request.files.add(vehiclePassport);

    final driverLicense = await http.MultipartFile.fromPath(
      'driver_license',
      driverLicenseFile.path,
    );
    //add multipart to request
    request.files.add(driverLicense);

    final idPassport = await http.MultipartFile.fromPath(
      'id_passport',
      idPassportFile.path,
    );
    //add multipart to request
    request.files.add(idPassport);

    //add headers
    request.headers.addAll(headers);

    final response = await request.send();

    // final response = await post(_uri, headers: {'Content-Type': 'application/json'}, body: body);

    // listen for response
    /*   response.stream.transform(utf8.decoder).listen((value) {
        print(value);

      });*/
    logger.d(response);
    logger.d(response.statusCode);
    print(response.statusCode);
    final response1 = await http.Response.fromStream(response);
    return response.statusCode;
    /*  if (response.statusCode == 400) {
      final jsonData = json.decode(response.body);
      logger.d(jsonData);
    }
    if (response.statusCode == 201) {
      final jsonData = json.decode(response.body);
      print(jsonData);
      final registered = RegisterDriver.fromJson(jsonData);
      return response;
    } else {
      throw Exception('Failed to register user');
    }*/
  }

  @override
  Future<Cargo> getPublishedAdds() async {
    final prefs = await _prefs;
    final token = prefs.getString('jwt');
    logger.d('Token Pub Adds $token');

    final _uri = Uri.http(_authority, _pathPublishedAds);
    final response = await http.get(_uri, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token??'',
    });
     logger.d(response.body);

    if (response.statusCode == 200) {
      final jsonString = utf8.decode(response.bodyBytes);

      final json = jsonDecode(jsonString);
      final publishedAdds = Cargo.fromJson(json);

      return publishedAdds;
    } else if (response.statusCode == 500) {
      final jsonString = utf8.decode(response.bodyBytes);
      logger.d(jsonString);
      logger.d(response);
    } else {
      print(response.statusCode);
    }
    throw UnimplementedError();
  }

  @override
  Future<List<VehicleTypesResult>> getVehicleTypes() async {
    final _uri = Uri.http(_authority, _pathGetVehicleTypes);
    final response = await http.get(_uri, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      final jsonString = utf8.decode(response.bodyBytes);

      final json = jsonDecode(jsonString);
      final cargo = VehicleTypes.fromJson(json);

      return cargo.results;
    } else {
      print(response.statusCode);
    }
    throw UnimplementedError();
  }
}
