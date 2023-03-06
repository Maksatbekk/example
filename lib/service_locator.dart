import 'package:get_it/get_it.dart';
import 'package:onoy_kg/managers/cargo_manager.dart';
import 'package:onoy_kg/managers/login_manager.dart';
import 'package:onoy_kg/managers/main_manager.dart';
import 'package:onoy_kg/managers/token_manager.dart';
import 'package:onoy_kg/managers/users_manager.dart';
import 'package:onoy_kg/services/cargo_service.dart';
import 'package:onoy_kg/services/login_service.dart';
import 'package:onoy_kg/services/tokenStatus.dart';
import 'package:onoy_kg/services/users_service.dart';

import 'managers/auth_button.dart';

GetIt sl = GetIt.instance;

void setUpServiceLocator() {
  // register services
  sl.registerLazySingleton<LoginService>(() => LoginServiceImplementation());
  // ignore: lines_longer_than_80_chars
  sl.registerLazySingleton<TokenStatusService>(() => TokenStatusServiceImplementation());
  sl.registerLazySingleton<CargoService>(() => CargoServiceImplementation());
  sl.registerLazySingleton<UsersService>(() => UsersServiceImplementation());

  // register managers
  sl.registerLazySingleton<LoginManager>(() => LoginManager());
  sl.registerLazySingleton<MainManager>(() => MainManager());
  sl.registerLazySingleton<TokenManager>(() => TokenManager());
  sl.registerLazySingleton<AuthManager>(() => AuthManager());
  sl.registerLazySingleton<CargoManager>(() => CargoManager());
  sl.registerLazySingleton<UsersManager>(() => UsersManager());

}

