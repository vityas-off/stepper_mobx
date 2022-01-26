import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../stores/steps.dart';

class CountrySelectStep extends StatelessWidget {
  const CountrySelectStep({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<CountrySelectStepStore>(context);

    return Column(
      children: store.countries
          .map(
            (country) => Observer(builder: (_) {
              return RadioListTile<String>(
                value: country,
                groupValue: store.selectedCountry,
                onChanged: (value) {
                  if (value != null) {
                    store.selectCountry(value);
                  }
                },
                title: Text(country),
              );
            }),
          )
          .toList(),
    );
  }
}
