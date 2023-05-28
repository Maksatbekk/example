// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onoy_kg/models/results.dart';
import 'package:onoy_kg/ui/helpers/helpers.dart';

class ItemCard extends StatelessWidget {
  ItemCard(this.cargo);

  final Results cargo;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-DDThh:mm:ss');
    final dateTime = dateFormat.parse(cargo.datePublished);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        cargo.name,
                        style: Helpers.header1CardTextStyle,
                      ),
                    ],
                  ),
                  const IconButton(
                      icon: Icon(
                        Icons.bookmark_border_sharp,
                        color: Helpers.blueColor,
                      ),
                      onPressed: null)
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.brightness_1_outlined,
                    color: Helpers.blueColor,
                    size: 10,
                  ),
                  const SizedBox(width: 10.0),
                  Text(
                    cargo.fromRegion + ', ' + cargo.fromCity,
                    style: Helpers.hintStyle,
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Icon(
                    Icons.brightness_1_rounded,
                    color: Helpers.blueColor,
                    size: 10,
                  ),
                  const SizedBox(width: 10.0),
                  Text(
                    cargo.toRegion + ', ' + cargo.toCity,
                    style: Helpers.hintStyle,
                  )
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Text(cargo.fromShipmentDate + '  -  ' + cargo.toShipmentDate),
                  const SizedBox(width: 20.0),
                  Text('${cargo.weight}т / м³'),
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Container(
                    height: 30,
                    width: 80,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: Helpers.greenColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.0),
                        )),
                    child: Text(
                      '${cargo.price} c',
                      style: Helpers.header1WhiteTextStyle,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Text(
                    'Картой',
                    style: Helpers.header2TextStyle,
                  )
                ],
              ),
              const SizedBox(height: 20.0),
              Container(
                height: 2.0,
                decoration: const BoxDecoration(color: Helpers.greyColor),
              ),
              const SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${dateTime.day}'
                    '.${dateTime.month.toString().padLeft(2, '0')}'
                    '.${dateTime.year}, в '
                    '${dateTime.hour.toString().padLeft(2, '0')} '
                    ': ${dateTime.minute.toString().padLeft(2, '0')} ч',
                    style: Helpers.header2CardTextStyle,
                  ),
                  InkWell(
                    onTap: () => displayMore(context),
                    child: Text(
                      'Подробнее',
                      style: Helpers.header2BlueTextStyle,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void displayMore(BuildContext context) {
    final dateFormat = DateFormat('yyyy-mm-DDThh:mm:ssZ');
    final dateTime = dateFormat.parse(cargo.datePublished);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                cargo.name,
                                style: Helpers.header1CardTextStyle,
                              ),
                              //const SizedBox(width: 8.0),
                              /* Text(
                                '${cargo.name}',
                                style: Helpers.header2CardTextStyle,
                              ),*/
                            ],
                          ),
                          const IconButton(
                              icon: Icon(
                                Icons.bookmark_border_sharp,
                                color: Helpers.blueColor,
                              ),
                              onPressed: null)
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.brightness_1_outlined,
                            color: Helpers.blueColor,
                            size: 10,
                          ),
                          const SizedBox(width: 10.0),
                          Text(
                            cargo.fromRegion + ', ' + cargo.fromCity,
                            style: Helpers.hintStyle,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Row(children: [
                        const Icon(
                          Icons.brightness_1_rounded,
                          color: Helpers.blueColor,
                          size: 10,
                        ),
                        const SizedBox(width: 10.0),
                        Text(
                          cargo.toRegion + ', ' + cargo.toCity,
                          style: Helpers.hintStyle,
                        )
                      ]),
                      const SizedBox(height: 16.0),
                      Row(children: [
                        Text(
                          // ignore: lines_longer_than_80_chars
                          cargo.fromShipmentDate + '  -  ' + cargo.toShipmentDate,
                        ),
                        const SizedBox(width: 20.0),
                        Text('${cargo.weight}т / м³')
                      ]),
                      const SizedBox(height: 20.0),
                      Row(children: [
                        Container(
                          height: 30,
                          width: 80,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              color: Helpers.greenColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(4.0),
                              )),
                          child: Text(
                            '${cargo.price} c',
                            style: Helpers.header1WhiteTextStyle,
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Text('Картой', style: Helpers.header2TextStyle)
                      ]),
                      const SizedBox(height: 20.0),
                      Container(
                          height: 2.0,
                          decoration: const BoxDecoration(
                            color: Helpers.greyColor,
                          )),
                      const SizedBox(height: 12.0),
                      if (cargo.cargoComment != null)
                        Text(
                          'Комментарий к отправке',
                          style: Helpers.hintStyle,
                        ),
                      if (cargo.cargoComment != null)
                        Text(
                          cargo.cargoComment,
                          style: Helpers.bottomSheetTextStyle,
                        ),
                      if (cargo.vehicleComment != null)
                        Text('Комментарий к грузу', style: Helpers.hintStyle),
                      if (cargo.vehicleComment != null)
                        Text(
                          cargo.vehicleComment,
                          style: Helpers.bottomSheetTextStyle,
                        ),
                      const SizedBox(height: 20.0),
                      Container(
                        width: double.infinity,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cargo.user.name,
                                  style: Helpers.header1TextStyle,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  cargo.user.phoneNumber,
                                  style: Helpers.header1TextStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18.0),
                      Text(
                          '${dateTime.day}.'
                          '${dateTime.month.toString().padLeft(2, '0')}.'
                          '${dateTime.year}, в '
                          '${dateTime.hour.toString().padLeft(2, '0')} : '
                          '${dateTime.minute.toString().padLeft(2, '0')} ч',
                          style: Helpers.header2CardTextStyle),
                      const SizedBox(height: 16.0)
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
