import 'package:flutter/material.dart';
import 'package:gymbro_web/ui/skeleton/screen_size.dart';

class ResponsiveWrapper extends StatelessWidget {
  const ResponsiveWrapper({
    super.key,
    this.small,
    this.medium,
    required this.large,
  });

  final Widget? small;
  final Widget? medium;
  final Widget large;

  static bool isSmall(BuildContext context) =>
      MediaQuery.of(context).size.width < ScreenSize.medium.width;

  static bool isMedium(BuildContext context) =>
      MediaQuery.of(context).size.width < ScreenSize.large.width &&
      MediaQuery.of(context).size.width >= ScreenSize.medium.width;

  static bool isLarge(BuildContext context) =>
      MediaQuery.of(context).size.width >= ScreenSize.large.width;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        final constraintWidth = constraint.maxWidth;
        if (constraintWidth >= ScreenSize.large.width) {
          return large;
        } else if (constraintWidth >= ScreenSize.medium.width &&
            constraintWidth < ScreenSize.large.width) {
          return medium ?? large;
        } else {
          return small ?? large;
        }
      },
    );
  }
}
