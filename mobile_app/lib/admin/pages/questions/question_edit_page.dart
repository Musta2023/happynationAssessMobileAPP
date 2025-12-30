import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/admin/controllers/admin_question_controller.dart';
import 'package:mobile_app/models/question.dart';

class QuestionEditPage extends StatefulWidget {
  final Question? question;

  const QuestionEditPage({super.key, this.question});

  @override
  State<QuestionEditPage> createState() => _QuestionEditPageState();
}

class _QuestionEditPageState extends State<QuestionEditPage> {
  final AdminQuestionController controller = Get.find<AdminQuestionController>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _textController;
  late String _selectedCategory;
  late String _selectedType;
  late bool _isActive;
  bool _isSaving = false;

  final List<String> _categories = ['stress', 'motivation', 'satisfaction'];
  final List<String> _types = ['likert', 'yes_no', 'text'];

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.question?.questionText ?? '');
    _selectedCategory = widget.question?.category ?? _categories.first;
    _selectedType = widget.question?.type ?? _types.first;
    _isActive = widget.question?.isActive ?? true;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      final data = {
        'question_text': _textController.text,
        'category': _selectedCategory,
        'type': _selectedType,
        'is_active': _isActive,
      };

      if (widget.question != null) {
        await controller.updateQuestion(widget.question!.id, data);
      } else {
        await controller.addQuestion(data);
      }

      // The snackbar is shown by the controller.
      // We can now navigate back.
      if (mounted) {
        Get.back();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.question != null ? 'Edit Question' : 'Add Question'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _textController,
                decoration: const InputDecoration(labelText: 'Question Text'),
                validator: (value) => (value == null || value.isEmpty) ? 'Question text is required' : null,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) => setState(() => _selectedCategory = val!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                decoration: const InputDecoration(labelText: 'Response Type'),
                items: _types.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (val) => setState(() => _selectedType = val!),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Is Active'),
                value: _isActive,
                onChanged: (val) => setState(() => _isActive = val),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isSaving ? null : _submitForm,
                child: _isSaving
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(widget.question != null ? 'Update' : 'Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
