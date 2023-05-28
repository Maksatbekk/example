import 'package:flutter/material.dart';
import 'package:onoy_kg/ui/helpers/helpers.dart';

class TransportWidget extends StatefulWidget {
  @override
  _TransportWidgetState createState() => _TransportWidgetState();
}

class _TransportWidgetState extends State<TransportWidget> {
  final _formKey = GlobalKey<FormState>();

  final List<String> _locations = ['A', 'B', 'C', 'D'];

  late String _selectedLocation;
  var fromDate;
  var toDate;

  Future<void> callDatePickerFrom() async {
    final order = await getDate();
    final month = Helpers.getMonth(order!.month);
    print(month);

    setState(() {
      fromDate = 'с ${order.day}  $month ${order.year}';
    });
  }

  Future<void> callDatePickerTo() async {
    final order = await getDate();
    final month = Helpers.getMonth(order!.month);
    print(month);

    setState(() {
      toDate = 'с ${order.day}  $month ${order.year}';
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
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Container(
                  height: 35,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(
                        color: Colors.grey,
                      )),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Тип транспорта',
                          style: Helpers.hintStyle,
                        ),
                        const Icon(Icons.keyboard_arrow_down)
                      ],
                    ),
                  )),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(
                            color: Colors.grey,
                          )),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '     Грузовик     ',
                          style: Helpers.hintStyle,
                        ),
                      )),
                  Container(
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(
                            color: Colors.grey,
                          )),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '     Полуприцеп     ',
                          style: Helpers.hintStyle,
                        ),
                      )),
                  Container(
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(
                            color: Colors.grey,
                          )),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '     Сцепка     ',
                          style: Helpers.hintStyle,
                        ),
                      )),
                  const SizedBox(height: 20.0),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Откуда ',
                style: Helpers.header2TextStyle,
              ),
              const SizedBox(height: 4.0),
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
                  hint: Text(
                    'Область',
                    style: Helpers.hintStyle,
                  ),
                  // Not necessary for Option 1
                  value: _selectedLocation,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedLocation = newValue!;
                    });
                  },
                  items: _locations.map((location) {
                    return DropdownMenuItem(
                      value: location,
                      child: Text(
                        location,
                        style: Helpers.header1TextStyle,
                      ),
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
                  hint: Text(
                    'Город, район',
                    style: Helpers.hintStyle,
                  ),
                  // Not necessary for Option 1
                  value: _selectedLocation,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedLocation = newValue!;
                    });
                  },
                  items: _locations.map((location) {
                    return DropdownMenuItem(
                      value: location,
                      child: Text(
                        location,
                        style: Helpers.header1TextStyle,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.maxFinite,
                decoration: const BoxDecoration(color: Helpers.blueLightColor),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Helpers.blueLightColor,
                  ),
                  // elevation: 0,
                  onPressed: callDatePickerTo,
                  // color: Helpers.blueLightColor,
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.transparent),
                    // padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: toDate == null
                        ? Text(
                            'Select a Date',
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
              const SizedBox(height: 20.0),
              Text(
                'Куда ',
                style: Helpers.header2TextStyle,
              ),
              const SizedBox(height: 4.0),
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
                  hint: Text(
                    'Область',
                    style: Helpers.hintStyle,
                  ),
                  // Not necessary for Option 1
                  value: _selectedLocation,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedLocation = newValue!;
                    });
                  },
                  items: _locations.map((location) {
                    return DropdownMenuItem(
                      value: location,
                      child: Text(
                        location,
                        style: Helpers.header1TextStyle,
                      ),
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
                  hint: Text(
                    'Город, район',
                    style: Helpers.hintStyle,
                  ),
                  // Not necessary for Option 1
                  value: _selectedLocation,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedLocation = newValue!;
                    });
                  },
                  items: _locations.map((location) {
                    return DropdownMenuItem(
                      value: location,
                      child: Text(
                        location,
                        style: Helpers.header1TextStyle,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8.0),
              Container(
                width: double.maxFinite,
                decoration: const BoxDecoration(color: Helpers.blueLightColor),
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
                            'Select a Date',
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
              const SizedBox(height: 20.0),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: Helpers.blueColor,
                ),
                height: 35.0,
                width: double.infinity,
                child: Center(
                    child: Text(
                  'Еще...',
                  style: Helpers.header1WhiteTextStyle,
                )),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
