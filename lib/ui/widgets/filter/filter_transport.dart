// ignore_for_file: unused_import, unused_local_variable, dead_code, unnecessary_null_comparison, lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:onoy_kg/managers/cargo_manager.dart';
import 'package:onoy_kg/managers/main_manager.dart';
import 'package:onoy_kg/models/cities_model.dart';
import 'package:onoy_kg/models/region_results.dart';
import 'package:onoy_kg/models/regions_model.dart';
import 'package:onoy_kg/models/results.dart';
import 'package:onoy_kg/services/cargo_service.dart';
import 'package:onoy_kg/ui/helpers/helpers.dart';
import '../../../service_locator.dart';

class FilterTransport extends StatefulWidget {
  @override
  _FilterTransportState createState() => _FilterTransportState();
}

class _FilterTransportState extends State<FilterTransport> {
  final _formKey = GlobalKey<FormState>();
  final _cargoResult = Results();
  var regionColorFrom = Helpers.hintColor;
  var regionColorTo = Helpers.hintColor;
  var cityColorFrom = Helpers.hintColor;
  var cityColorTo = Helpers.hintColor;
  var weightColorFrom = Helpers.hintColor;
  var weightColorTo = Helpers.hintColor;
  var priceColorFrom = Helpers.hintColor;
  var priceColorTo = Helpers.hintColor;
  final weightFromText = TextEditingController();
  final weightToText = TextEditingController();
  final priceFromText = TextEditingController();
  final priceToText = TextEditingController();
  bool weightFrom() {
    if (_cargoResult.weightFrom == '' || _cargoResult.weightFrom == null) {
      return false;
    } else {
      return true;
    }
  }

  bool weightTo() {
    if (_cargoResult.weightTo == '' || _cargoResult.weightTo == null) {
      return false;
    } else {
      return true;
    }
  }

  bool priceFrom() {
    if (_cargoResult.priceFrom == '' || _cargoResult.priceFrom == null) {
      return false;
    } else {
      return true;
    }
  }

