import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyLocalization {
  MyLocalization(this.locale);

  final Locale locale;
  static MyLocalization of(BuildContext context) {
    return Localizations.of<MyLocalization>(context, MyLocalization)!;
  }

  late dynamic _localizedValues;

  Future<dynamic> load() async {
    String jsonStringValues = await rootBundle
        .loadString('assets/locale/${locale.languageCode}.json');
    _localizedValues = json.decode(jsonStringValues);
  }

  String translate(String pageKey, String textKey) {
    Map<String, dynamic> parsedData = _localizedValues;

    String data = parsedData[pageKey][textKey];

    return data;
  }

  // static member to have simple access to the delegate from Material App
  static const LocalizationsDelegate<MyLocalization> delegate =
      _MyLocalizationsDelegate();
}

class _MyLocalizationsDelegate extends LocalizationsDelegate<MyLocalization> {
  const _MyLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en'].contains(locale.languageCode);
  }

  @override
  Future<MyLocalization> load(Locale locale) async {
    MyLocalization localization = MyLocalization(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(LocalizationsDelegate<MyLocalization> old) => false;
}
