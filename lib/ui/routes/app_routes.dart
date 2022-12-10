import 'package:flutter/material.dart';
import 'package:gymbro_web/ui/pages/homepage.dart';
import 'package:gymbro_web/ui/routes/routes_string.dart';

import '../skeleton/base_page_navigator.dart';
import '../skeleton/responsive_wrapper.dart';
import '../skeleton/screen_size.dart';

abstract class AppRoutes {
  static Map<String, Widget Function(BuildContext)> routes = {
    RouteStrings.homePage: (context) {
      return const HomePage();
    },
    RouteStrings.adminDashboard: (context) {
      if (ResponsiveWrapper.isMedium(context)) {
        return const BasePageNavigator(size: ScreenSize.medium);
      } else {
        return const BasePageNavigator(size: ScreenSize.large);
      }
    },
    RouteStrings.requestPage: (context) {
      if (ResponsiveWrapper.isMedium(context)) {
        return const BasePageNavigator(size: ScreenSize.medium);
      } else {
        return const BasePageNavigator(size: ScreenSize.large);
      }
    },
    RouteStrings.mainDashboard: (context) {
      if (ResponsiveWrapper.isMedium(context)) {
        return const BasePageNavigator(size: ScreenSize.medium);
      } else {
        return const BasePageNavigator(size: ScreenSize.large);
      }
    }
  };
}