  bool priceTo() {
    logger.d(_cargoResult.priceTo);
    if (_cargoResult.priceTo == '' || _cargoResult.priceTo == null) {
      return false;
    } else {
      return true;
    }
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (weightFrom() != weightTo()) {
      print('Not  equal Weight');
      if (!weightFrom()) {
        setState(() {
          weightColorFrom = Colors.red;
        });
      } else {
        setState(() {
          weightColorFrom = Helpers.hintColor;
        });
      }
      if (!weightTo()) {
        setState(() {
          weightColorTo = Colors.red;
        });
      } else {
        setState(() {
          weightColorTo = Helpers.hintColor;
        });
      }
    }

    if (priceFrom() != priceTo()) {
      print('Not  equal Price');
      logger.d(priceFrom());
      logger.d(priceTo());
      if (!priceFrom()) {
        setState(() {
          priceColorFrom = Colors.red;
        });
      }

      if (!priceTo()) {
        setState(() {
          priceColorTo = Colors.red;
        });
      }
    } else {
      setState(() {
        priceColorFrom = Helpers.hintColor;
        priceColorTo = Helpers.hintColor;
      });
    }

    if (isValid && weightFrom() == weightTo() && priceFrom() == priceTo()

    ) {
      _formKey.currentState!.save();
      //setState(() => loading = true);

      print(_cargoResult.fromRegion);
      print(_cargoResult.fromCity);

      print(_cargoResult.toRegion);
      print(_cargoResult.toCity);

      print('Weight From ${_cargoResult.weightFrom}');
      print('Weight To ${_cargoResult.weightTo}');

      print(_cargoResult.priceFrom);
      print(_cargoResult.priceTo);

      sl<CargoManager>().inRequestTransportGet.add(_cargoResult);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20.0),
                  Text(
                    'Откуда ',
                    style: Helpers.header2TextStyle,
                  ),
                  const SizedBox(height: 4.0),
                  StreamBuilder<Regions>(
                    stream: sl<CargoManager>().regionsTList$,
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
                          return _dropDownFromRegions(context, snapshot.data!);
                        case ConnectionState.done:
                          return Text('${snapshot.data} (closed)');
                      }
                      return null; // unreachable
                    },
                  ),
                  const SizedBox(height: 8.0),
                  StreamBuilder<List<Cities>>(
                      stream: sl<CargoManager>().cityTSelected$,
                      builder: (
                          BuildContext context,
                          AsyncSnapshot<List<Cities>> snapshot,
                          ) {
                        if (snapshot.hasError) {
                          return Text(
                            'Error: ${snapshot.error}',
                          );
                        }
                        //  logger.d(snapshot.connectionState);
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return const Text('');
                          case ConnectionState.waiting:
                            return const Opacity(
                              opacity: 0.0,
                              child: CircularProgressIndicator(),
                            );
                          case ConnectionState.active:
                            return _dropDownFromCities(context, snapshot.data!);
                          case ConnectionState.done:
                            return Text('${snapshot.data} (closed)');
                        }
                        return null; // unreachable
                      }),
                  const SizedBox(height: 20.0),
                  Text(
                    'Куда ',
                    style: Helpers.header2TextStyle,
                  ),
                  const SizedBox(height: 4.0),
                  StreamBuilder<Regions>(
                    stream: sl<CargoManager>().regionsTList$,
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
                  StreamBuilder<List<Cities>>(
                      stream: sl<CargoManager>().tcityToSelected$,
                      builder: (
                          BuildContext context,
                          AsyncSnapshot<List<Cities>> snapshot,
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
                            return _dropDownToCities(context, snapshot.data!);
                          case ConnectionState.done:
                            return Text('${snapshot.data} (closed)');
                        }
                        return null; // unreachable
                      }),
                  const SizedBox(height: 20.0),
                  Text(
                    'Вес груза, т ',
                    style: Helpers.header2TextStyle,
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: weightFromText,
                          decoration: InputDecoration(
                            hintText: 'От',
                            hintStyle: Helpers.hintStyle,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: weightColorFrom,
                                width: 2.0,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          onSaved: (value) {
                            _cargoResult.weightFrom = value!;
                          },
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: TextFormField(
                          controller: weightToText,
                          decoration: InputDecoration(
                            hintText: 'До',
                            hintStyle: Helpers.hintStyle,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: weightColorTo,
                                width: 2.0,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          onSaved: (value) {
                            _cargoResult.weightTo = value!;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    'Цена, сом ',
                    style: Helpers.header2TextStyle,
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: priceFromText,
                          decoration: InputDecoration(
                            hintText: 'От',
                            hintStyle: Helpers.hintStyle,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: priceColorFrom,
                                width: 2.0,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          onSaved: (value) {
                            _cargoResult.priceFrom = value!;
                          },
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: TextFormField(
                          controller: priceToText,
                          decoration: InputDecoration(
                            hintText: 'До',
                            hintStyle: Helpers.hintStyle,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: priceColorTo,
                                width: 2.0,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          onSaved: (value) {
                            logger.d(value);
                            _cargoResult.priceTo = value!;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          sl<CargoManager>().inRegionTSelected$.add(null);
                          sl<CargoManager>().inTRegionToSelected$.add(null);
                          setState(() {
                            weightFromText.text = '';
                            weightToText.text = '';
                            priceFromText.text = '';
                            priceToText.text = '';

                          });
                        },
                        child: Text(
                          'Сбросить',
                          style: Helpers.header1RedTextStyle,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _trySubmit,
                        child: const Text(
                          'Показать объявления',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                ],
              ),
            ),
          )),
    );
  }

  Widget _dropDownFromRegions(BuildContext context, Regions data) {
    var citiesFrom = <Cities>[];
    return Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(
              color: regionColorFrom,
            )),
        child: StreamBuilder<RegionResults>(
          stream: sl<CargoManager>().regionTSelected$,
          builder: (
              BuildContext context,
              AsyncSnapshot<RegionResults> snapshot,
              ) {
            print(snapshot.connectionState);
            return DropdownButton<RegionResults>(
              underline: Container(color: Colors.transparent),
              isExpanded: true,
              hint: Text(
                'Область',
                style: Helpers.hintStyle,
              ),
              // Not necessary for Option 1
              value: snapshot.data,
              onChanged: (newValue) {
                print(newValue!.name);
                print(newValue.id);
                _cargoResult.fromRegion = newValue.id.toString();
                logger.d('DropDownREgion $newValue');
                //  sl<CargoManager>().inCitySelected$.add(null);
                if (newValue.cities != null) {
                  citiesFrom = [];
                  citiesFrom = newValue.cities;
                  logger.d('DropDownREgion ${citiesFrom.length}');

                  sl<CargoManager>().inCityTSelected$.add(citiesFrom);
                } else {
                  citiesFrom = [Cities(name: 'Select')];
                }
                print(citiesFrom.length);

                sl<CargoManager>().inRegionTSelected$.add(newValue);
              },
              items: data.results.map((RegionResults items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(
                    items.name,
                    style: Helpers.header1TextStyle,
                  ),
                );
              }).toList(),
            );
          },
        ));
  }

  Widget _dropDownToRegions(BuildContext context, Regions data) {
    var citiesFrom = <Cities>[];
    final citiesTo = <Cities>[];
    return Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(
              color: regionColorTo,
            )),
        child: StreamBuilder<RegionResults>(
          stream: sl<CargoManager>().tregionToSelected$,
          builder: (
              BuildContext context,
              AsyncSnapshot<RegionResults> snapshot,
              ) {
            print(snapshot.connectionState);
            return DropdownButton<RegionResults>(
              underline: Container(color: Colors.transparent),
              isExpanded: true,
              hint: Text(
                'Область',
                style: Helpers.hintStyle,
              ),
              // Not necessary for Option 1
              value: snapshot.data,
              onChanged: (newValue) {
                print(newValue!.name);
                print(newValue.id);
                _cargoResult.toRegion = newValue.id.toString();
                logger.d('DropDownREgion $newValue');
                //  sl<CargoManager>().inCitySelected$.add(null);
                if (newValue.cities != null) {
                  citiesFrom = [];
                  citiesFrom = newValue.cities;
                  logger.d('DropDownREgion ${citiesFrom.length}');

                  sl<CargoManager>().inTCityToSelected$.add(citiesFrom);
                } else {
                  citiesFrom = [Cities(name: 'Select')];
                }
                print(citiesFrom.length);

                sl<CargoManager>().inTRegionToSelected$.add(newValue);
              },
              items: data.results.map((RegionResults items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(
                    items.name,
                    style: Helpers.header1TextStyle,
                  ),
                );
              }).toList(),
            );
          },
        ));
  }

  Widget _dropDownFromCities(BuildContext context, List<Cities> data) {
    Cities selectedFromCity;
    //logger.d(data);
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            color: regionColorFrom,
          )),
      child: StreamBuilder<Cities>(
          stream: sl<CargoManager>().cityTSelect$,
          builder: (BuildContext context, AsyncSnapshot<Cities> snapshot) {
            /* logger.d(snapshot.connectionState);
            logger.d(snapshot.data);
*/
            if (snapshot.hasError) {
              return Text(
                'Error: ${snapshot.error}',
              );
            }
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Text('');
              case ConnectionState.waiting:
                return DropdownButton<Cities>(
                  underline: Container(color: Colors.transparent),
                  isExpanded: true,
                  hint: Text(
                    'Город, район',
                    style: Helpers.hintStyle,
                  ),
                  // Not necessary for Option 1
                  value: snapshot.data,
                  onChanged: (newValue) {
                    /*   print(newValue.name);
                    print(newValue.id);*/
                    _cargoResult.fromCity = newValue!.id.toString();
                    selectedFromCity = newValue;
                    // sl<CargoManager>().inCitySelected$.close();
                    sl<CargoManager>().inTCitySelect$.add(newValue);
                    // print(selectedFromCity.name);
                  },

                  items: data.map((Cities items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(
                        items.name,
                        style: Helpers.header1TextStyle,
                      ),
                    );
                  }).toList(),
                );
              case ConnectionState.active:
                logger.d('Data Value ${snapshot.data!.name}');

                return DropdownButton<Cities>(
                  underline: Container(color: Colors.transparent),
                  isExpanded: true,
                  hint: Text(
                    'Город, район',
                    style: Helpers.hintStyle,
                  ),
                  // Not necessary for Option 1
                  value: selectedFromCity,
                  onChanged: (newValue) {
                    print(newValue!.name);
                    print(newValue.id);
                    _cargoResult.fromCity = newValue.id.toString();
                    selectedFromCity = newValue;
                    // sl<CargoManager>().inCitySelected$.close();
                    sl<CargoManager>().inTCitySelect$.add(newValue);
                    // print(selectedFromCity.name);
                  },

                  items: data.map((Cities items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(
                        items.name,
                        style: Helpers.header1TextStyle,
                      ),
                    );
                  }).toList(),
                );
              case ConnectionState.done:
                return Text('${snapshot.data} (closed)');
            }
            return const CircularProgressIndicator();
          }),
    );
  }

  Widget _dropDownToCities(BuildContext context, List<Cities> data) {
    Cities selectedToCity;
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            color: regionColorTo,
          )),
      child: StreamBuilder<Cities>(
          stream: sl<CargoManager>().tcityToSelect$,
          builder: (BuildContext context, AsyncSnapshot<Cities> snapshot) {
            /* logger.d(snapshot.connectionState);
            logger.d(snapshot.data);
*/
            if (snapshot.hasError) {
              return Text(
                'Error: ${snapshot.error}',
              );
            }
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Text('');
              case ConnectionState.waiting:
                return DropdownButton<Cities>(
                  underline: Container(color: Colors.transparent),
                  isExpanded: true,
                  hint: Text(
                    'Город, район',
                    style: Helpers.hintStyle,
                  ),
                  // Not necessary for Option 1
                  value: snapshot.data,
                  onChanged: (newValue) {
                    _cargoResult.toCity = newValue!.id.toString();
                    selectedToCity = newValue;
                    // sl<CargoManager>().inCitySelected$.close();
                    sl<CargoManager>().inTCityToSelect$.add(newValue);
                    // print(selectedFromCity.name);
                  },

                  items: data.map((Cities items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(
                        items.name,
                        style: Helpers.header1TextStyle,
                      ),
                    );
                  }).toList(),
                );
              case ConnectionState.active:
                logger.d('Data Value ${snapshot.data?.name}');

                return DropdownButton<Cities>(
                  underline: Container(color: Colors.transparent),
                  isExpanded: true,
                  hint: Text(
                    'Город, район',
                    style: Helpers.hintStyle,
                  ),
                  // Not necessary for Option 1
                  value: selectedToCity,
                  onChanged: (newValue) {
                    print(newValue!.name);
                    print(newValue.id);
                    _cargoResult.fromCity = newValue.id.toString();
                    selectedToCity = newValue;
                    // sl<CargoManager>().inCitySelected$.close();
                    sl<CargoManager>().inTCityToSelect$.add(newValue);
                    // print(selectedFromCity.name);
                  },

                  items: data.map((Cities items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(
                        items.name,
                        style: Helpers.header1TextStyle,
                      ),
                    );
                  }).toList(),
                );
              case ConnectionState.done:
                return Text('${snapshot.data} (closed)');
            }
            return const CircularProgressIndicator();
          }),
    );
  }
}
