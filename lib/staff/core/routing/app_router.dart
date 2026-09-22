import 'package:cfoundation/features/auth/presentation/forgot_password_screen.dart';
import 'package:cfoundation/features/auth/presentation/login_screen.dart';
import 'package:cfoundation/features/auth/presentation/signup_screen.dart';
import 'package:cfoundation/features/staff/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static const String login = '/';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  
  static const String dashboard = '/staff/dashboard';
  
  static const String articles = '/staff/articles';
  static const String articlesCreate = '/staff/articles/create';
  static const String articlesEdit = '/staff/articles/edit'; // Will append /:id
  
  static const String pages = '/staff/pages';
  static const String pagesCreate = '/staff/pages/create';
  static const String pagesEdit = '/staff/pages/edit';
  
  static const String programs = '/staff/programs';
  static const String programsCreate = '/staff/programs/create';
  static const String programsEdit = '/staff/programs/edit';
  
  static const String events = '/staff/events';
  static const String eventsCreate = '/staff/events/create';
  static const String eventsEdit = '/staff/events/edit';
  
  static const String media = '/staff/media';
  
  static const String announcements = '/staff/announcements';
  static const String announcementsCreate = '/staff/announcements/create';
  static const String announcementsEdit = '/staff/announcements/edit';
  
  static const String messages = '/staff/messages';
  static const String notifications = '/staff/notifications';
  static const String settings = '/staff/settings';
  
  static const String members = '/staff/members';
  static const String reports = '/staff/reports';
  static const String seo = '/staff/seo';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    final name = routeSettings.name ?? '';

    // Handle dynamic routes with IDs (e.g., /staff/articles/edit/123)
    if (name.startsWith('$articlesEdit/')) {
      final id = name.replaceFirst('$articlesEdit/', '');
      return _pageRoute(DashboardScreen(route: articlesEdit, id: id), routeSettings);
    }
    if (name.startsWith('$pagesEdit/')) {
      final id = name.replaceFirst('$pagesEdit/', '');
      return _pageRoute(DashboardScreen(route: pagesEdit, id: id), routeSettings);
    }
    if (name.startsWith('$programsEdit/')) {
      final id = name.replaceFirst('$programsEdit/', '');
      return _pageRoute(DashboardScreen(route: programsEdit, id: id), routeSettings);
    }
    if (name.startsWith('$eventsEdit/')) {
      final id = name.replaceFirst('$eventsEdit/', '');
      return _pageRoute(DashboardScreen(route: eventsEdit, id: id), routeSettings);
    }
    if (name.startsWith('$announcementsEdit/')) {
      final id = name.replaceFirst('$announcementsEdit/', '');
      return _pageRoute(DashboardScreen(route: announcementsEdit, id: id), routeSettings);
    }

    switch (name) {
      case login:
        return _pageRoute(const LoginScreen(), routeSettings);
      case signup:
        return _pageRoute(const SignupScreen(), routeSettings);
      case forgotPassword:
        return _pageRoute(const ForgotPasswordScreen(), routeSettings);
      
      case dashboard:
      case articles:
      case articlesCreate:
      case pages:
      case pagesCreate:
      case programs:
      case programsCreate:
      case events:
      case eventsCreate:
      case media:
      case announcements:
      case announcementsCreate:
      case messages:
      case notifications:
      case settings:
      case members:
      case reports:
      case seo:
        return _pageRoute(DashboardScreen(route: name), routeSettings);
        
      default:
        return _pageRoute(Builder(builder: (context) => _errorPage(context, name)), routeSettings);
    }
  }

  static MaterialPageRoute _pageRoute(Widget child, RouteSettings routeSettings) {
    return MaterialPageRoute(
      builder: (_) => child,
      settings: routeSettings,
    );
  }

  static Widget _errorPage(BuildContext context, String name) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.red),
            const SizedBox(height: 20),
            Text(
              '404 - Page Not Found',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('No route defined for $name'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, login),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
