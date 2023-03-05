import 'package:flutter_test/flutter_test.dart';
import 'package:onoy_kg/services/users_service.dart';

void main(){
  final usersService = UsersServiceImplementation();

  test('post json to get model', () async {

    final usersService = UsersServiceImplementation();


    final model = await usersService.getCargoTypes();
    expect(model.results[0].id, equals(1));
    expect(model.results[0].name, equals('Крупные'));
   // expect(model.fields.isNotEmpty, equals(true));

  });

  /*test('get json to get model', () async {
    var model = await usersService.getPublishedAdds();
    expect(model[0].id, equals(6));

  });*/

  test('get json to get model', () async {
    final model = await usersService.getVehicleTypes();
    expect(model[0].id, equals(1));

  });
}