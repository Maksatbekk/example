// ignore_for_file: omit_local_variable_types, dead_code, unnecessary_null_comparison, lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:onoy_kg/managers/cargo_manager.dart';
import 'package:onoy_kg/models/cities_model.dart';
import 'package:onoy_kg/models/region_results.dart';
import 'package:onoy_kg/models/regions_model.dart';
import 'package:onoy_kg/models/results.dart';
import 'package:onoy_kg/models/user.dart';
import 'package:onoy_kg/ui/helpers/helpers.dart';
import 'package:onoy_kg/ui/widgets/footer.dart';

import '../../service_locator.dart';
import '../widgets/logo_appbar.dart';
import 'main/main_screen.dart';

class AddTransport extends StatefulWidget {
  static const String id = '/add_transport';

  @override
  _AddTransportState createState() => _AddTransportState();
}

class _AddTransportState extends State<AddTransport> {
  final _formKey = GlobalKey<FormState>();
  final _cargo = Results();
  late RegionResults selectedFromRegion;
  late RegionResults selectedToRegion;
  late Cities selectedFromCity;
  late Cities selectedToCity;
  late UserModel user;
  List<Cities> citiesFrom = [];
  List<Cities> citiesTo = [];
  var regionColorFrom = Helpers.hintColor;
  var regionColorTo = Helpers.hintColor;
  var cityColorFrom = Helpers.hintColor;
  var cityColorTo = Helpers.hintColor;
  var fromDate;
  var toDate;
  var loading = false;

