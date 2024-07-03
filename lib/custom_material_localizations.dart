import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomMaterialLocalizations extends DefaultMaterialLocalizations {
  const CustomMaterialLocalizations();

  static const LocalizationsDelegate<MaterialLocalizations> delegate =
      _CustomMaterialLocalizationsDelegate();

  static Future<MaterialLocalizations> load(Locale locale) {
    return SynchronousFuture<MaterialLocalizations>(
      const CustomMaterialLocalizations(),
    );
  }

  @override
  String get openAppDrawerTooltip => 'Навигация менюну ачуу';
  @override
  String get backButtonTooltip => 'Артка';
  @override
  String get closeButtonLabel => 'Жабуу';
  @override
  String get deleteButtonTooltip => 'Өчүрүү';
  @override
  String get nextMonthTooltip => 'Кийинки ай';
  @override
  String get previousMonthTooltip => 'Өткөн ай';
  @override
  String get searchFieldLabel => 'Издөө';
  String get todayLabel => 'Бүгүн';
  // Добавьте здесь другие переводы, если необходимо
}

class _CustomMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _CustomMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'kg';

  @override
  Future<MaterialLocalizations> load(Locale locale) =>
      CustomMaterialLocalizations.load(locale);

  @override
  bool shouldReload(_CustomMaterialLocalizationsDelegate old) => false;
}
