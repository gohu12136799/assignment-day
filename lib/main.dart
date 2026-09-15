import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';
import 'locale_controller.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const AssignmentDayApp());
}

class AssignmentDayApp extends StatefulWidget {
  const AssignmentDayApp({super.key});

  @override
  State<AssignmentDayApp> createState() => _AssignmentDayAppState();
}

class _AssignmentDayAppState extends State<AssignmentDayApp> {
  // Mặc định tiếng Việt; user đổi trên Home.
  final LocaleController _localeController = LocaleController();

  @override
  void dispose() {
    _localeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder: khi locale đổi → rebuild MaterialApp.
    return ListenableBuilder(
      listenable: _localeController,
      builder: (context, _) {
        return LocaleScope(
          controller: _localeController,
          child: MaterialApp(
            onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
            debugShowCheckedModeBanner: false,
            locale: _localeController.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
              useMaterial3: true,
              fontFamily: 'NunitoSans',
            ),
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}
