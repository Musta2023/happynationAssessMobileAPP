import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/admin/controllers/admin_question_controller.dart';

import 'package:mobile_app/routes/app_pages.dart';

class AdminQuestionListPage extends StatelessWidget {
  final AdminQuestionController _controller = Get.put(AdminQuestionController());

  AdminQuestionListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Questions')),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: _controller.questions.length,
          itemBuilder: (context, index) {
            final question = _controller.questions[index];
            return ListTile(
              title: Text(question.questionText),
              subtitle: Text('Category: ${question.category} | Type: ${question.type}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch(
                    value: question.isActive,
                    onChanged: (value) => _controller.toggleQuestionStatus(question.id),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => Get.toNamed(Routes.adminQuestionEdit, arguments: question),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _controller.deleteQuestion(question.id),
                  ),
                ],
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.adminQuestionEdit),
        child: const Icon(Icons.add),
      ),
    );
  }
}
