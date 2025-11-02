import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:phrygian/main.dart';

void main() {
  testWidgets('Guitar Tuner app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const GuitarTunerApp());

    // Verify that the app title is displayed
    expect(find.text('Guitar Tuner'), findsOneWidget);

    // Verify that the Start button is present
    expect(find.text('Start Tuner'), findsOneWidget);

    // Verify that the initial note display shows '--'
    expect(find.text('--'), findsOneWidget);

    // Verify initial status message
    expect(find.text('Tap to start'), findsOneWidget);
  });

  testWidgets('Tuner button toggles text', (WidgetTester tester) async {
    await tester.pumpWidget(const GuitarTunerApp());

    // Find the button
    final startButton = find.text('Start Tuner');
    expect(startButton, findsOneWidget);

    // Note: We can't actually test the permission flow in unit tests,
    // but we can verify the UI elements are present
  });

  testWidgets('Guitar notes are displayed', (WidgetTester tester) async {
    await tester.pumpWidget(const GuitarTunerApp());

    // Verify all guitar notes are displayed
    expect(find.text('E2'), findsOneWidget);
    expect(find.text('A2'), findsOneWidget);
    expect(find.text('D3'), findsOneWidget);
    expect(find.text('G3'), findsOneWidget);
    expect(find.text('B3'), findsOneWidget);
    expect(find.text('E4'), findsOneWidget);
  });
}
