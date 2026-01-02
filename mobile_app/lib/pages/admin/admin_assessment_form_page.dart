import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/controllers/admin_assessments_controller.dart';
import 'package:mobile_app/controllers/admin_questions_controller.dart'; // To select questions
import 'package:mobile_app/widgets/shared/back_and_home_buttons.dart';
import 'package:mobile_app/models/assessment.dart';
import 'package:mobile_app/models/question.dart';

class AdminAssessmentFormPage extends ConsumerStatefulWidget {
  final Assessment? assessment; // Null if creating a new assessment

  const AdminAssessmentFormPage({super.key, this.assessment});

  @override
  ConsumerState<AdminAssessmentFormPage> createState() => _AdminAssessmentFormPageState();
}

class _AdminAssessmentFormPageState extends ConsumerState<AdminAssessmentFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late List<Question> _selectedQuestions; // Keep track of selected questions

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.assessment?.title ?? '');
    _descriptionController = TextEditingController(text: widget.assessment?.description ?? '');
    _selectedQuestions = []; // Initialize empty
    
    // If editing, load selected questions
    if (widget.assessment != null) {
      // This is a simplified approach. In a real app, you might fetch questions by ID.
      // For now, we assume we can identify questions by their IDs from the full list.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final allQuestions = ref.read(adminQuestionsProvider).questions;
        _selectedQuestions = allQuestions
            .where((q) => widget.assessment!.questionIds.contains(q.id.toString()))
            .toList();
        // Force a rebuild to show selected questions
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final notifier = ref.read(adminAssessmentsProvider.notifier);
      final Map<String, dynamic> data = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'question_ids': _selectedQuestions.map((q) => q.id.toString()).toList(),
      };

      bool success;
      String message;

      if (widget.assessment == null) {
        // Create new assessment
        success = await notifier.createAssessment(data);
        message = success ? 'Assessment created successfully!' : 'Failed to create assessment.';
      } else {
        // Update existing assessment
        success = await notifier.updateAssessment(widget.assessment!.id, data);
        message = success ? 'Assessment updated successfully!' : 'Failed to update assessment.';
      }

      if (!mounted) return; // Add mounted check here

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );

      if (success) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop(); // Go back to the list
      }
    }
  }

  // Widget to select questions for the assessment
  Future<void> _selectQuestions(BuildContext context) async {
    final notifier = ref.read(adminQuestionsProvider.notifier);
    await notifier.fetchQuestions(); // Ensure questions are fetched and up-to-date
    if (!mounted) return; // Add mounted check here

    final List<Question>? result = await showDialog<List<Question>>(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (BuildContext dialogContext) {
        // Wrap with a Consumer to watch for changes in the questions provider
        return Consumer(
          builder: (context, ref, child) {
            final allQuestionsState = ref.watch(adminQuestionsProvider);
            List<Question> tempSelectedQuestions = List.from(_selectedQuestions);

            // Handle loading and error states inside the dialog
            if (allQuestionsState.isLoading) {
              return const AlertDialog(
                title: Text('Select Questions'),
                content: Center(child: CircularProgressIndicator()),
              );
            }

            if (allQuestionsState.errorMessage != null) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text(allQuestionsState.errorMessage!),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: const Text('OK'),
                  ),
                ],
              );
            }

            if (allQuestionsState.questions.isEmpty) {
              return AlertDialog(
                title: const Text('Select Questions'),
                content: const Text('No questions available.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: const Text('OK'),
                  ),
                ],
              );
            }

            // Main dialog content
            return AlertDialog(
              title: const Text('Select Questions'),
              content: SizedBox(
                width: double.maxFinite,
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: allQuestionsState.questions.length,
                      itemBuilder: (context, index) {
                        final question = allQuestionsState.questions[index];
                        final isSelected = tempSelectedQuestions.any((q) => q.id == question.id);

                        return CheckboxListTile(
                          title: Text(question.questionText),
                          subtitle: Text(question.category),
                          value: isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                tempSelectedQuestions.add(question);
                              } else {
                                tempSelectedQuestions.removeWhere((q) => q.id == question.id);
                              }
                            });
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text('Select'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(tempSelectedQuestions);
                  },
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        _selectedQuestions = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminAssessmentsState = ref.watch(adminAssessmentsProvider);
    final isSaving = adminAssessmentsState.isCreating || adminAssessmentsState.isUpdating;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.assessment == null ? 'Create New Assessment' : 'Edit Assessment'),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: const [
          BackAndHomeButtons(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Assessment Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter assessment title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              // Question Selector
              ListTile(
                title: const Text('Selected Questions'),
                subtitle: Text('${_selectedQuestions.length} question(s) selected'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _selectQuestions(context),
              ),
              // Display selected questions
              if (_selectedQuestions.isNotEmpty)
                ..._selectedQuestions.map((q) => Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
                  child: Text('- ${q.questionText} (${q.category})'),
                )),
              const SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSaving ? null : _submitForm,
                  child: isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(widget.assessment == null ? 'Create Assessment' : 'Update Assessment'),
                ),
              ),
              if (adminAssessmentsState.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    adminAssessmentsState.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
