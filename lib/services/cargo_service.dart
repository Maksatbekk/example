// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:http/http.dart';
import 'package:logger/logger.dart';

import 'package:onoy_kg/models/cargo.dart';
import 'package:onoy_kg/models/regions_model.dart';
import 'package:onoy_kg/models/results.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _authority = '159.65.122.49';
const _pathCargo = '/api/cargo/';
const _pathTransportation = '/api/cargo/transportation/';
const _pathRegions = '/api/cargo/regions/';
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
var logger = Logger();

abstract class CargoService {
  Future<Cargo> getCargo(Results query);

  Future<Response> createCargo(Results user);

  Future<Cargo> getTransportation(Results query);

  Future<Response> createTransport(Results user);

  Future<Regions> getRegions();
}

class CargoServiceImplementation implements CargoService {
  @override
  Future<Cargo> getCargo(Results query) async {
    var queryParameters = {
      'from_region': query.fromRegion,
      'from_city': query.toCity,
      'to_region': query.toRegion,
      'to_city': query.toCity,
      'price__range': '${query.priceFrom}, ${query.priceTo}',
      'weight__range': '${query.weightFrom}, ${query.weightTo}',
    };

    if ((query.priceFrom == null || query.priceTo == null ||
            query.priceFrom == '' || query.priceTo == '') &&
        (query.weightFrom == null || query.weightTo == null ||
            query.weightFrom == '' || query.weightTo == '')) {
      queryParameters = {
        'from_region': query.fromRegion,
        'from_city': query.toCity,
        'to_region': query.toRegion,
        'to_city': query.toCity,
      };
    } else if ((query.weightFrom == null || query.weightTo == null ||
            query.weightFrom == '' || query.weightTo == '') &&
        (query.priceFrom != null && query.priceTo != null ||
            query.priceFrom != '' && query.priceTo != '')) {
      queryParameters = {
        'from_region': query.fromRegion,
        'from_city': query.toCity,
        'to_region': query.toRegion,
        'to_city': query.toCity,
        'price__range': '${query.priceFrom}, ${query.priceTo}',
      };
    } else if ((query.priceFrom == null || query.priceTo == null ||
            query.priceFrom == '' || query.priceTo == '') &&
        (query.weightFrom != null || query.weightTo != null ||
            query.weightFrom != '' || query.weightTo != '')) {
      queryParameters = {
        'from_region': query.fromRegion,
        'from_city': query.toCity,
        'to_region': query.toRegion,
        'to_city': query.toCity,
        'weight__range': '${query.weightFrom}, ${query.weightTo}',
      };
    }

    final _uri = Uri.http(_authority, _pathCargo, queryParameters);
    final response = await get(_uri, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      final jsonString = utf8.decode(response.bodyBytes);
      final json = jsonDecode(jsonString);
      final cargo = Cargo.fromJson(json);

      return cargo;
    } else {
      print(response.statusCode);
    }
    throw UnimplementedError();
  }

  @override
  Future<Cargo> getTransportation(Results query) async {
    var queryParameters = {
      'from_region': query.fromRegion,
      'from_city': query.toCity,
      'to_region': query.toRegion,
      'to_city': query.toCity,
      'price__range': '${query.priceFrom}, ${query.priceTo}',
      'weight__range': '${query.weightFrom}, ${query.weightTo}',
    };

    if ((query.priceFrom == null || query.priceTo == null ||
            query.priceFrom == '' || query.priceTo == '') &&
        (query.weightFrom == null || query.weightTo == null ||
            query.weightFrom == '' || query.weightTo == '')) {
      queryParameters = {
        'from_region': query.fromRegion,
        'from_city': query.toCity,
        'to_region': query.toRegion,
        'to_city': query.toCity,
      };
    } else if ((query.weightFrom == null || query.weightTo == null ||
            query.weightFrom == '' || query.weightTo == '') &&
        (query.priceFrom != null && query.priceTo != null ||
            query.priceFrom != '' && query.priceTo != '')) {
      queryParameters = {
        'from_region': query.fromRegion,
        'from_city': query.toCity,
        'to_region': query.toRegion,
        'to_city': query.toCity,
        'price__range': '${query.priceFrom}, ${query.priceTo}',
      };
    } else if ((query.priceFrom == null || query.priceTo == null ||
            query.priceFrom == '' || query.priceTo == '') &&
        (query.weightFrom != null || query.weightTo != null ||
            query.weightFrom != '' || query.weightTo != '')) {
      queryParameters = {
        'from_region': query.fromRegion,
        'from_city': query.toCity,
        'to_region': query.toRegion,
        'to_city': query.toCity,
        'weight__range': '${query.weightFrom}, ${query.weightTo}',
      };
    }

    final _uri = Uri.http(_authority, _pathTransportation, queryParameters);
    final response = await get(_uri, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    logger.d(response.body);

    if (response.statusCode == 200) {
      final jsonString = utf8.decode(response.bodyBytes);
      final json = jsonDecode(jsonString);
      final cargo = Cargo.fromJson(json);

      return cargo;
    } else {
      print(response.statusCode);
    }
    throw UnimplementedError();
  }

  @override
  Future<Response> createCargo(Results cargo) async {
    final prefs = await _prefs;
    final token = prefs.getString('jwt');
    final _uri = Uri.http(_authority, _pathCargo);
    final body = json.encode(cargo);
    logger.d(body);
    final response = await post(_uri, headers: {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': token!,
    }, body: body);

    print(response.statusCode);
    print(response.body);
    logger.d(response.body);

    if (response.statusCode == 201) {
      return response;
    } else {
     throw Exception('Failed to create cargo');
    }
  }

  @override
  Future<Regions> getRegions() async {
    final _uri = Uri.http(_authority, _pathRegions);

    final response = await get(_uri, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      final jsonString = utf8.decode(response.bodyBytes);
      final json = jsonDecode(jsonString);
      final regions = Regions.fromJson(json);

      return regions;
    } else {
      print(response.statusCode);
    }
    throw UnimplementedError();
  }

  @override
  Future<Response> createTransport(Results transport) async {
    final prefs = await _prefs;
    final token = prefs.getString('jwt');
    final _uri = Uri.http(_authority, _pathTransportation);
    final body = json.encode(transport);
    logger.d(body);

    try {
      final response = await post(
        _uri,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: body,
      );

      print(response.statusCode);
      return response;
    } catch (e) {
      throw Exception('Failed to create cargo');
    }
  }
}
