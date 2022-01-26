import 'package:flutter/material.dart' show Colors;

import 'stores/stepper.dart';
import 'stores/steps.dart';

StepperStore createDefaultSteps() {
  const countries = ['USA', 'Russia', 'Ukraine', 'Germany', 'England'];
  const gdprCountries = ['Germany', 'England'];
  final step0 = CountrySelectStepStore(
      countries: countries, gdprCountries: gdprCountries);

  final colors = [
    Colors.amber,
    Colors.green,
    Colors.pink,
    Colors.blue,
    Colors.brown,
    Colors.purple,
  ];
  final step1 = LicenseStepStore(countryStore: step0);
  final step2 = ColorSelectStepStore();
  step2.setColors(colors);

  final step3 = ShadeColorSelectStore(baseColorStore: step2);

  return StepperStore(
    steps: [step0, step1, step2, step3],
  );
}
