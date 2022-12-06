import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GymBroDashboard extends ConsumerStatefulWidget {
  const GymBroDashboard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GymBroDashboardState();
}

class _GymBroDashboardState extends ConsumerState<GymBroDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GYMBRO ADMIN DASHBOARD'),
      ),
    );
  }
}
