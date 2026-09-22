import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'UserInterface/Splash/splash_screen.dart';
import 'dataProvider/foundation_provider.dart';
import 'dataProvider/yoga_provider.dart';
import 'dataProvider/article_provider.dart';
import 'dataProvider/event_provider.dart';
import 'dataProvider/media_provider.dart';
import 'dataProvider/membership_provider.dart';

void main() {
  // Ensure Flutter engine bindings are initialized before running runApp
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FoundationProvider()),
        ChangeNotifierProvider(create: (context) => YogaProvider()),
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
      title: 'Chaturveda Foundation',
      theme: ThemeData(fontFamily: 'Georgia', useMaterial3: true),
      home: const SplashScreen(),
    );
  }
}
