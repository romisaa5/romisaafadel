import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'routing/app_router.dart';
import 'theme/app_theme.dart';
import 'theme/theme_cubit.dart';
import 'theme/theme_state.dart';
import 'localization/locale_cubit.dart';
import 'localization/locale_state.dart';
import 'localization/localization_config.dart';
import '../features/splash/presentation/cubit/splash_cubit.dart';

/// Root application widget.
///
/// Provides ThemeCubit, LocaleCubit, and SplashCubit to the widget tree via
/// MultiBlocProvider. MaterialApp.router is driven by go_router and reacts to
/// theme and locale changes from their respective cubits.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
        BlocProvider<LocaleCubit>(create: (_) => LocaleCubit()),
        BlocProvider<SplashCubit>(create: (_) => SplashCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<LocaleCubit, LocaleState>(
            builder: (context, localeState) {
              return MaterialApp.router(
                title: 'Romisaa Fadel',
                debugShowCheckedModeBanner: false,

                // Theme
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: themeState.mode,

                // Routing
                routerConfig: appRouter,

                // Localization
                locale: localeState.locale,
                supportedLocales: appSupportedLocales,
                localizationsDelegates: appLocalizationDelegates,
              );
            },
          );
        },
      ),
    );
  }
}
