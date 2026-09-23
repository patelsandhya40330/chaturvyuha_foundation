class AppConstants {
  // Centralized Responsive Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1100;

  static bool isMobile(double width) => width < mobileBreakpoint;
  static bool isTablet(double width) =>
      width >= mobileBreakpoint && width < desktopBreakpoint;
  static bool isDesktop(double width) => width >= desktopBreakpoint;

  static const List<String> navigationItems = [
    "Home",
    "About",
    "Yoga & Meditation",
    "Dharma & Sanskriti",
    "Events & Programs",
    "Articles",
    "Media",
    "My Bookings",
    "Contact",
    "Become a Member",
  ];
}
