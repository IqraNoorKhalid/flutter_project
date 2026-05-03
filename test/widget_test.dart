import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_cart/app.dart';

void main() {
  testWidgets('SmartCartApp builds', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: SmartCartApp(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
