import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'app/app.dart';
import 'app/localization/locale_cubit.dart';
import 'app/theme/theme_cubit.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Preserve the native-style web splash screen during initialization.
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Ensure the status bar is transparent on mobile platforms.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Restore saved theme and locale preferences.
  final themeCubit = ThemeCubit();
  final localeCubit = LocaleCubit();
  await Future.wait([
    themeCubit.loadSavedTheme(),
    localeCubit.loadSavedLocale(),
  ]);

  runApp(App(
    themeCubit: themeCubit,
    localeCubit: localeCubit,
  ));

  // Automatically remove the native splash screen once the first frame renders.
  FlutterNativeSplash.remove();
}
