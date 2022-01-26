import 'dart:math';
import 'package:mobx/mobx.dart';

import 'steps.dart';

part 'stepper.g.dart';

class StepperStore = _StepperStore with _$StepperStore;

abstract class _StepperStore with Store {
  _StepperStore({required this.steps});

  Function? errorCallback;

  Function? resultsCallback;

  @observable
  List<BaseStep> steps = [];

  @observable
  int index = 0;

  @computed
  bool get locked => steps.any((step) => step.syncingNow);

  @computed
  BaseStep get currentStep => steps.elementAt(index);

  @computed
  bool get canGoNext => index < steps.length && currentStep.completed;

  @computed
  bool get canGoBack => index > 0;

  @computed
  int get greatestReachableIndex => [
        steps.indexWhere((step) => !step.completed),
        steps.indexWhere((step) => !step.syncronized),
      ]
          .map((index) => index == -1 ? steps.length - 1 : index)
          .toList()
          .reduce(min);

  @computed
  int get lastStepIndex => steps.length - 1;

  @action
  Future<void> nextStep() async {
    if (!locked && canGoNext) {
      try {
        if (!currentStep.syncronized) await currentStep.sync();
        if (index + 1 < steps.length) {
          setStep(index + 1);
        } else {
          final callback = resultsCallback;
          if (callback != null) callback();
        }
      } on int catch (_) {
        final callback = errorCallback;
        if (callback != null) callback();
      }
    }
  }

  @action
  void prevStep() => index--;

  @action
  void setStep(int newIndex) => index = newIndex;
}
