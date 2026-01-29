import 'package:flutter/material.dart';
import '../widgets/task_card.dart';
import '../widgets/task_section.dart';
import '../widgets/create_task_form.dart';
import '../../domain/models/task_model.dart';
import '../../../../core/theme/app_colors.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'Investigate Camera Blind Spot',
      priority: TaskPriority.high,
      description: 'Check Zone C emergency exit camera coverage',
      tags: ['camera', 'zone-c'],
      assignee: 'Mike Chen',
      alertId: 'ALT-001',
      date: '2024-01-16',
      status: 'todo',
    ),
    Task(
      id: '2',
      title: 'Follow up Customer Complaint',
      priority: TaskPriority.medium,
      description: 'Respond to parking lot security concern',
      tags: ['customer', 'parking'],
      assignee: 'David Wilson',
      feedbackId: 'FB-003',
      date: '2024-01-17',
      status: 'todo',
    ),
    Task(
      id: '3',
      title: 'Monthly Camera Maintenance',
      priority: TaskPriority.medium,
      description: 'Clean lenses and check connections',
      progress: 0.65,
      tags: ['maintenance', 'cameras'],
      assignee: 'Tech Team',
      date: '2024-01-18',
      status: 'doing',
    ),
    Task(
      id: '4',
      title: 'Update Security Protocols',
      priority: TaskPriority.high,
      description: 'Revise emergency response procedures',
      tags: ['protocols', 'security'],
      assignee: 'Sarah Johnson',
      date: '2024-01-15',
      status: 'done',
    ),
  ];

  void _addTask(Map<String, dynamic> data) {
    setState(() {
      _tasks.add(
        Task(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: data['title'],
          description: data['description'],
          priority: _parsePriority(data['priority']),
          tags: List<String>.from(data['tags']),
          assignee: data['assignee'],
          date: data['date'],
          status: 'todo',
        ),
      );
    });
  }

  TaskPriority _parsePriority(String p) {
    switch (p.toLowerCase()) {
      case 'high':
        return TaskPriority.high;
      case 'critical':
        return TaskPriority.critical;
      case 'medium':
        return TaskPriority.medium;
      default:
        return TaskPriority.low;
    }
  }

  @override
  Widget build(BuildContext context) {
    final todoTasks = _tasks.where((t) => t.status == 'todo').toList();
    final doingTasks = _tasks.where((t) => t.status == 'doing').toList();
    final doneTasks = _tasks.where((t) => t.status == 'done').toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.shield_rounded,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Tasks',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
                fontSize: 24,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          _HeaderAction(
            child: Row(
              children: [
                Icon(
                  Icons.filter_list_rounded,
                  color: Colors.grey[600],
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'Filter',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Task Management',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 24),

            // To Do Section
            TaskSection(
              title: 'To Do',
              description: 'Organize and track security tasks and assignments',
              count: todoTasks.length,
              children: todoTasks.map((t) => _buildTaskCard(t)).toList(),
            ),

            // Doing Section
            TaskSection(
              title: 'Doing',
              description: 'Tasks currently in progress',
              count: doingTasks.length,
              backgroundColor: Colors.orange.withOpacity(0.04),
              children: doingTasks.map((t) => _buildTaskCard(t)).toList(),
            ),

            // Done Section
            TaskSection(
              title: 'Done',
              description: 'Recently completed tasks',
              count: doneTasks.length,
              backgroundColor: Colors.teal.withOpacity(0.04),
              children: doneTasks.map((t) => _buildTaskCard(t)).toList(),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => CreateTaskForm(onTaskCreated: _addTask),
          );
        },
        backgroundColor: AppColors.primary,
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    return TaskCard(
      title: task.title,
      priority: task.priority.name,
      description: task.description,
      tags: task.tags,
      assignee: task.assignee,
      alertId: task.alertId,
      feedbackId: task.feedbackId,
      date: task.date,
      progress: task.progress,
    );
  }
}

class _HeaderAction extends StatelessWidget {
  final Widget child;

  const _HeaderAction({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.divider),
      ),
      child: child,
    );
  }
}
