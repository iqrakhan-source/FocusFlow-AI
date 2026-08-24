import 'package:flutter/material.dart';

class DailyReflectionScreen extends StatefulWidget {
  const DailyReflectionScreen({super.key});

  @override
  State<DailyReflectionScreen> createState() =>
      _DailyReflectionScreenState();
}

class _DailyReflectionScreenState extends State<DailyReflectionScreen> {
  String? selectedMood;
  int? selectedStress;
  final sleepController = TextEditingController();
  final achievementController = TextEditingController();
  final distractionController = TextEditingController();

  final moods = ['😞', '😟', '😐', '🙂', '😄'];

  @override
  void dispose() {
    sleepController.dispose();
    achievementController.dispose();
    distractionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Evening reflection'),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Two minutes tonight makes tomorrow’s plan smarter.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 28),

              // ---------------- MOOD ---------------------

              Text(
                'How was your mood?',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 14),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: moods.map((mood) {
                  final isSelected = selectedMood == mood;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedMood = mood;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colors.primary.withValues(alpha: 0.14)
                            : colors.surfaceContainerHighest,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? colors.primary
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        mood,
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 30),

              // ---------------- STRESS ----------------

              Text(
                'Stress level',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 14),

              Row(
                children: List.generate(5, (index) {
                  final value = index + 1;
                  final isSelected = selectedStress == value;

                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: index == 4 ? 0 : 8,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedStress = value;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          height: 48,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? colors.primary
                                : colors.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '$value',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isSelected
                                  ? colors.onPrimary
                                  : colors.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 30),

              // ---------------- SLEEP ----------------

              Text(
                'Sleep hours',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: sleepController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  hintText: 'e.g. 7.5',
                  suffixText: 'hours',
                ),
              ),

              const SizedBox(height: 24),

              // ---------------- ACHIEVEMENT ----------------

              Text(
                'Biggest achievement',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: achievementController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'What are you proud of today?',
                  alignLabelWithHint: true,
                ),
              ),

              const SizedBox(height: 24),

              // ---------------- DISTRACTION ----------------

              Text(
                'Biggest distraction',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: distractionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'What distracted you today?',
                  alignLabelWithHint: true,
                ),
              ),

              const SizedBox(height: 32),

              // ---------------- SAVE ----------------

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    // UI only for now.
                  },
                  child: const Text('Save reflection'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}