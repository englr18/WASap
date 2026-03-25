import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localizations.dart';

import 'presentation/theme/app_theme.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/providers/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const WASapApp(),
    ),
  );
}

/// Main application widget.
class WASapApp extends ConsumerWidget {
  const WASapApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsControllerProvider);

    return MaterialApp(
      title: 'WASap',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: settingsState.settings.themeMode,

      // Localization
      locale: settingsState.settings.locale,
      supportedLocales: const [Locale('en'), Locale('id')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // Home screen
      home: const HomeScreen(),
    );
  }
}
