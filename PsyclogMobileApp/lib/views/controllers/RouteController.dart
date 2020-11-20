import 'package:flutter/material.dart';
import 'package:psyclog_app/views/controllers/RouteArguments.dart';
import 'package:psyclog_app/views/screens/ClientProfilePage.dart';
import 'package:psyclog_app/views/screens/HomePage.dart';
import 'package:psyclog_app/views/screens/LoginPage.dart';
import 'package:psyclog_app/views/screens/RegisterPage.dart';
import 'package:psyclog_app/views/screens/SessionTherapistPage.dart';
import 'package:psyclog_app/views/screens/SplashPage.dart';
import 'package:psyclog_app/views/screens/TherapistProfilePage.dart';
import 'package:psyclog_app/views/screens/TherapistRegisterPage.dart';
import 'package:psyclog_app/views/screens/ClientRegisterPage.dart';
import 'package:psyclog_app/views/screens/ClientRequestPage.dart';
import 'package:psyclog_app/views/screens/VideoCallPage.dart';
import 'package:psyclog_app/views/screens/WalletPage.dart';
import 'package:psyclog_app/views/screens/WelcomePage.dart';
import 'package:psyclog_app/views/util/ViewConstants.dart';
import 'package:psyclog_app/views/screens/ClientTherapistListPage.dart';
import 'package:psyclog_app/views/widgets/InnerDrawerWithScreen.dart';

class RouteController {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case ViewConstants.splashRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SplashPage(),
        );
        break;
      case ViewConstants.welcomeRoute:
        return PageRouteBuilder(
          settings: settings,
          transitionDuration: Duration(milliseconds: 1666),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return WelcomePage();
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            var curve = Curves.linearToEaseOut;

            var curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );

            return FadeTransition(
              opacity: curvedAnimation,
              child: child,
            );
          },
        );
        break;
      case ViewConstants.loginRoute:
        return PageRouteBuilder(
          settings: settings,
          transitionDuration: Duration(milliseconds: 800),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return LoginPage();
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
        break;
      case ViewConstants.registerRoute:
        return PageRouteBuilder(
          settings: settings,
          transitionDuration: Duration(milliseconds: 800),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return RegisterPage();
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            var curve = Curves.linearToEaseOut;

            var curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );

            return FadeTransition(
              opacity: curvedAnimation,
              child: child,
            );
          },
        );
        break;
      case ViewConstants.registerClientRoute:
        return PageRouteBuilder(
          settings: settings,
          transitionDuration: Duration(milliseconds: 800),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return ClientRegisterPage();
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            var curve = Curves.decelerate;

            var begin = Offset(1.0, 0.0);
            var end = Offset.zero;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
        break;
      case ViewConstants.registerTherapistRoute:
        return PageRouteBuilder(
          settings: settings,
          transitionDuration: Duration(milliseconds: 800),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TherapistRegisterPage();
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            var curve = Curves.decelerate;

            var begin = Offset(1.0, 0.0);
            var end = Offset.zero;
            var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
        break;
      case ViewConstants.homeRoute:
        return PageRouteBuilder(
          settings: settings,
          transitionDuration: Duration(milliseconds: 800),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return InnerDrawerWithScreen(scaffoldArea: HomePage());
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            var curve = Curves.linearToEaseOut;

            var curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );

            return FadeTransition(
              opacity: curvedAnimation,
              child: child,
            );
          },
        );
        break;
      case ViewConstants.allTherapistsRoute:

        // TODO Passing settings.arguments to pages
        // TODO Changing the structure of AllTherapistListPage to TherapistListPage

        final String pageName = settings.arguments;

        return PageRouteBuilder(
          settings: settings,
          transitionDuration: Duration(milliseconds: 800),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return ClientTherapistsListPage(pageName: pageName);
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            var curve = Curves.linear;

            var curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );

            return FadeTransition(
              opacity: curvedAnimation,
              child: child,
            );
          },
        );
        break;
      case ViewConstants.therapistRequestRoute:
        final TherapistRequestScreenArguments _args = settings.arguments;

        return PageRouteBuilder(
          settings: settings,
          transitionDuration: Duration(milliseconds: 800),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return ClientRequestPage(
                therapist: _args.therapist,
                currentUserApplied: _args.currentUserApplied);
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            var curve = Curves.linear;

            var curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );

            return FadeTransition(
              opacity: curvedAnimation,
              child: child,
            );
          },
        );
        break;
      case ViewConstants.clientProfileRoute:
        return PageRouteBuilder(
          settings: settings,
          transitionDuration: Duration(milliseconds: 800),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return InnerDrawerWithScreen(scaffoldArea: ClientProfilePage());
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            var curve = Curves.linearToEaseOut;

            var curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );

            return FadeTransition(
              opacity: curvedAnimation,
              child: child,
            );
          },
        );
        break;
      case ViewConstants.therapistProfileRoute:
        return PageRouteBuilder(
          settings: settings,
          transitionDuration: Duration(milliseconds: 800),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return InnerDrawerWithScreen(scaffoldArea: TherapistProfilePage());
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            var curve = Curves.linearToEaseOut;

            var curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );

            return FadeTransition(
              opacity: curvedAnimation,
              child: child,
            );
          },
        );
        break;
      case ViewConstants.sessionRoute:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) =>
                InnerDrawerWithScreen(scaffoldArea: SessionTherapistPage()));
        break;
      case ViewConstants.walletRoute:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => InnerDrawerWithScreen(scaffoldArea: WalletPage()));
        break;
      case ViewConstants.videoCallRoute:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) =>
                InnerDrawerWithScreen(scaffoldArea: VideoCallPage()));
        break;
      default:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
        break;
    }
  }
}