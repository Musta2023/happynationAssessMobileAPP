import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/controllers/admin_questions_controller.dart';
import 'package:mobile_app/widgets/shared/back_and_home_buttons.dart';
import 'package:mobile_app/models/question.dart';
import 'package:mobile_app/widgets/shared/no_data_found_widget.dart';
import 'package:mobile_app/pages/admin/admin_question_form_page.dart'; // Import AdminQuestionFormPage

class AdminQuestionListPage extends ConsumerStatefulWidget {
  const AdminQuestionListPage({super.key});

  @override
  ConsumerState<AdminQuestionListPage> createState() => _AdminQuestionListPageState();
}

class _AdminQuestionListPageState extends ConsumerState<AdminQuestionListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminQuestionsProvider.notifier).fetchQuestions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminQuestionsState = ref.watch(adminQuestionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Questions'),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: const [
          BackAndHomeButtons(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Assessment Questions',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24.0),
            if (adminQuestionsState.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (adminQuestionsState.errorMessage != null)
              Center(
                child: Text(
                  adminQuestionsState.errorMessage!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.red),
                ),
              )
            else if (adminQuestionsState.questions.isEmpty)
              const NoDataFoundWidget(message: 'No questions found.')
            else
              Expanded(
                child: ListView.builder(
                  itemCount: adminQuestionsState.questions.length,
                  itemBuilder: (context, index) {
                    final question = adminQuestionsState.questions[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 2,
                      child: ListTile(
                        leading: Hero(
                          tag: 'question-${question.id}', // Unique tag for Hero animation
                          child: CircleAvatar(
                            child: Text(question.id.toString()),
                          ),
                        ),
                        title: Text(question.questionText),
                        subtitle: Text(question.category),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => AdminQuestionFormPage(question: question),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: adminQuestionsState.isDeleting
                                  ? null
                                  : () => _confirmDelete(context, question),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AdminQuestionFormPage(),
            ),
          );
        },
        label: const Text('Add Question'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Question question) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete question "${question.questionText}"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      // ignore: use_build_context_synchronously
      final bool success = await ref.read(adminQuestionsProvider.notifier).deleteQuestion(question.id.toString());
      if (success) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Question "${question.questionText}" deleted successfully!')),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ref.read(adminQuestionsProvider).errorMessage ?? 'Failed to delete question.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
