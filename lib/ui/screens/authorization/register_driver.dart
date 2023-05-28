// ignore_for_file: unused_field, dead_code, unnecessary_null_comparison, lines_longer_than_80_chars

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onoy_kg/managers/users_manager.dart';
import 'package:onoy_kg/models/users/cargo_types/cargo_types_model.dart';
import 'package:onoy_kg/models/users/cargo_types/cargo_types_result.dart';
import 'package:onoy_kg/models/users/register_driver_model.dart';
import 'package:onoy_kg/ui/helpers/helpers.dart';
import 'package:onoy_kg/ui/helpers/request_command.dart';
import 'package:onoy_kg/ui/screens/main/main_screen.dart';
import 'package:onoy_kg/ui/widgets/footer.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../service_locator.dart';
import '../../widgets/logo_appbar.dart';

const blueColor = Color(0xff007AFF);
const blueLightColor = Color(0xffE5F2FF);

class RegisterDriverScreen extends StatefulWidget {
  static const String id = '/register_driver';

  @override
  _RegisterDriverState createState() => _RegisterDriverState();
}

class _RegisterDriverState extends State<RegisterDriverScreen> {
  final _formKey = GlobalKey<FormState>();
  late File sampleImage;
  late File _techPassport;
  late File _license;
  late File _passport;
  final picker = ImagePicker();
  final _driver = RegisterDriver();
  var loading = false;
  var cargoTypeColor = Helpers.hintColor;
  var _techPassportColor = Colors.black;
  var _licenseColor = Colors.black;
  var _passportColor = Colors.black;
  late CargoTypesResults cargoTypesResults;

