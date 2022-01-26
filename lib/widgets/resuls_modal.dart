import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../stores/stepper.dart';
import '../stores/steps.dart';

class ResultsModal extends StatelessWidget {
  const ResultsModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StepperStore>(context);
    final color1 = store.steps.whereType<ColorSelectStepStore>().first;
    final color2 = store.steps.whereType<ShadeColorSelectStore>().first;
    final country = store.steps.whereType<CountrySelectStepStore>().first;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            color1.selectedColor!,
            color2.selectedColor!,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Observer(builder: (context) {
            return Observer(builder: (context) {
              return Text(
                'Your country is ${country.selectedCountry!}',
                textScaleFactor: 1.5,
              );
            });
          })
        ],
      ),
    );
  }
}
