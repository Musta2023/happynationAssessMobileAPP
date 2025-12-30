import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/controllers/questionnaire_controller.dart';
import 'package:mobile_app/widgets/likert_scale_widget.dart';
import 'package:mobile_app/widgets/text_input_widget.dart';
import 'package:mobile_app/widgets/yes_no_widget.dart';
import 'package:mobile_app/models/question.dart';

/// The main page for the user to answer questionnaire questions.
///
/// FIXED: Corrected method call from `setAnswer` to `answerQuestion` and
/// updated widget parameters for `YesNoWidget` to use `selectedValue` and `onChanged`.
class QuestionnairePage extends StatelessWidget {
  final QuestionnaireController _controller;
  final String? assessmentId;

  QuestionnairePage({super.key, this.assessmentId})
      : _controller = Get.put(QuestionnaireController(assessmentId: assessmentId));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (_controller.isLoading.value && _controller.questions.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _controller.questions.length,
          itemBuilder: (context, index) {
            final question = _controller.questions[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(question.questionText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _buildAnswerWidget(question),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: Obx(() => _controller.isLoading.value
          ? const FloatingActionButton(onPressed: null, child: CircularProgressIndicator())
          : FloatingActionButton.extended(
              onPressed: _controller.submitAnswers,
              label: const Text('Submit'),
              icon: const Icon(Icons.send),
            )),
    );
  }

  Widget _buildAnswerWidget(Question question) {
    // Get the current answer for this question to pass to the child widget.
    final currentAnswer = _controller.userAnswers[question.id];

    switch (question.type) {
      case 'likert':
        // Assuming LikertScaleWidget also needs current value and a callback.
        return LikertScaleWidget(
          selectedValue: currentAnswer,
          onChanged: (newValue) {
            _controller.answerQuestion(question.id, newValue);
          },
        );
      case 'yes_no':
        return YesNoWidget(
          selectedValue: currentAnswer,
          onChanged: (newValue) {
            _controller.answerQuestion(question.id, newValue);
          },
        );
      case 'text':
        // Get the current answer for this question and ensure it's a String
        final currentTextAnswer = currentAnswer is String ? currentAnswer : '';
        return TextInputWidget(
          initialValue: currentTextAnswer,
          onChanged: (newValue) {
            _controller.answerQuestion(question.id, newValue);
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
