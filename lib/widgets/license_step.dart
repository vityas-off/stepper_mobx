import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../stores/steps.dart';

class LicenseStep extends StatelessWidget {
  const LicenseStep({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<LicenseStepStore>(context);

    return Observer(builder: (_) {
      return Column(
        children: [
          CheckboxListTile(
            title: const Text("Accept the license agreement"),
            value: store.completed,
            onChanged: (val) {
              if (val != null) {
                store.setCheckbox(val);
              }
            },
          ),
          if (store.shouldCheckGdpr)
            SwitchListTile(
              title: const Text("Allow collecting analytics data"),
              value: store.gdprAccepted,
              onChanged: store.setGdpr,
            )
        ],
      );
    });
  }
}
