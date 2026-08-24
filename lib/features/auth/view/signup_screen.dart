import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/routers/app_routes.dart';
import '../../../shared/widgets/App_button.dart';
import '../../../shared/widgets/App_pasword.dart';
import '../../../shared/widgets/App_textfield.dart';
import '../viewmodel/auth_viewmodel.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  const _SignupView();
  }
}

class _SignupView extends StatefulWidget {
  const _SignupView({super.key});

  @override
  State<_SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<_SignupView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final emailRegex = RegExp(
    r'^[\w\.-]+@[\w\.-]+\.\w+$',
  );

  final passwordRegex = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',  );

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

    Future<void> _continue() async {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      final confirmPassword =
          _confirmPasswordController.text;

      if (name.isEmpty ||
          email.isEmpty ||
          password.isEmpty ||
          confirmPassword.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in all fields.'),
          ),
        );

        return;
      }

      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match.'),
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

      if (!passwordRegex.hasMatch(password)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Password must contain 8+ characters, uppercase, lowercase, number and special character.',
            ),
          ),
        );
        return;
      }

      final auth = context.read<AuthViewModel>();

      final success = await auth.signup(
        name: name,
        email: email,
        password: password,
      );

      if (!mounted) return;

      if (success) {
        context.go(AppRoutes.profileSetup);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              auth.errorMessage ?? 'Unable to create account.',
            ),
          ),
        );
      }
    }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 42, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create your account',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                "A few details and you're ready to study smarter.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 34),

              Text(
                'Full name',
                style: theme.textTheme.bodyMedium,
              ),

              const SizedBox(height: 6),

              AppTextField(
                controller: _nameController,
                hintText: 'Ananya Sharma',
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 18),

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
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 18),

              Text(
                'Confirm password',
                style: theme.textTheme.bodyMedium,
              ),

              const SizedBox(height: 6),

              AppPasswordField(
                controller: _confirmPasswordController,
                hintText: 'Confirm your password',
                textInputAction: TextInputAction.done,
              ),

              const SizedBox(height: 18),

              AppButton(
                text: 'Continue',
                onPressed: _continue,
              ),

              const SizedBox(height: 28),

              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.go(AppRoutes.login);
                      },
                      child: Text(
                        'Sign in',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
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