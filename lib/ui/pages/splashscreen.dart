import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro_web/extensions/context_extension.dart';
import 'package:gymbro_web/provider/firebase_provider.dart';
import 'package:gymbro_web/states/auth_state.dart';
import 'package:gymbro_web/ui/pages/homepage.dart';
import 'package:gymbro_web/ui/skeleton/base_page_navigator.dart';
import 'package:gymbro_web/ui/skeleton/responsive_wrapper.dart';
import 'package:gymbro_web/ui/skeleton/screen_size.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    ref.listen(firebaseProvider, (previous, next) {
      if (previous is! Checked && next is Checked) {
        final result = next.value;
        result == true
            ? Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  if (ResponsiveWrapper.isSmall(context)) {
                    return const BasePageNavigator(size: ScreenSize.small);
                  } else if (ResponsiveWrapper.isMedium(context)) {
                    return const BasePageNavigator(size: ScreenSize.medium);
                  } else {
                    return const BasePageNavigator(size: ScreenSize.large);
                  }
                }),
              )
            : Timer(
                const Duration(seconds: 5), () => context.go(const HomePage()));
      }
    });

    return Center(
        child: Image.network(
            "https://gymbrofitness.com/wp-content/themes/gymbro/assets/img/bottom-logo.png"));
  }
}
