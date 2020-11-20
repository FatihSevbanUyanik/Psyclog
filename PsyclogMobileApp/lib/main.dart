import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psyclog_app/views/util/ViewConstants.dart';
import 'package:psyclog_app/views/controllers/RouteController.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: ViewConstants.appName,
      theme: isDark ? ViewConstants.darkTheme : ViewConstants.lightTheme,
      initialRoute: ViewConstants.splashRoute,
      onGenerateRoute: RouteController.generateRoutes,
    );
  }
}
