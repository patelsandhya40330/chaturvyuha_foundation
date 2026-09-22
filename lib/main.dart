import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'member/UserInterface/Dashboard/dashboard_screen.dart';
import 'member/dataProvider/foundation_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => FoundationProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CFoundation Staff Dashboard',
      theme: AppTheme.lightTheme,
      initialRoute: AppRouter.articles,
      onGenerateRoute: AppRouter.generateRoute,
      home: const DashboardScreen(),
    );
  }
}

class AppRouter {
  static const String articles = '/staff/articles';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => const DashboardScreen(),
      settings: settings,
    );
  }
}

class AppTheme {
  static ThemeData get lightTheme => ThemeData.light(useMaterial3: true);
}
