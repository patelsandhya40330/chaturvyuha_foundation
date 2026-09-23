import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:chaturvyuha_foundation/main.dart';
import 'package:chaturvyuha_foundation/member/dataProvider/foundation_provider.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => FoundationProvider(),
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(MyApp), findsOneWidget);
  });
}
