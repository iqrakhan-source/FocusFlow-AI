import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import '../model/subject_model.dart';
import '../viewmodel/subject_viewmodel.dart';

class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SubjectViewModel(),
      child: const _SubjectsView(),
    );
  }
}

class _SubjectsView extends StatelessWidget {
  const _SubjectsView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SubjectViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'My subjects',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Everything you're studying this term",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 20),

              _AddSubjectCard(),

              const SizedBox(height: 20),

              const Text(
                'Saved subjects',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              if (viewModel.subjects.isEmpty)
                _EmptySubjects()
              else
                ...viewModel.subjects.map(
                      (subject) => _SubjectTile(subject: subject),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddSubjectCard extends StatefulWidget {
  @override
  State<_AddSubjectCard> createState() => _AddSubjectCardState();
}

class _AddSubjectCardState extends State<_AddSubjectCard> {
  final _nameController = TextEditingController();
  final _courseController = TextEditingController();
  final _idController = TextEditingController();
  Color? _selectedColor;

  @override
  void dispose() {
    _nameController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SubjectViewModel>();
    final availableColors = viewModel.availableColors;

    // If selected color becomes unavailable,
    // clear the selection.
    if (_selectedColor != null &&
        !availableColors.any(
              (color) => color.value == _selectedColor!.value,
        )) {
      _selectedColor = null;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
            'Subject name',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Operating Systems',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'Course code (optional)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: _courseController,
            decoration: InputDecoration(
              hintText: 'CS-305',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'Choose a color',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 12),

          if (availableColors.isEmpty)
            Text(
              'All subject colors are already in use.',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            )
          else
            Wrap(
              spacing: 12,
              runSpacing: 10,
              children: availableColors.map((color) {
                final isSelected =
                    _selectedColor?.value == color.value;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? Colors.black
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 20,
                    )
                        : null,
                  ),
                );
              }).toList(),
            ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: availableColors.isEmpty
                  ? null
                  : ()async {
                await _addSubject(context);
              },
              icon: const Icon(Icons.add),
              label: const Text(
                'Add subject',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addSubject(BuildContext context) async {
    final name = _nameController.text.trim();
    final courseCode = _courseController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a subject name.'),
        ),
      );
      return;
    }

    if (_selectedColor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please choose a color.'),
        ),
      );
      return;
    }

    final authViewModel = context.read<AuthViewModel>();

    final userId = authViewModel.currentUser?.id;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not found. Please log in again.'),
        ),
      );
      return;
    }

    final viewModel = context.read<SubjectViewModel>();

    final success = await viewModel.addSubject(
      name: name,
      courseCode: courseCode,
      color: _selectedColor!,
      userId: userId,
    );

    if (!context.mounted) return;

    if (success) {
      _nameController.clear();
      _courseController.clear();

      setState(() {
        _selectedColor = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Subject added successfully.'),
        ),
      );
    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            viewModel.errorMessage ?? 'Unable to add subject.',
          ),
        ),
      );
    }
  }
}
class _EmptySubjects extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'No subjects yet — add your first one above.',
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _SubjectTile extends StatelessWidget {
  final SubjectModel subject;

  const _SubjectTile({
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(subject.colorValue);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.menu_book_rounded,
              color: color,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                if (subject.courseCode.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subject.courseCode,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ],
            ),
          ),

          IconButton(
            onPressed: () {
              context
                  .read<SubjectViewModel>()
                  .deleteSubject(subject.id!);
            },
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }
}