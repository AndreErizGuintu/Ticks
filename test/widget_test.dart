// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:olgamesstore/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App builds smoke test', (WidgetTester tester) async {
    await Hive.initFlutter();
    await Hive.openBox('auth');

    await tester.pumpWidget(const ConcertApp());
    await tester.pump();

    // Basic sanity check: app renders something.
    expect(find.byType(ConcertApp), findsOneWidget);
  });
}
