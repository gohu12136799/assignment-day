import 'package:assignment_day/auth/auth_controller.dart';
import 'package:assignment_day/auth/auth_scope.dart';
import 'package:assignment_day/l10n/app_localizations.dart';
import 'package:assignment_day/models/play_topic.dart';
import 'package:assignment_day/school/enrollment_store.dart';
import 'package:assignment_day/screens/school/enrollment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets(
    'greeting types out, then picking a class enrolls and goes home',
    (tester) async {
      tester.view.physicalSize = const Size(400, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final auth = AuthController();
      await auth.bootstrap(firebaseConfigured: false);
      await tester.pumpWidget(
        AuthScope(
          controller: auth,
          child: MaterialApp(
            locale: const Locale('vi'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const EnrollmentScreen(),
          ),
        ),
      );

      expect(find.text('Chọn lớp cho con'), findsNothing);

      for (var i = 0; i < 80; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      await tester.pumpAndSettle();

      expect(
        find.text('Chào mẹ, mẹ muốn đăng ký lớp nào cho con?'),
        findsNWidgets(2),
      );
      expect(find.text('Chọn lớp cho con'), findsOneWidget);

      await tester.tap(find.text('Lớp Logic'));
      await tester.pump();
      for (var i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(find.text('Tên của con'), findsOneWidget);
      expect(find.text('Ghi tên'), findsOneWidget);
      expect(find.text('Đăng nhập'), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
      expect(await EnrollmentStore().load(), isNull);

      await tester.tap(find.text('Ghi tên'));
      await tester.pump();

      await tester.tap(find.text('Đăng ký'));
      await tester.pump();
      expect(find.text('Mẹ cho cô biết tên con nhé.'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Na');
      await tester.tap(find.text('Đăng ký'));
      await tester.pump();
      for (var i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(find.text('Cô đưa Na vào Lớp Logic nhé!'), findsNWidgets(2));
      expect(
        find.image(const AssetImage('assets/images/school/teacher_lead.jpg')),
        findsOneWidget,
      );

      for (var i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(await EnrollmentStore().load(), PlayTopic.logic);
      expect(await EnrollmentStore().studentName(), 'Na');
      expect(find.text('Vào lớp'), findsOneWidget);
    },
  );
}
