import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/routers/app_routes.dart';
import '../../../shared/widgets/App_button.dart';
import '../../../shared/widgets/App_textfield.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() =>
      _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _courseController = TextEditingController();
  final _universityController = TextEditingController();

  int? _selectedSemester;

  final List<int> _semesters = List.generate(
    8,
        (index) => index + 1,
  );

  @override
  void dispose() {
    _courseController.dispose();
    _universityController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final course = _courseController.text.trim();
    final university = _universityController.text.trim();

    if (course.isEmpty ||
        university.isEmpty ||
        _selectedSemester == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all fields.'),
        ),
      );

      return;
    }

    final auth = context.read<AuthViewModel>();

    final success = await auth.updateProfile(
      course: course,
      semester: _selectedSemester!,
      university: university,
    );

    if (!mounted) return;

    if (success) {
      context.go(AppRoutes.dashboard);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            auth.errorMessage ??
                'Unable to save your profile.',
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
      appBar: AppBar(
        title: const Text('Complete your profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            24,
            24,
            24,
            32,
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'Tell us about yourself',
                style: theme.textTheme.headlineMedium
                    ?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'This helps FocusFlow personalize your study experience.',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 32),

              Text(
                'Course',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 6),

              AppTextField(
                controller: _courseController,
                hintText: 'MCA',
                textInputAction:
                TextInputAction.next,
              ),

              const SizedBox(height: 20),

              Text(
                'Semester',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 6),

              DropdownButtonFormField<int>(
                value: _selectedSemester,
                decoration:
                const InputDecoration(
                  hintText: 'Select semester',
                  border: OutlineInputBorder(),
                ),
                items: _semesters.map((semester) {
                  return DropdownMenuItem<int>(
                    value: semester,
                    child: Text(
                      'Semester $semester',
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSemester = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              Text(
                'University',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 6),

              AppTextField(
                controller:
                _universityController,
                hintText: 'Your university',
                textInputAction:
                TextInputAction.done,
              ),

              const SizedBox(height: 32),

              AppButton(
                text: 'Save and continue',
                onPressed: _saveProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}