  var logger = Logger();

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_cargo.fromRegion == null) {
      setState(() {
        regionColorFrom = Colors.red;
      });
    }
    if (_cargo.fromCity == null) {
      setState(() {
        cityColorFrom = Colors.red;
      });
    }
    if (_cargo.toRegion == null) {
      setState(() {
        regionColorTo = Colors.red;
      });
    }
    if (_cargo.toCity == null) {
      setState(() {
        cityColorTo = Colors.red;
      });
    }

    if(_cargo.fromShipmentDate == null){
      final today  = DateTime.now();
      final month = Helpers.getMonth(today.month);
      fromDate = 'с ${today.day}  $month ${today.year}';
      _cargo.fromShipmentDate = '${today.year}-${today.month}-${today.day}';
      print(today);
    }

    if(_cargo.toShipmentDate == null){
      final today  = DateTime.now();
      final month = Helpers.getMonth(today.month);
      toDate = 'с ${today.day}  $month ${today.year}';
      _cargo.toShipmentDate = '${today.year}-${today.month}-${today.day}';
      print(today);
    }

    if (isValid &&
        _cargo.fromRegion != null &&
        _cargo.toRegion != null &&
        _cargo.toCity != null &&
        _cargo.fromCity != null) {
      _formKey.currentState!.save();
      setState(() => loading = true);

      print(_cargo.fromRegion);
      print(_cargo.fromCity);
      print(_cargo.fromShipmentDate);
      print(_cargo.fromPlaceComment);

      print(_cargo.toRegion);
      print(_cargo.toCity);
      print(_cargo.toShipmentDate);
      print(_cargo.toPlaceComment);

      print(_cargo.name);
      print(_cargo.weight);
      //print(_cargo.volume);
      print(_cargo.length);
      print(_cargo.width);
      print(_cargo.height);

      print(_cargo.senderName);
      print(_cargo.senderSurname);
      print(_cargo.phoneNumber);

      print(_cargo.price);

      print(_cargo.user.name);
      print(_cargo.user.phoneNumber);
      print(_cargo.user.userType);

      //print(_cargo.user.userType);
      sl<CargoManager>().inRequestTransport.add(_cargo);
    }
  }

  Future<void> callDatePickerFrom() async {
    final order = await getDate();
    final month = Helpers.getMonth(order!.month);
    print(month);

    setState(() {
      fromDate = 'с ${order.day}  $month ${order.year}';
      _cargo.fromShipmentDate = '${order.year}-${order.month}-${order.day}';
    });
  }

  Future<void> callDatePickerTo() async {
    final order = await getDate();
    final month = Helpers.getMonth(order!.month);
    print(order);

    setState(() {
      toDate = 'с ${order.day}  $month ${order.year}';
      _cargo.toShipmentDate = '${order.year}-${order.month}-${order.day}';
    });
  }

  Future<DateTime?> getDate() {
    // Imagine that this function is
    // more complex and slow.
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Object? args = ModalRoute.of(context)?.settings.arguments;
    _cargo.user = args['userData'];
    print('UserData ${args['userData']}');

    return Scaffold(
      appBar: AppBar(
        title: title(),
        leadingWidth: 24.0,
        backgroundColor: Colors.white,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                      child: Text(
                        'Данные транспортного средства',
                        style: Helpers.titleTextStyle,
                      ),
                    ),
                    Text('Адреса ', style: Helpers.header1TextStyle),
                    const SizedBox(height: 20.0),
                    Text('Откуда ', style: Helpers.header2TextStyle),
                    const SizedBox(height: 4.0),
                    StreamBuilder<Regions>(
                      stream: sl<CargoManager>().regionsList$,
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<Regions> snapshot,
                      ) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
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
                    const SizedBox(height: 8.0),
                    Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(
                            color: cityColorFrom,
                          )),
                      child: DropdownButton<Cities>(
                        underline: Container(color: Colors.transparent),
                        isExpanded: true,
                        hint: Text(
                          'Город, район',
                          style: Helpers.hintStyle,
                        ),
                        // Not necessary for Option 1
                        value: selectedFromCity,
                        onChanged: (newValue) {
                          logger.d(newValue!.name);
                          logger.d(newValue.id);
                          _cargo.fromCity = newValue.id.toString();
                          setState(() {
                            cityColorFrom = Helpers.greyColor;
                            selectedFromCity = newValue;
                          });
                        },
                        items: citiesFrom.map((Cities city) {
                          return DropdownMenuItem<Cities>(
                            value: city,
                            child: Text(
                              city.name,
                              style: Helpers.header1TextStyle,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      width: double.maxFinite,
                      decoration: const BoxDecoration(
                        color: Helpers.blueLightColor,
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Helpers.blueLightColor,
                        ),
                        // elevation: 0,
                        onPressed: callDatePickerFrom,
                        // color: Helpers.blueLightColor,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          // padding: EdgeInsets.symmetric(horizontal: 30.0),
                          child: fromDate == null
                              ? Text(
                                  'Выберите дату',
                                  style: Helpers.header1BlueTextStyle,
                                  //textScaleFactor: 2.0,
                                )
                              : Text(
                                  '$fromDate',
                                  style: Helpers.header1BlueTextStyle,
                                  // textScaleFactor: 2.0,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      'Куда ',
                      style: Helpers.header2TextStyle,
                    ),
                    const SizedBox(height: 4.0),
                    StreamBuilder<Regions>(
                      stream: sl<CargoManager>().regionsList$,
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<Regions> snapshot,
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
                            return _dropDownToRegions(context, snapshot.data!);
                          case ConnectionState.done:
                            return Text('${snapshot.data} (closed)');
                        }
                        return null; // unreachable
                      },
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(
                            color: cityColorTo,
                          )),
                      child: DropdownButton<Cities>(
                        underline: Container(color: Colors.transparent),
                        isExpanded: true,
                        hint: Text(
                          'Город, район',
                          style: Helpers.hintStyle,
                        ),
                        // Not necessary for Option 1
                        value: selectedToCity,
                        onChanged: (newValue) {
                          logger.d(newValue!.name);
                          logger.d(newValue.id);
                          _cargo.toCity = newValue.id.toString();
                          setState(() {
                            cityColorTo = Helpers.greyColor;
                            selectedToCity = newValue;
                          });
                        },
                        items: citiesTo.map((Cities city) {
                          return DropdownMenuItem<Cities>(
                            value: city,
                            child: Text(
                              city.name,
                              style: Helpers.header1TextStyle,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      width: double.maxFinite,
                      decoration: const BoxDecoration(
                        color: Helpers.blueLightColor,
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Helpers.blueLightColor,
                        ),
                        // elevation: 0,
                        onPressed: callDatePickerTo,
                        // color: Helpers.blueLightColor,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          // padding: EdgeInsets.symmetric(horizontal: 30.0),
                          child: toDate == null
                              ? Text(
                                  'Выберите дату',
                                  style: Helpers.header1BlueTextStyle,
                                  //textScaleFactor: 2.0,
                                )
                              : Text(
                                  '$toDate',
                                  style: Helpers.header1BlueTextStyle,
                                  // textScaleFactor: 2.0,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                        height: 120,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Комментарий к транспортному средству ...',
                            hintStyle: Helpers.hintStyle,
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          maxLines: 5,
                          onSaved: (value) {
                            _cargo.toPlaceComment = value!;
                          },
                        )),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        'Транспорт ',
                        style: Helpers.header1TextStyle,
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Грузоподъемность, т',
                        hintStyle: Helpers.hintStyle,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Введите вес груза, т';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _cargo.weight = value;
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
                      onSaved: (value) {
                     //   _cargo.volume = value;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Оплата за доставку ',
                      style: Helpers.header1TextStyle,
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Сумма, сом',
                          hintStyle: Helpers.hintStyle,
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Введите цену, сом';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _cargo.price = value;
                        }),
                    const SizedBox(height: 20.0),
                    Visibility(
                      visible: loading,
                      child: Center(
                        child: StreamBuilder<Response>(
                          stream: sl<CargoManager>().statusResponse$,
                          builder: (
                            BuildContext context,
                            AsyncSnapshot<Response> snapshot,
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
                                return const CircularProgressIndicator();
                              case ConnectionState.active:
                                return _statusResult(context, snapshot.data!);
                              case ConnectionState.done:
                                return Text('${snapshot.data} (closed)');
                            }
                            return null; // unreachable
                          },
                        ),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 30,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(10),
                            foregroundColor: Colors.white,
                            backgroundColor: Helpers.blueColor,
                          ),
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(10.0),
                          // ),
                          // padding: const EdgeInsets.all(10),
                          // textColor: Colors.white,
                          // color: Helpers.blueColor,
                          onPressed: _trySubmit,
                          /* onPressed: () {
                            _formKey.currentState.save();
                            sl<CargoManager>().inRequestCargo.add(_cargo);
                          },*/
                          child: const Text(
                            'Разместить',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
              footer()
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusResult(BuildContext context, Response data) {
    print('Response status ${data.statusCode}');
    Future.delayed(Duration.zero, () async {
      if (data.statusCode == 201) {
        /*  await Navigator.pushNamed(context, MainScreen.id);
            (route) => false);
        Navigator.pop(context);
        */

        await Navigator.pushNamedAndRemoveUntil(
            context, MainScreen.id, ModalRoute.withName(MainScreen.id));
        /* await Navigator.pushNamedAndRemoveUntil()
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
      (route) => false);*/

      } else if(data.statusCode == 403){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(''
              'Ошибка публикации. '
              'Возможно ваш аккаунт еще не потвержден. '
              'Попробуйте позже!'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
      }else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Введен неверные данные'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
      }
    });
    return Container();
  }

  Widget _dropDownFromRegions(BuildContext context, Regions data) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            color: regionColorFrom,
          )),
      child: DropdownButton<RegionResults>(
        underline: Container(color: Colors.transparent),
        isExpanded: true,
        hint: Text('Область', style: Helpers.hintStyle),
        value: selectedFromRegion,
        onChanged: (newValue) {
          print(newValue!.name);
          print(newValue.id);
          _cargo.fromRegion = newValue.id.toString();
          setState(() {
            print(newValue.name);
            selectedFromRegion = newValue;
            regionColorFrom = Helpers.greyColor;
            selectedFromCity = null;
            if (newValue.cities != null) {
              citiesFrom = [];
              citiesFrom = newValue.cities;
            } else {
              citiesFrom = [Cities(name: 'Select')];
            }
            print(citiesFrom.length);
          });
        },
        items: data.results.map((RegionResults items) {
          return DropdownMenuItem(
            value: items,
            child: Text(items.name, style: Helpers.header1TextStyle),
          );
        }).toList(),
      ),
    );
  }

  Widget _dropDownToRegions(BuildContext context, Regions data) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            color: regionColorTo,
          )),
      child: DropdownButton<RegionResults>(
        underline: Container(color: Colors.transparent),
        isExpanded: true,
        hint: Text('Область', style: Helpers.hintStyle),
        value: selectedToRegion,
        onChanged: (newValue) {
          print(newValue!.name);
          print(newValue.id);
          _cargo.toRegion = newValue.id.toString();
          setState(() {
            print(newValue.name);
            selectedToRegion = newValue;
            regionColorTo = Helpers.greyColor;
            selectedToCity = null;
            if (newValue.cities != null) {
              citiesTo = [];
              citiesTo = newValue.cities;
            } else {
              citiesTo = [Cities(name: 'Select')];
            }
            print(citiesTo.length);
          });
        },
        items: data.results.map((RegionResults items) {
          return DropdownMenuItem(
            value: items,
            child: Text(items.name, style: Helpers.header1TextStyle),
          );
        }).toList(),
      ),
    );
  }
}
