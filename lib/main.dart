import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepper_mobx/stores/stepper.dart';
import 'package:stepper_mobx/widgets/my_stepper.dart';
import 'package:flutter/foundation.dart';

import 'steps_config.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Stepper MobX';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(_title),
          centerTitle: true,
        ),
        body: Provider<StepperStore>(
          create: (_) => createDefaultSteps(),
          child: const Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: kIsWeb ? 400 : double.infinity,
              child: MyStepper(),
            ),
          ),
        ),
      ),
    );
  }
}
