import 'package:assignment_day/auth/auth_controller.dart';
import 'package:assignment_day/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Splash then Home in Vietnamese when already enrolled', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'school.enrolledClass': 'math',
      'school.studentName': 'Na',
    });
    final auth = AuthController();
    await auth.bootstrap(firebaseConfigured: false);

    await tester.pumpWidget(AssignmentDayApp(authController: auth));

    expect(find.text('Đang tải...'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    await tester.pump();

    expect(find.text('Na'), findsOneWidget);
    expect(find.text('Lớp 5'), findsOneWidget);
    expect(find.text('Vào lớp'), findsOneWidget);
    expect(find.text('Người chơi'), findsNothing);
    expect(find.byIcon(Icons.settings_rounded), findsOneWidget);

    await tester.tap(find.byType(CircleAvatar));
    await tester.pump();

    expect(find.byType(Dialog), findsOneWidget);
    expect(find.text('Na'), findsNWidgets(2));
  });
}
