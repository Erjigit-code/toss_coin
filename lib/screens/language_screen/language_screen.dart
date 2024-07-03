import 'dart:ui';
import 'package:coin_flip/generated/locale_keys.g.dart';
import 'package:country_flags/country_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  late FixedExtentScrollController _controller;
  int selectedIndex = 0;
  final List<Locale> supportedLocales = [
    const Locale('en'),
    const Locale('de'),
    const Locale('ru'),
    const Locale('kg'),
    const Locale('tr')
  ];
  final List<String> localeNames = [
    'English',
    'Deutsch',
    'Русский',
    'Кыргызча',
    'Türkçe'
  ];
  final List<String> countryCodes = [
    'US', // English
    'DE', // Deutsch
    'RU', // Русский
    'KG', // Кыргызча
    'TR' // Türkçe
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedIndex = supportedLocales.indexOf(context.locale);
    _controller = FixedExtentScrollController(initialItem: selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(LocaleKeys.choose_language.tr()),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background/back.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: kToolbarHeight + 16.0),
            child: Center(
              child: ListWheelScrollView.useDelegate(
                controller: _controller,
                itemExtent: 160,
                perspective: 0.010,
                onSelectedItemChanged: (index) {
                  setState(() {
                    selectedIndex = index % supportedLocales.length;
                  });
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  builder: (context, index) {
                    final actualIndex = index % supportedLocales.length;
                    final localeName = localeNames[actualIndex];
                    final countryCode = countryCodes[actualIndex];
                    final isSelected = selectedIndex == actualIndex;
                    return Center(
                      child: Container(
                        height: 150,
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(45),
                          border: isSelected
                              ? Border.all(color: Colors.white, width: 1.2)
                              : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CountryFlag.fromCountryCode(
                              countryCode,
                              width: 50.0,
                              height: 50.0,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              localeName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.blue : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: supportedLocales.length,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.setLocale(supportedLocales[selectedIndex]);
          Navigator.pop(context);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
