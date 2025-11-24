import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onaidocs/features/tasks/domain/entities/task.dart';
import 'package:onaidocs/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:onaidocs/features/tasks/presentation/bloc/task_event.dart';
import 'package:onaidocs/features/tasks/presentation/bloc/task_state.dart';
import 'package:uuid/uuid.dart';

class TaskEditPage extends StatefulWidget {
  final String? taskId;

  const TaskEditPage({super.key, this.taskId});

  @override
  State<TaskEditPage> createState() => _TaskEditPageState();
}

class _TaskEditPageState extends State<TaskEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  TaskPriority _priority = TaskPriority.low;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _isEditing = widget.taskId != null;

    if (_isEditing) {
      _loadTaskData();
    }
  }

  void _loadTaskData() {
    final state = context.read<TaskBloc>().state;
    if (state is TaskLoaded) {
      try {
        final task = state.tasks.firstWhere((t) => t.id == widget.taskId);
        _titleController.text = task.title;
        _descriptionController.text = task.description;
        _priority = task.priority;
      } catch (e) {
        // Task not found
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      
      String id = widget.taskId ?? const Uuid().v4();
      DateTime createdAt = now;

      if (_isEditing) {
        final state = context.read<TaskBloc>().state;
        if (state is TaskLoaded) {
           try {
             final original = state.tasks.firstWhere((t) => t.id == widget.taskId);
             id = original.id;
             createdAt = original.createdAt;
           } catch (_) {}
        }
      }

      final task = Task(
        id: id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: _priority,
        createdAt: createdAt,
      );

      context.read<TaskBloc>().add(AddUpdateTask(task));
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F6F6),
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          _isEditing ? 'Редактирование задачи' : 'Создание задачи',
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Данные задачи',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Приоритет', isRequired: true),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(child: _buildPriorityButton(TaskPriority.low, 'Низкий')),
                              const SizedBox(width: 8),
                              Expanded(child: _buildPriorityButton(TaskPriority.medium, 'Средний')),
                              const SizedBox(width: 8),
                              Expanded(child: _buildPriorityButton(TaskPriority.high, 'Высокий')),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Наименование', isRequired: true),
                          TextFormField(
                            controller: _titleController,
                            style: GoogleFonts.inter(fontSize: 16, color: Colors.black),
                            decoration: InputDecoration(
                              hintText: 'Заявка на покупку',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              contentPadding: const EdgeInsets.symmetric(vertical: 12),
                              isDense: true,
                              filled: false, // Don't use theme's fill
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: Icon(Icons.cancel, color: Colors.grey[300], size: 22),
                                onPressed: _titleController.clear,
                              ),
                            ),
                            validator: (value) => value == null || value.isEmpty ? 'Введите название' : null,
                          ),
                          
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.0),
                            child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                          ),
                          const SizedBox(height: 12),

                          _buildLabel('Содержание', isRequired: true),
                          TextFormField(
                            controller: _descriptionController,
                            maxLines: null,
                            minLines: 3,
                            style: GoogleFonts.inter(fontSize: 16, color: Colors.black, height: 1.4),
                            decoration: InputDecoration(
                              hintText: 'Введите описание...',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              contentPadding: const EdgeInsets.symmetric(vertical: 12),
                              isDense: true,
                              filled: false, // Don't use theme's fill
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: Icon(Icons.cancel, color: Colors.grey[300], size: 22),
                                onPressed: _descriptionController.clear,
                              ),
                            ),
                             validator: (value) => value == null || value.isEmpty ? 'Введите описание' : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: _saveTask,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF1677FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _isEditing ? 'Сохранить' : 'Создать',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, {bool isRequired = false}) {
    return RichText(
      text: TextSpan(
        text: text,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF9CA3AF),
        ),
        children: [
          if (isRequired)
            const TextSpan(
              text: '*',
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }

  Widget _buildPriorityButton(TaskPriority priority, String label) {
    final isSelected = _priority == priority;
    return GestureDetector(
      onTap: () {
        setState(() {
          _priority = priority;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1677FF) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
            color: isSelected ? Colors.white : const Color(0xFF9CA3AF),
          ),
        ),
      ),
    );
  }
}
