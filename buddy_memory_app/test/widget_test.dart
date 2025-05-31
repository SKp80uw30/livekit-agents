// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:buddy_memory_app/main.dart';

void main() {
  testWidgets('App loads IndexScreen and shows title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the IndexScreen is loaded by checking for its AppBar title.
    // Note: This assumes IndexScreen is the initial route '/' and has an AppBar with this title.
    expect(find.text('BuddyMemory'), findsOneWidget);

    // Example: Verify a widget unique to IndexScreen is present
    // This could be the "Welcome Back, User!" text or an ActionCard title.
    // For simplicity, we'll stick to the AppBar title for now.
    // expect(find.text('Start Chatting'), findsOneWidget);
  });
}
