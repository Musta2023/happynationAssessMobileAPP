// lib/screens/admin/admin_question_form_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/controllers/admin_questions_controller.dart';
import 'package:mobile_app/widgets/shared/back_and_home_buttons.dart';
import 'package:mobile_app/models/question.dart';

class AppColors {
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color background = Color(0xFFF8FAFC); // Slate 50
  static const Color surface = Colors.white;
  static const Color textMain = Color(0xFF0F172A); // Slate 900
  static const Color textSubtle = Color(0xFF64748B); // Slate 500
  static const Color border = Color(0xFFE2E8F0); // Slate 200
  static const Color danger = Color(0xFFF43F5E); // Rose
  static const Color success = Color(0xFF10B981); // Emerald
}

class AdminQuestionFormPage extends ConsumerStatefulWidget {
  final Question? question;

  const AdminQuestionFormPage({super.key, this.question});

  @override
  ConsumerState<AdminQuestionFormPage> createState() => _AdminQuestionFormPageState();
}

class _AdminQuestionFormPageState extends ConsumerState<AdminQuestionFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _questionTextController;
  late String _selectedCategory;
  late String _selectedType;
  late bool _isActive;

  final List<String> _categories = ['stress', 'motivation', 'satisfaction'];
  final List<String> _types = ['likert', 'yes_no', 'text'];

  @override
  void initState() {
    super.initState();
    _questionTextController = TextEditingController(text: widget.question?.questionText ?? '');
    _selectedCategory = widget.question?.category ?? _categories.first;
    _selectedType = widget.question?.type ?? _types.first;
    _isActive = widget.question?.isActive ?? true;
  }

  @override
  void dispose() {
    _questionTextController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {

    if (_formKey.currentState!.validate()) {

      final notifier = ref.read(adminQuestionsProvider.notifier);
      final Map<String, dynamic> data = {
        'question_text': _questionTextController.text,
        'category': _selectedCategory,
        'type': _selectedType,
        'is_active': _isActive ? 1 : 0,
      };

      bool success;
      final bool isCreating = widget.question == null;

      if (isCreating) {

        success = await notifier.createQuestion(data);
      } else {

        success = await notifier.updateQuestion(widget.question!.id.toString(), data);
      }
      


      if (!mounted) return;

      String message;
      if (success) {
        message = isCreating ? 'Question published successfully' : 'Question updated successfully';
      } else {
        message = ref.read(adminQuestionsProvider).errorMessage ?? 'An unknown error occurred.';
      }
      


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: success ? AppColors.textMain : AppColors.danger,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );

      if (success) {
        Navigator.of(context).pop();
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminQuestionsProvider);
    final isSaving = state.isCreating || state.isUpdating;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: _buildBody(context, isSaving, state),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 1,
      automaticallyImplyLeading: false,
      actions: const [
        BackAndHomeButtons(),
      ],
      title: Text(
        widget.question == null ? 'New Question' : 'Edit Question',
        style: const TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: AppColors.border, height: 1),
      ),
    );
  }

  Widget _buildBody(BuildContext context, bool isSaving, AdminQuestionsState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFormHeader(),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Content'),
                  const SizedBox(height: 16),
                  _buildQuestionTextField(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Classification'),
                  const SizedBox(height: 16),
                  _buildDropdowns(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Status'),
                  _buildSwitchTile(),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildSubmitButton(isSaving),
            if (state.errorMessage != null) _buildErrorLabel(state.errorMessage!),
          ],
        ),
      ),
    );
  }

  Widget _buildFormHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Question Configuration',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textMain, letterSpacing: -0.5),
        ),
        const SizedBox(height: 4),
        Text(
          widget.question == null 
            ? 'Set up a new wellbeing assessment question for your employees.' 
            : 'Modify the existing question details and status.',
          style: const TextStyle(color: AppColors.textSubtle, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textSubtle, letterSpacing: 1.2),
    );
  }

  Widget _buildQuestionTextField() {
    return TextFormField(
      controller: _questionTextController,
      maxLines: 3,
      style: const TextStyle(fontSize: 15, color: AppColors.textMain),
      decoration: _inputDecoration(
        'Question Text', 
        'e.g. How would you rate your workload this week?', 
        Icons.chat_bubble_outline_rounded
      ),
      validator: (value) => (value == null || value.isEmpty) ? 'Question text is required' : null,
    );
  }

  Widget _buildDropdowns() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          initialValue: _selectedCategory,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSubtle),
          decoration: _inputDecoration('Category', null, Icons.category_outlined),
          items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c.capitalizeFirst))).toList(),
          onChanged: (val) => setState(() => _selectedCategory = val!),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: _selectedType,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSubtle),
          decoration: _inputDecoration('Response Type', null, Icons.rule_rounded),
          items: _types.map((t) => DropdownMenuItem(value: t, child: Text(t.replaceAll('_', ' ').capitalizeFirst))).toList(),
          onChanged: (val) => setState(() => _selectedType = val!),
        ),
      ],
    );
  }

  Widget _buildSwitchTile() {
    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.zero,
      title: const Text('Live Status', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textMain)),
      subtitle: Text(
        _isActive ? 'This question is currently visible in assessments' : 'This question is hidden from employees',
        style: const TextStyle(fontSize: 13, color: AppColors.textSubtle),
      ),
      value: _isActive,
      // ignore: deprecated_member_use
      activeColor: AppColors.primary,
      onChanged: (val) => setState(() => _isActive = val),
    );
  }

  Widget _buildSubmitButton(bool isSaving) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isSaving ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.textMain,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          disabledBackgroundColor: AppColors.textSubtle.withValues(alpha: 0.3),
        ),
        child: isSaving
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : Text(
                widget.question == null ? 'Create Question' : 'Save Changes',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Widget _buildErrorLabel(String error) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.danger, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(error, style: const TextStyle(color: AppColors.danger, fontSize: 13))),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, String? hint, IconData icon) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, size: 20, color: AppColors.primary),
      labelStyle: const TextStyle(color: AppColors.textSubtle, fontSize: 14),
      hintStyle: const TextStyle(color: AppColors.textSubtle, fontSize: 14),
      filled: true,
      fillColor: AppColors.background.withValues(alpha: 0.4),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
    );
  }
}

extension StringExtension on String {
  String get capitalizeFirst => this[0].toUpperCase() + substring(1);
}
