import 'package:flutter/material.dart';
import 'package:sign_my_name/UI/home_page.dart';
import 'package:sign_my_name/UI/identify_page.dart';

Map<String, Widget Function(BuildContext)> get appRoutes {
  return {
    '/': (context) => const HomeScreen(),
    '/identify': (context) => const IdentifyPage(),
  };
}