  Future getTechPassport() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _techPassport = File(pickedFile.path);
        _driver.vehicle = _techPassport;
        print('Image selected: $_techPassport');
      } else {
        print('No image selected.');
      }
    });
  }

  Future getLicense() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _license = File(pickedFile.path);
        _driver.driverLicense = _license;

        print('Image selected: $_license');
      } else {
        print('No image selected.');
      }
    });
  }

  Future getPassport() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _passport = File(pickedFile.path);
        _driver.idPassport = _passport;

        print('Image selected: $_passport');
      } else {
        print('No image selected.');
      }
    });
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_driver.cargoType == null) {
      setState(() {
        cargoTypeColor = Colors.red;
      });
    }

    if (_driver.vehicle == null) {
      setState(() {
        _techPassportColor = Colors.red;
      });
    }
    if (_driver.driverLicense == null) {
      setState(() {
        _licenseColor = Colors.red;
      });
    }
    if (_driver.idPassport == null) {
      setState(() {
        _passportColor = Colors.red;
      });
    }

    if (isValid &&
        _driver.cargoType != null &&
        _driver.vehicle != null &&
        _driver.driverLicense != null &&
        _driver.idPassport != null) {
      _formKey.currentState!.save();
      setState(() => loading = true);

      print(_driver.cargoType);
      print(_driver.vehicleType);
      print(_driver.carryingCapacity);
      print(_driver.vehicle.path.toString());
      print(_driver.driverLicense.path.toString());
      print(_driver.idPassport.path.toString());

      sl<UsersManager>().inRegisterDriver.add(_driver);
    }
  }

  @override
  Widget build(BuildContext context) {
    sl<UsersManager>().inCargoTypes.add(RequestCommand.UPDATE);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: title(),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20.0),
                    Text('Данные водителя', style: Helpers.titleTextStyle),
                    const SizedBox(height: 8.0),
                    Text(
                      'Закончите, пожалуйста, регистрацию!',
                      style: Helpers.header2TextStyle,
                    ),
                    const SizedBox(height: 30.0),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Имя',
                        hintStyle: Helpers.hintStyle,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _driver.name = value!;
                      },
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Фамилия',
                        hintStyle: Helpers.hintStyle,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter surname';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _driver.surName = value!;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    Text('Местоположение', style: Helpers.header2TextStyle),
                    const SizedBox(height: 4.0),
                    /* Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(
                            color: Colors.grey,
                          )),
                      child: DropdownButton(
                        underline: Container(color: Colors.transparent),
                        isExpanded: true,
                        hint: Text('Область', style: Helpers.hintStyle),
                        // Not necessary for Option 1
                        value: _selectedLocation,
                        onChanged: (String newValue) {
                          setState(() {
                            _selectedLocation = newValue;
                          });
                        },
                        items: _locations.map((location) {
                          return DropdownMenuItem(
                            value: location,
                            child: Text(location, 
                                          style: Helpers.header1TextStyle,),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(
                            color: Colors.grey,
                          )),
                      child: DropdownButton(
                        underline: Container(color: Colors.transparent),
                        isExpanded: true,
                        hint: Text('Город, район', style: Helpers.hintStyle),
                        // Not necessary for Option 1
                        value: _selectedLocation,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedLocation = newValue;
                          });
                        },
                        items: _locations.map((location) {
                          return DropdownMenuItem(
                            value: location,
                            child: Text(location,
                            style: Helpers.header1TextStyle),
                          );
                        }).toList(),
                      ),
                    ), */
                    const SizedBox(height: 20.0),
                    Text('Транспорт', style: Helpers.header1TextStyle),
                    const SizedBox(height: 4.0),
                    StreamBuilder<CargoTypes>(
                      stream: sl<UsersManager>().cargoTypes$,
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<CargoTypes> snapshot,
                      ) {
                        if (snapshot.hasError) {
                          return Text(
                            'Error: ${snapshot.error}',
                          );
                        }
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return const Text('');
                          case ConnectionState.waiting:
                            return const Opacity(
                              opacity: 0.0,
                              child: CircularProgressIndicator(),
                            );
                          case ConnectionState.active:
                            return _dropDownFromRegions(context, snapshot.data!);
                          case ConnectionState.done:
                            return Text('${snapshot.data} (closed)');
                        }
                        return null; // unreachable
                      },
                    ),

                    Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(
                            color: Colors.grey,
                          )),
                      child: DropdownButton<String>(
                        underline: Container(color: Colors.transparent),
                        isExpanded: true,
                        hint: Text('Тип транспорта', style: Helpers.hintStyle),
                        // Not necessary for Option 1
                        value: _driver.vehicleType,
                        onChanged: (newValue) {
                          setState(() {
                            _driver.vehicleType = newValue!;
                          });
                        },
                        items: const [
                          DropdownMenuItem<String>(
                            value: 'option1',
                            child: Text('Option 1'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'option2',
                            child: Text('Option 2'),
                          ),
                          // Add more DropdownMenuItem<String> items as needed
                        ],
                         /* items: _driver.vehicleType.map((location) {
                          return DropdownMenuItem(
                            value: location,
                            child: Text(
                              location,
                              style: Helpers.header1TextStyle,
                            ),
                          );
                        }).toList(), */ 
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    ToggleSwitch(
                        minWidth: 100,
                        fontSize: 16.0,
                        // activeBgColor: const Color(0xffE5F2FF),
                        activeFgColor: Colors.black,
                        inactiveBgColor: Colors.white,
                        inactiveFgColor: const Color(0xff909090),
                        labels: const ['Грузовик', 'Полурицеп', 'Сцепка'],
                        onToggle: (index) {
                          final value = index! + 1;
                          _driver.vehicleType = value.toString();
                        }),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Грузоподъемность, т',
                        hintStyle: Helpers.hintStyle,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _driver.carryingCapacity = value!;
                      },
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Объем багажа, м³',
                        hintStyle: Helpers.hintStyle,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Введите объем багажа, м³';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _driver.carryingCapacity = value!;
                      },
                    ),
                    const SizedBox(height: 30.0),
                    Text('Документы', style: Helpers.header1TextStyle),
                    const SizedBox(height: 30.0),
                    Column(
                      children: [
                        Center(
                          child: _techPassport == null
                              ? Text(
                                  'Свидетельства о ТС “Тех.Паспорт”',
                                  style: TextStyle(color: _techPassportColor),
                                )
                              : Image.file(
                                  _techPassport,
                                ),
                        ),
                        ElevatedButton.icon(
                            label: const Text('Выберите фото'),
                            icon: const Icon(Icons.drive_folder_upload),
                            onPressed: getTechPassport)
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Column(
                      children: [
                        Center(
                          child: _license == null
                              ? Text('Водительское удостоверенние',
                                  style: TextStyle(color: _techPassportColor))
                              : Image.file(
                                  _license,
                                ),
                        ),
                        ElevatedButton.icon(
                            label: const Text('Выберите фото'),
                            icon: const Icon(Icons.drive_folder_upload),
                            onPressed: getLicense),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Column(
                      children: [
                        Center(
                          child: _passport == null
                              ? Text(
                                  'Паспорт ID',
                                  style: TextStyle(
                                    color: _techPassportColor,
                                  ),
                                )
                              : Image.file(
                                  _passport,
                                ),
                        ),
                        ElevatedButton.icon(
                            label: const Text('Выберите фото'),
                            icon: const Icon(Icons.drive_folder_upload),
                            onPressed: getPassport)
                      ],
                    ),
                    // Text('Документы', style: Helpers.header1TextStyle),
                    const SizedBox(height: 30.0),
                    Text('Контакты', style: Helpers.header1TextStyle),
                    const SizedBox(height: 20.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(
                            color: Colors.grey,
                          )),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Номер для регистрации',
                                hintStyle: Helpers.hintStyle,
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter number';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                //_driver.number =  value;
                              },
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          SvgPicture.asset(
                            'assets/images/telegram.svg',
                            fit: BoxFit.cover,
                            height: 30,
                            width: 30,
                          ),
                          const SizedBox(width: 10),
                          SvgPicture.asset(
                            'assets/images/whatsapp.svg',
                            fit: BoxFit.cover,
                            height: 30,
                            width: 30,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Добавить номер',
                        style: Helpers.smallBlueTextStyle,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Visibility(
                      visible: loading,
                      child: StreamBuilder<int>(
                        stream: sl<UsersManager>().registerDriver$,
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<int> snapshot,
                        ) {
                          if (snapshot.hasError) {
                            return Text(
                              'Error: ${snapshot.error}',
                            );
                          }
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return const Text('');
                            case ConnectionState.waiting:
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            case ConnectionState.active:
                              return _statusResult(context, snapshot.data!);
                            case ConnectionState.done:
                              return Text('${snapshot.data} (closed)');
                          }
                          return null; // unreachable
                        },
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 30,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: const EdgeInsets.all(10),
                            foregroundColor: Colors.white,
                            backgroundColor: blueColor,
                          ),
                          onPressed: _trySubmit,
                          child: const Text(
                            'Отправить',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100.0),
              footer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropDownFromRegions(BuildContext context, CargoTypes data) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            color: cargoTypeColor,
          )),
      child: DropdownButton<CargoTypesResults>(
        underline: Container(color: Colors.transparent),
        isExpanded: true,
        hint: Text(
          'Тип транспорта',
          style: Helpers.hintStyle,
        ),
        // Not necessary for Option 1
        value: cargoTypesResults,
        onChanged: (newValue) {
          print(newValue!.name);
          print(newValue.id);
          _driver.cargoType = newValue.id.toString();
          setState(() {
            print(newValue.name);
            cargoTypeColor = Helpers.greyColor;
            cargoTypesResults = newValue;
          });
        },
        items: data.results.map((CargoTypesResults items) {
          return DropdownMenuItem(
            value: items,
            child: Text(
              items.name,
              style: Helpers.header1TextStyle,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _statusResult(BuildContext context, int data) {
    Future.delayed(Duration.zero, () async {
      if (data == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
            'Вы успешно зарегистировались! '
            'Ожидайте потверждение администратора.',
          ),
          duration: const Duration(seconds: 5),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));

        await Navigator.pushNamedAndRemoveUntil(
            context, MainScreen.id, ModalRoute.withName(MainScreen.id));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Введен неверные данные'),
          duration: const Duration(seconds: 5),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
      }
    });

    return Container();
  }
}
