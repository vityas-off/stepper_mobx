import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../stores/stepper.dart';
import '../stores/steps.dart';

import 'country_select_step.dart';
import 'license_step.dart';
import 'color_select_step.dart';
import 'resuls_modal.dart';

class MyStepper extends StatefulWidget {
  const MyStepper({Key? key}) : super(key: key);

  @override
  State<MyStepper> createState() => _MyStepperState();
}

class _MyStepperState extends State<MyStepper> {
  Iterable<Step> _mapStepsToWidgets(List<BaseStep> steps) {
    return steps.map((step) {
      late Step widget;

      if (step is CountrySelectStepStore) {
        widget = Step(
          title: Observer(
            builder: (_) =>
                Text(step.completed ? 'Country selected' : 'Select country'),
          ),
          content: Provider<CountrySelectStepStore>(
            create: (_) => step,
            child: const CountrySelectStep(),
          ),
        );
      } else if (step is LicenseStepStore) {
        var text = step.completed ? 'License acepted' : 'License not acepted';
        if (step.shouldCheckGdpr) {
          text += ', telemetry ' + (step.gdprAccepted ? 'on' : "off");
        }
        widget = Step(
          title: Text(text),
          content: Provider<LicenseStepStore>(
            create: (_) => step,
            child: const LicenseStep(),
          ),
        );
      } else if (step is ColorSelectStepStore) {
        widget = Step(
          title: Observer(builder: (_) {
            var text = '';
            if (step is ShadeColorSelectStore) {
              text = step.completed ? 'Shade selected' : 'Select shade';
            } else {
              text = step.completed ? 'Color selected' : 'Select color';
            }
            return Text(text);
          }),
          content: Provider<ColorSelectStepStore>(
            create: (_) => step,
            child: ColorsStep(
              key: ValueKey(step.toString()),
            ),
          ),
        );
      }

      return widget;
    });
  }

  _showError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text('Try again'),
      ),
    );
  }

  _showResults(StepperStore store) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Provider.value(
        value: store,
        child: const ResultsModal(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StepperStore>(context);
    store.errorCallback = _showError;
    store.resultsCallback = () => _showResults(store);

    return Observer(builder: (context) {
      return Stepper(
        currentStep: store.index,
        onStepContinue: store.nextStep,
        onStepCancel: store.prevStep,
        onStepTapped: (index) =>
            index <= store.greatestReachableIndex ? store.setStep(index) : null,
        controlsBuilder: (context, details) {
          final step = store.steps.elementAt(details.stepIndex);

          return Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (details.stepIndex > 0)
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Previous step'),
                  ),
                const SizedBox(width: 16),
                Observer(
                  builder: (context) {
                    final isLastStep = details.stepIndex == store.lastStepIndex;
                    return ElevatedButton(
                      onPressed: step.completed ? details.onStepContinue : null,
                      child: Text(
                        isLastStep ? 'Finish' : 'Continue',
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
        steps: _mapStepsToWidgets(store.steps).toList(),
      );
    });
  }
}
