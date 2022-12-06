import 'package:flutter/material.dart';
import 'package:gymbro_web/ui/skeleton/screen_size.dart';

import '../../constants/appcolors.dart';

class CustomAppBarWidget extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBarWidget(
      {super.key, required this.title, required this.size, this.actionsA});

  final String title;
  final ScreenSize size;
  final List<Widget>? actionsA;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: getTitle,
      elevation: 0,
      actions: actionsA,
      backgroundColor: AppColors.bodyColor,
    );
  }

  Widget? get getTitle {
    switch (size) {
      case ScreenSize.small:
        return Text(title);
      case ScreenSize.medium:
      case ScreenSize.large:
        return IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.network(
                "https://gymbrofitness.com/wp-content/themes/gymbro/assets/img/bottom-logo.png",
                fit: BoxFit.fitHeight,
                height: kToolbarHeight - 20,
              ),
              const VerticalDivider(
                color: AppColors.white,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
    }
    return null;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
