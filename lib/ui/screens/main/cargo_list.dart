// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:onoy_kg/managers/cargo_manager.dart';
import 'package:onoy_kg/models/cargo.dart';
import 'package:onoy_kg/ui/widgets/card_item.dart';

import '../../../service_locator.dart';

class CargoList extends StatelessWidget {
  CargoList(this._stream);

  final Stream<Cargo> _stream;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<Cargo>(
        stream: _stream,
        builder: (BuildContext context, AsyncSnapshot<Cargo> snapshot) {
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
              return CardItem(snapshot.data!);
            case ConnectionState.done:
              return Text('${snapshot.data} (closed)');
          }
          // ignore: dead_code
          return null; // unreachable
        },
      ),
    );
  }
}
