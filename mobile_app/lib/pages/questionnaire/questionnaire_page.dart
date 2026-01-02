import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/controllers/questionnaire_controller.dart';
import 'package:mobile_app/widgets/shared/back_and_home_buttons.dart';
import 'package:mobile_app/widgets/likert_scale_widget.dart';
import 'package:mobile_app/widgets/text_input_widget.dart';
import 'package:mobile_app/widgets/yes_no_widget.dart';
import 'package:mobile_app/models/question.dart';
import 'package:mobile_app/main.dart'; // To access AppColors

class QuestionnairePage extends StatelessWidget {
  final QuestionnaireController _controller;
  final String? assessmentId;

  QuestionnairePage({super.key, this.assessmentId})
      : _controller = Get.put(QuestionnaireController(assessmentId: assessmentId));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Assessment'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: const [
          BackAndHomeButtons(),
        ],
      ),
      body: Obx(() {
        if (_controller.isLoading.value && _controller.questions.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // Calculate progress percentage
        double progress = 0;
        if (_controller.questions.isNotEmpty) {
          progress = _controller.userAnswers.length / _controller.questions.length;
        }

        return Column(
          children: [
            // 1. STICKY PROGRESS BAR
            _buildProgressHeader(progress, theme),

            // 2. QUESTIONS LIST
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100), // Bottom padding for FAB
                itemCount: _controller.questions.length,
                itemBuilder: (context, index) {
                  final question = _controller.questions[index];
                  return _buildQuestionCard(question, index + 1, theme);
                },
              ),
            ),
          ],
        );
      }),
      // 3. MODERN SUBMIT BUTTON
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(() {
        final isAllAnswered = _controller.userAnswers.length == _controller.questions.length;
        
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: FloatingActionButton.extended(
              onPressed: _controller.isLoading.value ? null : _controller.submitAnswers,
              backgroundColor: isAllAnswered ? AppColors.success : theme.colorScheme.primary,
              elevation: 4,
              label: _controller.isLoading.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      isAllAnswered ? 'COMPLETE SUBMISSION' : 'SUBMIT ASSESSMENT',
                      style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
              icon: _controller.isLoading.value ? null : const Icon(Icons.check_circle_outline),
            ),
          ),
        );
      }),
    );
  }

  // Progress Header Section
  Widget _buildProgressHeader(double progress, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Survey Progress",
                style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600, fontSize: 13),
              ),
              Text(
                "${(progress * 100).toInt()}%",
                style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  // Individual Question Card
  Widget _buildQuestionCard(Question question, int index, ThemeData theme) {
    final isAnswered = _controller.userAnswers.containsKey(question.id);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isAnswered ? AppColors.success.withValues(alpha: 0.3) : Colors.transparent,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question Number Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isAnswered ? AppColors.success : theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Q$index",
                    style: TextStyle(
                      color: isAnswered ? Colors.white : theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    question.questionText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.dark,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // The actual interaction widget
            _buildAnswerWidget(question),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerWidget(Question question) {
    final currentAnswer = _controller.userAnswers[question.id];

    switch (question.type) {
      case 'likert':
        return LikertScaleWidget(
          selectedValue: currentAnswer,
          onChanged: (newValue) => _controller.answerQuestion(question.id, newValue),
        );
      case 'yes_no':
        return YesNoWidget(
          selectedValue: currentAnswer,
          onChanged: (newValue) => _controller.answerQuestion(question.id, newValue),
        );
      case 'text':
        final currentTextAnswer = currentAnswer is String ? currentAnswer : '';
        return TextInputWidget(
          initialValue: currentTextAnswer,
          onChanged: (newValue) => _controller.answerQuestion(question.id, newValue),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
