import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/viewmodel/auth_viewmodel.dart';
import '../../subject/viewmodel/subject_viewmodel.dart';
import '../viewmodel/study_session_viewmodel.dart';

class StudySessionScreen extends StatefulWidget {
  const StudySessionScreen({super.key});

  @override
  State<StudySessionScreen> createState() =>
      _StudySessionScreenState();
}

class _StudySessionScreenState extends State<StudySessionScreen> {
  String? selectedSubject;
  String selectedType = 'Deep Work';
  String selectedDuration = '25m';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId =
      context.read<AuthViewModel>().currentUser!.id!;

      context.read<SubjectViewModel>().loadSubjects(userId);
    });
  }


  final List<String> sessionTypes = [
    'Deep Work',
    'Revision',
    'Practice',
  ];

  final List<String> durations = [
    '25m',
    '45m',
    '60m',
    '90m',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    final subjects =
        context.watch<SubjectViewModel>().subjects;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Study'),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Start a study session',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Choose what you want to focus on.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 28),

              // ---------------- SUBJECT ----------------

              Text(
                'Subject',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              if (subjects.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    'No subjects available. Add a subject first.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                )
              else
                DropdownButtonFormField<String>(
                  value: subjects.any(
                        (subject) => subject.name == selectedSubject,
                  )
                      ? selectedSubject
                      : null,
                  decoration: const InputDecoration(
                    hintText: 'Select subject',
                  ),
                  items: subjects.map((subject) {
                    return DropdownMenuItem<String>(
                      value: subject.name,
                      child: Text(subject.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSubject = value;
                    });
                  },
                ),

              const SizedBox(height: 24),

              // ---------------- SESSION TYPE ----------------

              Text(
                'Session type',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(),
                items: sessionTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    selectedType = value;
                  });
                },
              ),

              const SizedBox(height: 24),

              // ---------------- DURATION ----------------

              Text(
                'Duration',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: selectedDuration,
                decoration: const InputDecoration(),
                items: durations.map((duration) {
                  return DropdownMenuItem<String>(
                    value: duration,
                    child: Text(duration),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    selectedDuration = value;
                  });
                },
              ),

              const SizedBox(height: 36),

              // ---------------- START BUTTON ----------------

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: selectedSubject == null
                      ? null
                      : _startSession,
                  child: const Text('Start session'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startSession() {
    final durationMinutes =
    int.parse(selectedDuration.replaceAll('m', ''));

    final userId =
    context.read<AuthViewModel>().currentUser!.id!;

    context.read<StudyViewModel>().startSession(
      userId: userId,
      subject: selectedSubject!,
      sessionType: selectedType,
      durationMinutes: durationMinutes,
    );
  }
}