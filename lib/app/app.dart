import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../presentation/shell/admin_shell.dart';

class HeritageAdminApp extends StatelessWidget {
  const HeritageAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Heritage Admin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AdminShell(),
    );
  }
}
