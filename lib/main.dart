import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'UserInterface/Dashboard/dashboard_screen.dart';
import 'dataProvider/foundation_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FoundationProvider(),
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
      home: DashboardScreen(),
    );
  }
}
