import 'package:flutter/material.dart';

enum SidebarPage {
  request,
  maindashboard;

  String get title {
    switch (this) {
      case request:
        return 'Request';
      case maindashboard:
        return 'Main Dashboard';
    }
  }

  IconData get icon {
    switch (this) {
      case request:
        return Icons.people;
      case maindashboard:
        return Icons.dashboard;
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
