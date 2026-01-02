import 'package:flutter/material.dart';
import 'package:mobile_app/widgets/shared/back_and_home_buttons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:mobile_app/models/response_history.dart';

/// A page to display the details of a user's past response.
///
/// FIXED: Imported `intl` package to resolve `DateFormat` error.
class HistoryDetailPage extends StatelessWidget {
  final ResponseDetail history;

  const HistoryDetailPage({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History Details'),
        automaticallyImplyLeading: false,
        actions: const [
          BackAndHomeButtons(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // Use DateFormat to format the date
              'Submitted on: ${DateFormat.yMMMd().add_jm().format(history.submittedAt)}',
              style: Get.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            const Divider(),
            ...history.answers.map((answer) => ListTile(
                  title: Text(answer.question.questionText),
                  subtitle: Text('Your answer: ${answer.answerValue}'),
                )),
          ],
        ),
      ),
    );
  }
}