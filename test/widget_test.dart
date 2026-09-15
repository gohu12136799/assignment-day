import 'package:flutter_test/flutter_test.dart';

import 'package:assignment_day/main.dart';

void main() {
  testWidgets('Splash then Home in Vietnamese', (WidgetTester tester) async {
    await tester.pumpWidget(const AssignmentDayApp());

    expect(find.text('Đang tải...'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Bắt đầu chơi'), findsOneWidget);
    expect(find.text('EN'), findsOneWidget);
  });
}
