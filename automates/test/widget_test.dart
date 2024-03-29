import 'package:automates/Screens/feedBack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Feedback form test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: FeedbackForm(),
    ));

    // Verify the presence of the form fields and submit button
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Feedback'), findsOneWidget);
    expect(find.text('Submit'), findsOneWidget);

    // Enter text into the name field
    await tester.enterText(find.byType(TextField).first, 'John Doe');
    // Enter text into the email field
    await tester.enterText(find.byType(TextField).at(1), 'john@example.com');
    // Enter text into the feedback field
    await tester.enterText(
        find.byType(TextField).last, 'This is a test feedback.');

    // Tap the submit button
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    // Verify that the feedback is printed to the console
    expect(
      tester.takeException(), // No error should be thrown
      isNull,
    );
  });
}
