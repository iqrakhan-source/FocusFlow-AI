import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/viewmodel/auth_viewmodel.dart';
import '../viewmodel/study_session_viewmodel.dart';

class StudySessionScreen extends StatefulWidget {
  const StudySessionScreen({super.key});

  @override
  State<StudySessionScreen> createState() => _StudySessionScreenState();
}

class _StudySessionScreenState extends State<StudySessionScreen> {
  String selectedSubject = 'DSA';
  String selectedType = 'Deep Work';
  String selectedDuration = '45m';

  final subjects = [
    'DSA',
    'DBMS',
    'Operating Systems',
    'Computer Networks',
  ];

  final sessionTypes = [
    'Deep Work',
    'Revision',
    'Practice',
  ];

  final durations = [
    '25m',
    '45m',
    '60m',
    'Custom',
  ];

  Future<void> _selectCustomDuration() async {
    final controller = TextEditingController();

    final result = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Custom duration'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter minutes',
              suffixText: 'min',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final minutes = int.tryParse(controller.text);

                if (minutes == null || minutes <= 0) {
                  return;
                }

                Navigator.pop(context, minutes);
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (result != null) {
      setState(() {
        selectedDuration = '${result}m';
      });
    }
  }

  void _startSession() {
    final userId =
        context.read<AuthViewModel>().currentUser?.id;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User information is missing.'),
        ),
      );
      return;
    }

    final durationMinutes =
    int.parse(selectedDuration.replaceAll('m', ''));

    context.read<StudyViewModel>().startSession(
      userId: userId,
      subject: selectedSubject,
      sessionType: selectedType,
      durationMinutes: durationMinutes,
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<StudyViewModel>();

    if (viewModel.isRunning) {
      return _ActiveStudySession(
        viewModel: viewModel,
      );
    }

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New session'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SUBJECT

              Text(
                'Subject',
                style: theme.textTheme.bodyMedium,
              ),

              const SizedBox(height: 10),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: subjects.map((subject) {
                  return _SelectionChip(
                    label: subject,
                    selected: selectedSubject == subject,
                    onTap: () {
                      setState(() {
                        selectedSubject = subject;
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 34),

              // SESSION TYPE

              Text(
                'Session type',
                style: theme.textTheme.bodyMedium,
              ),

              const SizedBox(height: 10),

              Wrap(
                spacing: 8,
                children: sessionTypes.map((type) {
                  return _SelectionChip(
                    label: type,
                    selected: selectedType == type,
                    onTap: () {
                      setState(() {
                        selectedType = type;
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 34),

              // DURATION

              Text(
                'Duration',
                style: theme.textTheme.bodyMedium,
              ),

              const SizedBox(height: 10),

              Row(
                children: durations.map((duration) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _SelectionChip(
                        label: duration,
                        selected: selectedDuration == duration,
                        expanded: true,
                        onTap: () {
                          if (duration == 'Custom') {
                            _selectCustomDuration();
                          } else {
                            setState(() {
                              selectedDuration = duration;
                            });
                          }
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),

              const Spacer(),

              // START BUTTON

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _startSession,
                  child: const Text('Start session'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActiveStudySession extends StatelessWidget {
  const _ActiveStudySession({
    required this.viewModel,
  });

  final StudyViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Study session'),
        ),
      
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
               const Spacer(),
      
                Text(
                  viewModel.currentSession?.subject ?? '',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
      
                const SizedBox(height: 8),
      
                Text(
                  viewModel.currentSession?.sessionType ?? '',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
      
                const SizedBox(height: 40),
      
                Text(
                  viewModel.formattedTime,
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
      
                const SizedBox(height: 40),
      
                if (viewModel.isPaused)
                  const Text('Session paused'),
      
                const SizedBox(height: 20),
      
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        if (viewModel.isPaused) {
                          context
                              .read<StudyViewModel>()
                              .resumeSession();
                        } else {
                          context
                              .read<StudyViewModel>()
                              .pauseSession();
                        }
                      },
                      icon: Icon(
                        viewModel.isPaused
                            ? Icons.play_arrow
                            : Icons.pause,
                      ),
                      label: Text(
                        viewModel.isPaused
                            ? 'Resume'
                            : 'Pause',
                      ),
                    ),
      
                    const SizedBox(width: 12),
      
                    OutlinedButton(
                      onPressed: () {
                        context
                            .read<StudyViewModel>()
                            .stopSession();
                      },
                      child: const Text('Stop'),
                    ),
                  ],
                ),
      
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectionChip extends StatelessWidget {
  const _SelectionChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.expanded = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: selected
          ? colors.primary
          : colors.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: expanded ? double.infinity : null,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(
              color: selected
                  ? colors.onPrimary
                  : colors.onSurface,
              fontWeight: selected
                  ? FontWeight.w600
                  : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}