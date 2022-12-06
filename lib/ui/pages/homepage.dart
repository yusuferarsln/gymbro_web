import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro_web/extensions/context_extension.dart';
import 'package:gymbro_web/ui/pages/loginpage.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GymBro Admin Panel'),
        actions: [
          Row(
            children: [
              ElevatedButton(onPressed: () {}, child: const Text('Gym Login')),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    context.go(const LoginPage());
                  },
                  child: const Text('GymBro Admin'))
            ],
          )
        ],
      ),
      body: Column(
        children: const [Text('sa')],
      ),
    );
  }
}
