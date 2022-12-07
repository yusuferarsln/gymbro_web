import 'package:flutter/material.dart';

enum SidebarPage {
  dashboard;

  String get title {
    switch (this) {
      case dashboard:
        return 'Dashboard';
    }
  }

  IconData get icon {
    switch (this) {
      case dashboard:
        return Icons.dashboard_rounded;
    }
  }
}

enum SidebarRootPage {
  adminpanel;

  String get title {
    switch (this) {
      case adminpanel:
        return 'Admin Panel';
    }
  }

  IconData get icon {
    switch (this) {
      case adminpanel:
        return Icons.admin_panel_settings;
    }
  }
}
