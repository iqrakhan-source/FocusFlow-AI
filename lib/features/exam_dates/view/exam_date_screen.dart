import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import '../model/exam_model.dart';
import '../viewmodel/exam_viewmodel.dart';

class ExamDatesScreen extends StatelessWidget {
  const ExamDatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExamViewModel(),
      child: const _ExamDatesView(),
    );
  }
}

class _ExamDatesView extends StatelessWidget {
  const _ExamDatesView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ExamViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam dates'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            8,
            20,
            32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add every paper so we can plan backwards',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 20),

              const _AddExamCard(),

              const SizedBox(height: 24),

              Text(
                'Upcoming exams',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              if (viewModel.exams.isEmpty)
                const _EmptyExams()
              else
                ...viewModel.exams.map(
                      (exam) => _ExamTile(exam: exam),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddExamCard extends StatefulWidget {
  const _AddExamCard();

  @override
  State<_AddExamCard> createState() => _AddExamCardState();
}

class _AddExamCardState extends State<_AddExamCard> {
  final _titleController = TextEditingController();

  String? _selectedSubject;
  DateTime? _selectedDate;

  // Temporary subjects for UI development.
  // Later these will come from SQLite.
  final List<String> _subjects = [
    'Data Structures',
    'Operating Systems',
    'Flutter',
    'Data Science',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _addExam() async {
    final title = _titleController.text.trim();

    if (title.isEmpty) {
      _showMessage('Please enter an exam title.');
      return;
    }

    if (_selectedSubject == null) {
      _showMessage('Please select a subject.');
      return;
    }

    if (_selectedDate == null) {
      _showMessage('Please select an exam date.');
      return;
    }

    final userId =
        context.read<AuthViewModel>().currentUser?.id;

    if (userId == null) {
      _showMessage('User information is missing.');
      return;
    }

    await context.read<ExamViewModel>().addExam(
      title: title,
      subject: _selectedSubject!,
      examDate: _selectedDate!,
      userId: userId,
    );

    _titleController.clear();

    setState(() {
      _selectedSubject = null;
      _selectedDate = null;
    });

    _showMessage('Exam added successfully.');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Exam title',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: 'Mid-Sem: Data Structures',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'Subject',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          DropdownButtonFormField<String>(
            value: _selectedSubject,
            decoration: InputDecoration(
              hintText: 'Select subject',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            items: _subjects.map(
                  (subject) {
                return DropdownMenuItem(
                  value: subject,
                  child: Text(subject),
                );
              },
            ).toList(),
            onChanged: (value) {
              setState(() {
                _selectedSubject = value;
              });
            },
          ),

          const SizedBox(height: 16),

          const Text(
            'Exam date',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          InkWell(
            onTap: _pickDate,
            borderRadius: BorderRadius.circular(16),
            child: InputDecorator(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                suffixIcon: const Icon(
                  Icons.calendar_today_outlined,
                ),
              ),
              child: Text(
                _selectedDate == null
                    ? 'Select date'
                    : _formatDate(_selectedDate!),
              ),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton.icon(
              onPressed: _addExam,
              icon: const Icon(Icons.add),
              label: const Text(
                'Add exam',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.year}';
  }
}

class _EmptyExams extends StatelessWidget {
  const _EmptyExams();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'No exams added yet.',
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _ExamTile extends StatelessWidget {
  final ExamModel exam;

  const _ExamTile({
    required this.exam,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primary
                  .withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.school_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exam.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  exam.subject,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  _formatDate(exam.examDate),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {
              context
                  .read<ExamViewModel>()
                  .deleteExam(exam.id!);
            },
            icon: const Icon(
              Icons.delete_outline,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.year}';
  }
}