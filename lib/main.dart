import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:thirdai/core/routes/auth_route_observer.dart';

import 'core/routes/app_router.dart';
import 'core/routes/route_names.dart';
import 'core/utils/thems/app_theme.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          initialRoute: RouteNames.splash,
          onGenerateRoute: AppRouter.generateRoute,
          navigatorObservers: [AuthRouteObserver()],
        );
      },
    );
  }
}
