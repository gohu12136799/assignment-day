import 'package:assignment_day/auth/auth_controller.dart';
import 'package:assignment_day/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Splash then Home in Vietnamese', (WidgetTester tester) async {
    final auth = AuthController();
    await auth.bootstrap(firebaseConfigured: false);

    await tester.pumpWidget(AssignmentDayApp(authController: auth));

    expect(find.text('Đang tải...'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Bắt đầu chơi'), findsOneWidget);
    expect(find.byIcon(Icons.settings_rounded), findsOneWidget);
  });
}
