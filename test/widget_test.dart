import 'package:chaturvyuha_foundation/admin/app/app.dart';
import 'package:chaturvyuha_foundation/member/UserInterface/Dashboard/dashboard_screen.dart';
import 'package:chaturvyuha_foundation/member/dataProvider/foundation_provider.dart';
import 'package:chaturvyuha_foundation/admin/presentation/shell/admin_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('admin application mounts', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const HeritageAdminApp());
    await tester.pumpAndSettle();

    expect(find.byType(AdminShell), findsOneWidget);
  });

  testWidgets('member application mounts', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1400, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => FoundationProvider(),
        child: const MaterialApp(home: DashboardScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ancient Wisdom.'), findsOneWidget);
  });
}
