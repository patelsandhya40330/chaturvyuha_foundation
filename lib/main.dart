import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'UserInterface/Dashboard/dashboard_screen.dart';
import 'dataProvider/foundation_provider.dart';
import 'dataProvider/yoga_provider.dart';
import 'dataProvider/education_provider.dart';
import 'dataProvider/article_provider.dart';
import 'dataProvider/event_provider.dart';
import 'dataProvider/media_provider.dart';
import 'dataProvider/membership_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FoundationProvider()),
        ChangeNotifierProvider(create: (context) => YogaProvider()),
        ChangeNotifierProvider(create: (context) => EducationProvider()),
        ChangeNotifierProvider(create: (context) => ArticleProvider()),
        ChangeNotifierProvider(create: (context) => EventProvider()),
        ChangeNotifierProvider(create: (context) => MediaProvider()),
        ChangeNotifierProvider(create: (context) => MembershipProvider()),
      ],
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
      home: const DashboardScreen(),
    );
  }
}
