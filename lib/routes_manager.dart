import 'package:flutter/material.dart';
import 'package:vertitect_app/screens/details_screen.dart';
import 'package:vertitect_app/screens/home_screen.dart';
import 'package:vertitect_app/screens/splash_screen.dart';

class Routes {
  static const String splashRoute = "/";
  static const String homeRoute = '/home';
  static const String detailsRoute = '/details';
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case Routes.detailsRoute:
        return MaterialPageRoute(builder: (_) => const DetailsScreen());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(builder: (_) => Scaffold(
      appBar: AppBar(
        title: const Text('No routes found'),
      ),
      body: const Center(
        child: Text('Invalid Route'),
      ),
    ));
  }
}
