import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gymbro_web/constants/appcolors.dart';
import 'package:gymbro_web/enums/accoun_type.dart';
import 'package:gymbro_web/extensions/context_extension.dart';
import 'package:gymbro_web/services/firebase_authenticate.dart';
import 'package:gymbro_web/ui/pages/dashboard.dart';
import 'package:gymbro_web/ui/skeleton/custom_app_bar_widget.dart';
import 'package:gymbro_web/ui/skeleton/custom_side_bar_widget.dart';
import 'package:gymbro_web/ui/skeleton/screen_size.dart';
import 'package:gymbro_web/ui/skeleton/sidebar_page.dart';

import '../pages/gymbro_dashboard.dart';
import '../pages/homepage.dart';

class BasePageNavigator extends StatefulWidget {
  const BasePageNavigator({
    super.key,
    required this.size,
    this.adminType,
  });
  final ScreenSize size;
  final AccountType? adminType;

  @override
  State<BasePageNavigator> createState() => _BasePageNavigatorState();
}

class _BasePageNavigatorState extends State<BasePageNavigator> {
  final _pageController = PageController();

  List<User> userList = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  fetchUsers() async {
    //
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'GYMBRO',
        actionsA: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    auth.authSignOut();
                    context.replace(const HomePage());
                  },
                  icon: const Icon(Icons.logout))
            ],
          )
        ],
        size: widget.size,
      ),
      drawer: widget.size == ScreenSize.small
          ? Drawer(
              backgroundColor: AppColors.oliveBlack,
              child: CustomSideBarWidget(
                size: ScreenSize.small,
                onSelected: (value) {
                  _pageController.jumpToPage(value);
                },
                pageX: widget.adminType,
              ),
            )
          : null,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          //* SideBar Widget
          if (widget.size != ScreenSize.small)
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                if (widget.size == ScreenSize.large)
                  CustomSideBarWidget(
                    size: ScreenSize.large,
                    onSelected: (value) {
                      _pageController.jumpToPage(value);
                    },
                    pageX: widget.adminType,
                  ),
                if (widget.size == ScreenSize.medium)
                  CustomSideBarWidget(
                    size: ScreenSize.medium,
                    onSelected: (value) {
                      _pageController.jumpToPage(value);
                    },
                    pageX: widget.adminType,
                  ),
              ],
            ),

          //* Pages
          widget.adminType == AccountType.broAdmin
              ? Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: SidebarRootPage.values.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      const pages = SidebarRootPage.values;
                      return Navigator(
                        onGenerateRoute: (settings) {
                          return MaterialPageRoute(
                            builder: (context) {
                              switch (pages[index]) {
                                case SidebarRootPage.adminpanel:
                                  return const GymBroDashboard();
                              }
                            },
                          );
                        },
                      );
                    },
                  ),
                )
              : Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: SidebarPage.values.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      const pages = SidebarPage.values;
                      return Navigator(
                        onGenerateRoute: (settings) {
                          return MaterialPageRoute(
                            builder: (context) {
                              switch (pages[index]) {
                                case SidebarPage.dashboard:
                                  return const DashboardPage();
                              }
                            },
                          );
                        },
                      );
                    },
                  ),
                )
        ],
      ),
    );
  }
}
