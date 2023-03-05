import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onoy_kg/managers/cargo_manager.dart';
import 'package:onoy_kg/models/cities_model.dart';
import 'package:onoy_kg/models/region_results.dart';
import 'package:onoy_kg/models/regions_model.dart';
import 'package:onoy_kg/models/results.dart';
import 'package:onoy_kg/services/cargo_service.dart';
import 'package:onoy_kg/ui/helpers/helpers.dart';
import 'package:onoy_kg/ui/screens/authorization/login_view_number.dart';
import 'package:onoy_kg/ui/screens/authorization/phone_otp.dart';
import 'package:onoy_kg/ui/widgets/filter/filter_item.dart';
import 'package:onoy_kg/ui/widgets/filter/filter_transport.dart';
import 'package:onoy_kg/ui/widgets/filter_widget.dart';

import '../../../service_locator.dart';
import 'cargo_list.dart';

class MainTabs extends StatefulWidget {
  @override
  _MainTabsState createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs> with AutomaticKeepAliveClientMixin<MainTabs> {
  @override
  bool get wantKeepAlive => true;
  TabController _controller;
  final _formKey = GlobalKey<FormState>();
  final _cargoResult = Results();
  var regionColorFrom = Helpers.hintColor;
  var regionColorTo = Helpers.hintColor;
  var cityColorFrom = Helpers.hintColor;
  var cityColorTo = Helpers.hintColor;
  RegionResults selectedFromRegion;
  RegionResults selectedToRegion;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              'Грузоперевозки по всей стране',
              style: Helpers.titleTextStyle,
            ),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Stack(
              children: [
                Center(
                  child: ButtonsTabBar(
                    buttonMargin: const EdgeInsets.symmetric(
                      vertical: 4,
                    ),
                    borderColor: Helpers.blueColor,
                    borderWidth: 1,
                    unselectedBorderColor: Colors.transparent,
                    backgroundColor: const Color(0xffE5F2FF),
                    unselectedBackgroundColor: Colors.white,
                    unselectedLabelStyle: const TextStyle(
                      color: Color(0xff909090),
                    ),
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    controller: _controller,
                    tabs: const [
                      Tab(text: 'Груз'),
                      Tab(text: 'Транспорт'),
                    ],
                  ),
                ),
                Positioned(
                  right: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.filter_list_alt),
                      onPressed: () {
                        filterMenu(context);
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              //  controller: _controller,
              children: [
                CargoList(sl<CargoManager>().cargoList$),
                CargoList(sl<CargoManager>().transportationList$),
                //TransportList()
                //CargoList(sl<CargoManager>().transportationList$),
              ],
            ),
          )
        ],
      ),
    );
  }

  void filterMenu(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        builder: (BuildContext buildContext) {
          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const SizedBox(height: 14.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      InkWell(
                          onTap:(){
                            Navigator.pop(context);
                          },
                          child: Image.asset('assets/images/cancel.png')),
                      const SizedBox(width: 40.0),
                      Text('Фильтр', style: Helpers.header1TextStyle),

                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: ButtonsTabBar(
                      buttonMargin: const EdgeInsets.symmetric(
                        vertical: 4,
                      ),
                      borderColor: Helpers.blueColor,
                      borderWidth: 1,
                      unselectedBorderColor: Colors.transparent,
                      backgroundColor: const Color(0xffE5F2FF),
                      unselectedBackgroundColor: Colors.white,
                      unselectedLabelStyle: const TextStyle(
                        color: Color(0xff909090),
                      ),
                      labelStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      controller: _controller,
                      tabs: const [
                        Tab(text: 'Груз'),
                        Tab(text: 'Транспорт'),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    //  controller: _controller,
                    children: [
                      FilterItems(),
                      FilterTransport(),
                      //  CargoList(sl<CargoManager>().transportationList$),
                      //TransportList()
                      //CargoList(sl<CargoManager>().transportationList$),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
