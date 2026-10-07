import 'package:assignment_day/l10n/app_localizations.dart';
import 'package:assignment_day/screens/school/class_entry_screen.dart';
import 'package:assignment_day/school/enrollment_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('teacher asks the name, welcomes, then starts the test', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'school.enrolledClass': 'logic',
      'school.homeroom': 'nga',
    });
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('vi'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const ClassEntryScreen(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Cô Nga'), findsOneWidget);
    expect(find.text('Em tên là gì?'), findsOneWidget);
    expect(
      find.image(const AssetImage('assets/images/school/class_enter_nga.jpg')),
      findsOneWidget,
    );

    await tester.tap(find.text('Trả lời'));
    await tester.pump();
    expect(find.text('Mẹ cho cô biết tên con nhé.'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Na');
    await tester.tap(find.text('Trả lời'));
    await tester.pump();

    expect(
      find.text('Các bạn chào đón Na nhé. Cô dẫn em vào ghế.'),
      findsOneWidget,
    );
    expect(
      find.image(const AssetImage('assets/images/school/class_seat_nga.jpg')),
      findsOneWidget,
    );

    await tester.pump(const Duration(milliseconds: 2300));
    expect(find.text('Bắt đầu kiểm tra 15 phút nhé.'), findsOneWidget);
    expect(find.text('Làm bài'), findsOneWidget);
    expect(await EnrollmentStore().studentName(), 'Na');
  });
}
