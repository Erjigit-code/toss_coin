import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class CustomCupertinoLocalizations extends DefaultCupertinoLocalizations {
  @override
  String get selectAllButtonLabel => 'Бардыгын тандаңыз';

  static const LocalizationsDelegate<CupertinoLocalizations> delegate =
      _CustomCupertinoLocalizationsDelegate();

  static Future<CupertinoLocalizations> load(Locale locale) {
    return SynchronousFuture<CupertinoLocalizations>(
      CustomCupertinoLocalizations(),
    );
  }
}

class _CustomCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const _CustomCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'kg';

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      CustomCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(_CustomCupertinoLocalizationsDelegate old) => false;
}
