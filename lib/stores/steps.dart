import 'package:mobx/mobx.dart';
import 'package:flutter/material.dart' show Color, MaterialColor;
import 'package:stepper_mobx/client.dart';

part 'steps.g.dart';

abstract class BaseStep {
  bool get completed;
  bool get syncronized;
  bool get syncingNow;
  Future<void> sync();
}

/// Выбор страны
class CountrySelectStepStore = _CountrySelectStepStore
    with _$CountrySelectStepStore;

abstract class _CountrySelectStepStore with Store implements BaseStep {
  final List<String> countries;
  final List<String> gdprCountries;

  _CountrySelectStepStore({
    required this.countries,
    this.gdprCountries = const [],
  });

  @observable
  String? selectedCountry;

  @observable
  String? savedCountry;

  @override
  @observable
  var syncingNow = false;

  @computed
  bool get isGdprEnabled => gdprCountries.contains(selectedCountry);

  @override
  @computed
  bool get completed => selectedCountry != null;

  @override
  @computed
  bool get syncronized => selectedCountry == savedCountry;

  @action
  void selectCountry(String counrty) => selectedCountry = counrty;

  @action
  @override
  Future<void> sync() async {
    final country = selectedCountry;
    if (country != null) {
      syncingNow = true;
      try {
        await client.postCountry(country: country);
        savedCountry = country;
      } finally {
        syncingNow = false;
      }
    }
  }
}

/// Принятие лицензии и зависимо от выбранной страны согласие на сбор данных
class LicenseStepStore = _LicenseStepStore with _$LicenseStepStore;

abstract class _LicenseStepStore with Store implements BaseStep {
  final CountrySelectStepStore _countryStore;

  _LicenseStepStore({required countryStore}) : _countryStore = countryStore;

  @override
  @observable
  var completed = false;

  @action
  setCheckbox(bool val) {
    completed = val;
  }

  @computed
  bool get shouldCheckGdpr => _countryStore.isGdprEnabled;

  @observable
  var gdprAccepted = false;

  @override
  bool get syncronized => true;

  @override
  bool get syncingNow => false;

  @override
  Future<void> sync() async {}

  @action
  setGdpr(bool val) {
    gdprAccepted = val;
  }
}

/// Выбор цвета
class ColorSelectStepStore = _ColorSelectStepStore with _$ColorSelectStepStore;

abstract class _ColorSelectStepStore with Store implements BaseStep {
  @override
  @computed
  bool get completed => selectedColor != null;

  @observable
  List<Color> colors = [];

  @observable
  Color? selectedColor;

  @observable
  Color? savedColor;

  @action
  setColors(List<Color> newColors) => colors = newColors;

  @action
  selectColor(Color color) => selectedColor = color;

  @override
  @computed
  bool get syncronized => selectedColor == savedColor;

  @override
  @observable
  var syncingNow = false;

  @override
  @action
  Future<void> sync() async {
    final color = selectedColor;
    if (color != null) {
      syncingNow = true;
      try {
        await client.postColor(color: color);
        savedColor = color;
      } finally {
        syncingNow = false;
      }
    }
  }
}

/// Выбор оттенка выбранного ранее цвета
class ShadeColorSelectStore extends ColorSelectStepStore {
  static final shadeIndexes = List.generate(9, (index) => (index + 1) * 100);

  ShadeColorSelectStore({required ColorSelectStepStore baseColorStore}) {
    reaction<Color?>((_) => baseColorStore.selectedColor, (color) {
      final List<Color> newColors = color == null
          ? []
          : shadeIndexes
              .map((index) => color is MaterialColor ? color[index]! : color)
              .toList();
      colors = newColors;
      selectedColor = null;
    });
  }
}
