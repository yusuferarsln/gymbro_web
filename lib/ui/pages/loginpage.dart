import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro_web/enums/accoun_type.dart';
import 'package:gymbro_web/provider/auth_provider.dart';
import 'package:gymbro_web/states/auth_state.dart';
import 'package:gymbro_web/ui/skeleton/base_page_navigator.dart';
import 'package:gymbro_web/ui/skeleton/responsive_wrapper.dart';
import 'package:gymbro_web/ui/skeleton/screen_size.dart';
import 'package:gymbro_web/ui/widgets/password_field.dart';
import 'package:string_validator/string_validator.dart';

import '../../provider/firebase_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final bool _submitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(firebaseProvider, (previous, next) {
      if (next is Checked<bool>) {
        final result = next.value;
        if (result == true) {
          ref.read(authProvider.notifier).fetch(_emailController.text);
        }
      }
    });
    ref.listen(authProvider, ((previous, next) {
      print(next.runtimeType);
      if (next is Checked<AccountType>) {
        final result = next.value;
        print(next.value);
        print(result);

        if (result == AccountType.broAdmin) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              if (ResponsiveWrapper.isSmall(context)) {
                return const BasePageNavigator(
                  size: ScreenSize.small,
                  adminType: AccountType.broAdmin,
                );
              } else if (ResponsiveWrapper.isMedium(context)) {
                return const BasePageNavigator(
                    size: ScreenSize.medium, adminType: AccountType.broAdmin);
              } else {
                return const BasePageNavigator(
                    size: ScreenSize.large, adminType: AccountType.broAdmin);
              }
            }),
          );
        } else if (result == AccountType.gymAdmin) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              if (ResponsiveWrapper.isSmall(context)) {
                return const BasePageNavigator(
                  size: ScreenSize.small,
                  adminType: AccountType.broAdmin,
                );
              } else if (ResponsiveWrapper.isMedium(context)) {
                return const BasePageNavigator(
                    size: ScreenSize.medium, adminType: AccountType.gymAdmin);
              } else {
                return const BasePageNavigator(
                    size: ScreenSize.large, adminType: AccountType.gymAdmin);
              }
            }),
          );
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Youre not admin')));
        }
      }
    }));

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('go')),
                  const Text(
                    'Log in',
                  ),
                  const SizedBox(height: 16),
                  const Text('Email'),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    textInputAction: TextInputAction.next,
                    onChanged: _submitted
                        ? (value) => _formKey.currentState!.validate()
                        : null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!isEmail(value)) {
                        return 'Please enter a valid email';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text('Password'),
                  const SizedBox(height: 4),
                  PasswordField(
                      controller: _passwordController,
                      onChanged: _submitted
                          ? (value) => _formKey.currentState!.validate()
                          : null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        } else {
                          return null;
                        }
                      },
                      textInputAction: TextInputAction.go,
                      onSubmitted: (value) => //signin
                          doNothing()),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          // context.go(const SignUpPage());
                        },
                        child: const Text(
                          "Don't have account?",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      ref.read(firebaseProvider.notifier).login(
                          _emailController.text, _passwordController.text);
                    },
                    child: const Text('Log in'),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void doNothing() {}
