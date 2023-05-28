import 'package:shared_preferences/shared_preferences.dart';

abstract class TokenStatusService {
  Future<bool> getTokenStatus();
  Future<String> getToken();

  Future<String> setToken(String token);
}

class TokenStatusServiceImplementation implements TokenStatusService {

  @override
  Future<bool> getTokenStatus() async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt');

    //return token;
    print('getTokenService $token');
    if (token == null || token == '') {
      print('getTokenService -- False');

      return false;
    } else {
      print('getTokenService -- True');

      return true;
    }
  }

  @override
  Future<String> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt', token);
    return token;
  }

  @override
  Future<String> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('jwt') ?? ''; 
  return token;
}
}
