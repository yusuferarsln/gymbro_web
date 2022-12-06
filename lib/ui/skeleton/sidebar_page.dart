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
