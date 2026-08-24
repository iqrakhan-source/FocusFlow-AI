import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/assignment_model.dart';
import '../viewmodel/assignment_viewmodel.dart';

class AssignmentsScreen extends StatelessWidget {
  const AssignmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AssignmentViewModel(),
      child: const _AssignmentsView(),
    );
  }
}

class _AssignmentsView extends StatelessWidget {
  const _AssignmentsView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AssignmentViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
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
                'Stay on top of your coursework',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 20),

              const _AddAssignmentCard(),

              const SizedBox(height: 24),

              Text(
                'Saved assignments',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              if (viewModel.assignments.isEmpty)
                const _EmptyAssignments()
              else
                ...viewModel.assignments.map(
                      (assignment) => _AssignmentTile(
                    assignment: assignment,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddAssignmentCard extends StatefulWidget {
  const _AddAssignmentCard();

  @override
  State<_AddAssignmentCard> createState() =>
      _AddAssignmentCardState();
}

class _AddAssignmentCardState
    extends State<_AddAssignmentCard> {
  final _titleController = TextEditingController();

  String? _selectedSubject;
  DateTime? _selectedDate;

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

  void _addAssignment() {
    final title = _titleController.text.trim();

    if (title.isEmpty) {
      _showMessage(
        'Please enter an assignment title.',
      );
      return;
    }

    if (_selectedSubject == null) {
      _showMessage(
        'Please select a subject.',
      );
      return;
    }

    if (_selectedDate == null) {
      _showMessage(
        'Please select a due date.',
      );
      return;
    }

    context.read<AssignmentViewModel>().addAssignment(
      title: title,
      subject: _selectedSubject!,
      dueDate: _selectedDate!,
    );

    _titleController.clear();

    setState(() {
      _selectedSubject = null;
      _selectedDate = null;
    });

    _showMessage(
      'Assignment added successfully.',
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AssignmentViewModel>();

    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surface,

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
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          const Text(
            'Assignment title',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: 'Operating Systems Lab',
              border: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(16),
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
                borderRadius:
                BorderRadius.circular(16),
              ),
            ),

            items: viewModel.subjects.map(
                  (subject) {
                return DropdownMenuItem<String>(
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
            'Due date',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          InkWell(
            onTap: _pickDate,

            borderRadius:
            BorderRadius.circular(16),

            child: InputDecorator(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(16),
                ),

                suffixIcon: const Icon(
                  Icons.calendar_today_outlined,
                ),
              ),

              child: Text(
                _selectedDate == null
                    ? 'Select due date'
                    : _formatDate(
                  _selectedDate!,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 50,

            child: FilledButton.icon(
              onPressed: _addAssignment,

              icon: const Icon(
                Icons.add,
              ),

              label: const Text(
                'Add assignment',

                style: TextStyle(
                  fontSize: 16,
                ),
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
class _EmptyAssignments extends StatelessWidget {
  const _EmptyAssignments();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surface,

        borderRadius: BorderRadius.circular(20),
      ),

      child: Text(
        'No assignments added yet.',
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _AssignmentTile extends StatelessWidget {
  final AssignmentModel assignment;

  const _AssignmentTile({
    required this.assignment,
  });

  @override
  Widget build(BuildContext context) {
    final primary =
        Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surface,

        borderRadius: BorderRadius.circular(18),
      ),

      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,

            decoration: BoxDecoration(
              color: primary.withOpacity(0.10),
              borderRadius:
              BorderRadius.circular(14),
            ),

            child: Icon(
              Icons.assignment_outlined,
              color: primary,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Text(
                  assignment.title,

                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  assignment.subject,

                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Due: ${_formatDate(assignment.dueDate)}',

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
                  .read<AssignmentViewModel>()
                  .deleteAssignment(
                assignment.id,
              );
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