// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:onoy_kg/managers/users_manager.dart';
import 'package:onoy_kg/models/cargo.dart';
import 'package:onoy_kg/ui/widgets/card_item.dart';

import '../../../service_locator.dart';

class MyList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<Cargo>(
        stream: sl<UsersManager>().publishedAdds$,
        builder: (BuildContext context, AsyncSnapshot<Cargo> snapshot) {
          print(snapshot);
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Text('Select lot');
            case ConnectionState.waiting:
              return const Opacity(
                opacity: 0.0,
                child:  CircularProgressIndicator(),
              );
            case ConnectionState.active:
              return CardItem(snapshot.data!);
            case ConnectionState.done:
              return Text('${snapshot.data} (closed)');
          }
          return null; // unreachable
        },
      ),
    );
  }
}
