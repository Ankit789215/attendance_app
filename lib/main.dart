import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';
// import 'core/constants/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase (Uncomment and add credentials when ready)
  // await Supabase.initialize(
  //   url: AppConstants.supabaseUrl,
  //   anonKey: AppConstants.supabaseAnonKey,
  // );

  runApp(
    const ProviderScope(
      child: AttendEaseApp(),
    ),
  );
}

class AttendEaseApp extends StatelessWidget {
  const AttendEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AttendEase',
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
