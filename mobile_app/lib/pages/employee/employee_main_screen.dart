import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/controllers/employee_main_controller.dart';
import 'package:mobile_app/pages/employee/history_page.dart';
import 'package:mobile_app/pages/employee/profile_page.dart';
import 'package:mobile_app/pages/employee/employee_assessments_page.dart'; // Import the new page

class EmployeeMainScreen extends StatelessWidget {
  final EmployeeMainController controller = Get.put(EmployeeMainController());

  EmployeeMainScreen({super.key});

  final List<String> _pageTitles = const [
    'Assessments', // Changed from 'Well-being Questionnaire'
    'My Results History',
    'My Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            title: Text(_pageTitles[controller.selectedIndex.value]),
          ),
          body: IndexedStack(
            index: controller.selectedIndex.value,
            children: [
              EmployeeAssessmentsPage(), // Changed from QuestionnairePage()
              const HistoryPage(),
              const ProfilePage(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.quiz),
                label: 'Assessments', // Changed from 'Questionnaire'
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'My Results',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: controller.selectedIndex.value,
            selectedItemColor: Colors.blueAccent,
            onTap: controller.changePage,
          ),
        ));
  }
}
