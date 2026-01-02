import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/controllers/admin_assessments_controller.dart';
import 'package:mobile_app/widgets/shared/back_and_home_buttons.dart';
import 'package:mobile_app/pages/admin/admin_assessment_form_page.dart';
import 'package:mobile_app/pages/admin/admin_assessment_analytics_page.dart';

class AdminAssessmentListPage extends ConsumerStatefulWidget {
  const AdminAssessmentListPage({super.key});

  @override
  ConsumerState<AdminAssessmentListPage> createState() => _AdminAssessmentListPageState();
}

class _AdminAssessmentListPageState extends ConsumerState<AdminAssessmentListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminAssessmentsProvider.notifier).fetchAssessments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminAssessmentsState = ref.watch(adminAssessmentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Assessments'),
        automaticallyImplyLeading: false,
        actions: const [
          BackAndHomeButtons(),
        ],
      ),
      body: adminAssessmentsState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : adminAssessmentsState.errorMessage != null
              ? Center(child: Text(adminAssessmentsState.errorMessage!))
              : ListView.builder(
                  itemCount: adminAssessmentsState.assessments.length,
                  itemBuilder: (context, index) {
                    final assessment = adminAssessmentsState.assessments[index];
                    return ListTile(
                      title: Text(assessment.title),
                      subtitle: Text(assessment.description ?? ''),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AdminAssessmentAnalyticsPage(assessmentId: assessment.id.toString()),
                          ),
                        );
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AdminAssessmentFormPage(assessment: assessment),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AdminAssessmentFormPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
