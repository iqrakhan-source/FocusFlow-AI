import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/routers/app_routes.dart';
import '../../../shared/widgets/App_button.dart';
import '../../../shared/widgets/App_pasword.dart';
import '../../../shared/widgets/App_textfield.dart';
import '../../../shared/widgets/Social_button.dart';
import '../viewmodel/auth_viewmodel.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  const _LoginView();
  }
}


class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final emailRegex = RegExp(
    r'^[\w\.-]+@[\w\.-]+\.\w+$',
  );



  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

    Future<void> _signIn() async {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter your email and password.'),
          ),
        );

        return;
      }
      if (!emailRegex.hasMatch(email)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid email address.'),
          ),
        );
        return;
      }

      final auth = context.read<AuthViewModel>();

      final success = await auth.login(
        email: email,
        password: password,
      );

      if (!mounted) return;

      if (success) {
        context.go(AppRoutes.dashboard);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              auth.errorMessage ?? 'Login failed.',
            ),
          ),
        );
      }
    }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Container(
                width: MediaQuery.sizeOf(context).width * 0.10,
                height: MediaQuery.sizeOf(context).height * 0.10,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/images/star.png',
                    color: theme.cardColor,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Welcome back',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                'Sign in to keep your study rhythm going.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 34),

              Text(
                'Email',
                style: theme.textTheme.bodyMedium,
              ),

              const SizedBox(height: 6),

              AppTextField(
                controller: _emailController,
                hintText: 'you@university.edu',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 18),

              Text(
                'Password',
                style: theme.textTheme.bodyMedium,
              ),

              const SizedBox(height: 6),

              AppPasswordField(
                controller: _passwordController,
                hintText: 'Enter your password',
                textInputAction: TextInputAction.done,
              ),

              const SizedBox(height: 8),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    context.push(AppRoutes.forgotPassword);
                  },
                  child: const Text('Forgot password?'),
                ),
              ),

              const SizedBox(height: 8),

              AppButton(
                text: 'Sign in',
                onPressed: _signIn,
              ),

              const SizedBox(height: 28),

              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: colors.outlineVariant,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'or',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: colors.outlineVariant,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              SocialButton(
                text: 'Continue with Google',
                iconPath: 'assets/images/star.png',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Google sign-in coming soon'),
                    ),
                  );
                },
              ),

              const SizedBox(height: 28),

              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Text(
                      'New to FocusFlow? ',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.push(AppRoutes.signup);
                      },
                      child: Text(
                        'Create account',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}