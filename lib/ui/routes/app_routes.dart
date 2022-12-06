import 'package:flutter/material.dart';
import 'package:gymbro_web/ui/routes/routes_string.dart';
import 'package:gymbro_web/ui/splashscreen.dart';

import '../skeleton/base_page_navigator.dart';
import '../skeleton/responsive_wrapper.dart';
import '../skeleton/screen_size.dart';

abstract class AppRoutes {
  static Map<String, Widget Function(BuildContext)> routes = {
    RouteStrings.splash: (context) {
      return const SplashScreen();
    },
    RouteStrings.adminDashboard: (context) {
      if (ResponsiveWrapper.isSmall(context)) {
        return const BasePageNavigator(size: ScreenSize.small);
      } else if (ResponsiveWrapper.isMedium(context)) {
        return const BasePageNavigator(size: ScreenSize.medium);
      } else {
        return const BasePageNavigator(size: ScreenSize.large);
      }
    },
  };
}
