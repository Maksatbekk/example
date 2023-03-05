import 'package:flutter/material.dart';
import 'package:onoy_kg/models/cargo.dart';
import 'package:onoy_kg/ui/screens/main/item_card.dart';
import 'package:onoy_kg/ui/widgets/footer.dart';

class CardItem extends StatelessWidget {

  CardItem(this._cargo);

  final Cargo _cargo;

  @override
  Widget build(BuildContext context) {
    print(_cargo.count);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            Column(
              children: [
                ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _cargo.results.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ItemCard(_cargo.results[index]);
                  },
                ),
              ],

            ),
            if(_cargo.count > 5 )
            footer()

          ],
        ),
      ),
    );
  }
}
