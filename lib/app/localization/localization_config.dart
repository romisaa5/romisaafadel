import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../l10n/generated/app_localizations.dart';

/// All supported locales for the application.
const List<Locale> appSupportedLocales = [
  Locale('en'),
  Locale('ar'),
];

/// All delegates required for Flutter localization including Arabic RTL support.
const List<LocalizationsDelegate<dynamic>> appLocalizationDelegates = [
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];
