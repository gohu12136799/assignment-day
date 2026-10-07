import 'package:assignment_day/auth/auth_controller.dart';
import 'package:assignment_day/auth/auth_scope.dart';
import 'package:assignment_day/l10n/app_localizations.dart';
import 'package:assignment_day/school/school_class.dart';
import 'package:assignment_day/screens/school/classroom_screen.dart';
import 'package:assignment_day/screens/school/punish_intro_screen.dart';
import 'package:assignment_day/screens/school/teacher_verdict_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _finishPunishLine(WidgetTester tester) async {
  await tester.pump();
  for (var i = 0; i < 40; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

Future<Widget> _app(Widget home) async {
  final auth = AuthController();
  await auth.bootstrap(firebaseConfigured: false);
  return AuthScope(
    controller: auth,
    child: MaterialApp(
      locale: const Locale('vi'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    ),
  );
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('check in during school hours unlocks the test', (tester) async {
    SharedPreferences.setMockInitialValues({'school.studentName': 'Na'});
    await tester.pumpWidget(
      await _app(
        ClassroomScreen(
          schoolClass: schoolClasses.first,
          clock: () => DateTime(2026, 10, 8, 9),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sĩ số 5/5'), findsOneWidget);
    expect(find.text('Na (bạn)'), findsOneWidget);
    await tester.tap(find.text('Điểm danh'));
    await tester.pumpAndSettle();

    expect(find.text('Làm bài kiểm tra'), findsOneWidget);
    expect(find.text('Có mặt 09:00'), findsOneWidget);
    expect(find.text('Đi học đều, em được tặng 1 cái kẹo!'), findsOneWidget);
  });

  testWidgets('check in works late at night', (tester) async {
    await tester.pumpWidget(
      await _app(
        ClassroomScreen(
          schoolClass: schoolClasses.first,
          clock: () => DateTime(2026, 10, 8, 23, 30),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ngoài giờ học'), findsNothing);
    expect(find.text('Điểm danh'), findsOneWidget);
  });

  testWidgets('verdict pages pick the right teacher scene', (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    for (final (grade, title) in [
      (3.0, 'Ối! Bị cô khẽ tay rồi!'),
      (7.0, 'Khá lắm, cố thêm chút nữa!'),
      (10.0, 'Giỏi quá! Cô khen con!'),
    ]) {
      await tester.pumpWidget(
        await _app(
          TeacherVerdictScreen(schoolClass: schoolClasses.first, grade: grade),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(title), findsOneWidget);
    }
  });

  testWidgets('a failing score shows the result before punishment', (
    tester,
  ) async {
    await tester.pumpWidget(
      await _app(
        const PunishIntroScreen(
          studentName: 'HiHi',
          grade: 2,
          next: SizedBox.shrink(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Bạn HiHi được 2 điểm'), findsOneWidget);
    expect(find.text('Đi tới mục phạt'), findsOneWidget);
  });

  testWidgets('a low score shows the ruler and a reaction', (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      await _app(
        TeacherVerdictScreen(
          schoolClass: schoolClasses.first,
          grade: 3,
          teacherMale: true,
          day: DateTime(2026, 10, 8),
        ),
      ),
    );
    await _finishPunishLine(tester);

    expect(find.text('Thầy phạt em 5 roi.'), findsOneWidget);
    expect(
      find.image(const AssetImage('assets/images/school/teacher_ruler.jpg')),
      findsOneWidget,
    );
    expect(find.text('Chọc thầy'), findsOneWidget);
    expect(find.text('Lì lợm'), findsOneWidget);

    await tester.tap(find.text('Sợ hãi'));
    await tester.pumpAndSettle();

    expect(
      find.image(const AssetImage('assets/images/school/punish_scared.jpg')),
      findsOneWidget,
    );
    expect(
      find.text('Thầy chỉ khẽ tay nhẹ thôi. Lần sau học thuộc là không sao.'),
      findsOneWidget,
    );
  });

  testWidgets('enter on a tease line shows the angry teacher', (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      await _app(
        TeacherVerdictScreen(
          schoolClass: schoolClasses.first,
          grade: 3,
          teacherMale: false,
          day: DateTime(2026, 10, 8),
        ),
      ),
    );
    await _finishPunishLine(tester);

    await tester.tap(find.text('Chọc cô'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'cô dễ thương');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(
      find.image(const AssetImage('assets/images/school/punish_tease.jpg')),
      findsOneWidget,
    );
    expect(find.textContaining('cô dễ thương'), findsOneWidget);
  });
}
