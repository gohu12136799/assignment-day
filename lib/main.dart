import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'auth/auth_controller.dart';
import 'auth/auth_scope.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'locale_controller.dart';
import 'screens/splash_screen.dart';
import 'theme/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var firebaseReady = false;
  // Bước 0: nếu có cấu hình firebase thì khởi động firebase. Nếu chưa có, app chạy ở chế độ khách.

  if (DefaultFirebaseOptions.isConfigured) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      firebaseReady = true;
    } catch (_) {
      firebaseReady = false;
    }
  }

  final authController = AuthController();
  await authController.bootstrap(firebaseConfigured: firebaseReady);
  /**bootstrap() trong auth_controller.dart làm hai việc:
Kiểm tra lần trước có còn đăng nhập không. Firebase tự lưu phiên, nên mở lại app không phải đăng nhập lại.
Lắng nghe authStateChanges. Mỗi lần đăng nhập hoặc đăng xuất, controller gọi notifyListeners(). */

  runApp(AssignmentDayApp(authController: authController));
}

class AssignmentDayApp extends StatefulWidget {
  const AssignmentDayApp({super.key, required this.authController});

  final AuthController authController;

  @override
  State<AssignmentDayApp> createState() => _AssignmentDayAppState();
}

class _AssignmentDayAppState extends State<AssignmentDayApp> {
  final LocaleController _localeController = LocaleController();

  @override
  void dispose() {
    _localeController.dispose();
    widget.authController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_localeController, widget.authController]),
      builder: (context, _) {
        return AuthScope(
          controller: widget.authController,
          child: LocaleScope(
            controller: _localeController,
            child: MaterialApp(
              onGenerateTitle: (context) =>
                  AppLocalizations.of(context)!.appTitle,
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
                colorScheme: ColorScheme.fromSeed(seedColor: AppColors.bgBlue)
                    .copyWith(
                      primary: AppColors.bgBlue,
                      secondary: AppColors.yellow,
                    ),
                useMaterial3: true,
                fontFamily: 'NunitoSans',
              ),
              home: const SplashScreen(),
            ),
          ),
        );
      },
    );
  }
}
