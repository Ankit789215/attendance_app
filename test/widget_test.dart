import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendance_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: AttendEaseApp()));

    // Verify that the login screen placeholder text is present.
    expect(find.text('Login Screen'), findsOneWidget);
  });
}
