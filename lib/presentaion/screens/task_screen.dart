import 'package:firebase_demo_project/presentaion/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:firebase_demo_project/controllers/auth_controller.dart';
import 'package:firebase_demo_project/controllers/task_controller.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final taskCtrl = Get.put(TaskController());

  final textCtrl = TextEditingController();

  @override
  void dispose() {
    textCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    taskCtrl.fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text("Your Tasks"),
        actions: [
          IconButton(
            onPressed: () async {
              LoaderDialog.show(context: context);
              await Get.find<AuthController>().signOut();
              if (mounted) LoaderDialog.hide(context: context);
            },
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
          ),
        ],
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: textCtrl,
                    decoration: const InputDecoration(
                      labelText: "Enter New Task Details",
                      hintText: "Enter task details",
                      //border: InputBorder.none,
                      prefixIcon: Icon(Icons.task_alt_outlined),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.indigo),
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    if (textCtrl.text.isNotEmpty) {
                      LoaderDialog.show(context: context);
                      final status = await taskCtrl.addTask(textCtrl.text);
                      LoaderDialog.hide(context: context);
                      if (status) {
                        textCtrl.text = '';

                        Get.snackbar(
                          "Success",
                          "Task added successfully",
                          backgroundColor: Colors.green,
                        );
                      } else {
                        Get.snackbar(
                          "Error",
                          "Failed to add task",
                          backgroundColor: Colors.red,
                        );
                      }
                    } else {
                      Get.snackbar(
                        "Error",
                        "Task details cannot be empty",
                        backgroundColor: Colors.red,
                      );
                    }
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () => taskCtrl.tasks.isEmpty
                  ? const Center(
                      child: Text("No tasks yet."),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      itemCount: taskCtrl.tasks.length,
                      itemBuilder: (_, i) {
                        final task = taskCtrl.tasks[i];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 8),
                            title: Text(
                              task['title'] ?? '',
                              style: const TextStyle(fontSize: 16),
                            ),
                            leading: CircleAvatar(
                              backgroundColor: Colors.indigo.shade100,
                              child: Text(
                                '#${i + 1}',
                                style: const TextStyle(
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  padding: const EdgeInsets.all(0),
                                  icon: const Icon(Icons.edit,
                                      color: Colors.grey),
                                  tooltip: "Edit Task",
                                  onPressed: () async {
                                    FocusScope.of(context).unfocus();
                                    final editCtrl = TextEditingController(
                                        text: task['title']);
                                    await taskEditDialog(
                                      context,
                                      editCtrl,
                                      task,
                                    );
                                  },
                                ),
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  padding: const EdgeInsets.all(0),
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  tooltip: "Delete Task",
                                  onPressed: () async {
                                    FocusScope.of(context).unfocus();

                                    LoaderDialog.show(context: context);
                                    final status =
                                        await taskCtrl.deleteTask(task['id']);
                                    if (mounted) {
                                      LoaderDialog.hide(context: context);
                                    }
                                    if (status) {
                                      Get.snackbar(
                                        "Deleted",
                                        "Task deleted",
                                        backgroundColor: Colors.green,
                                      );
                                    } else {
                                      Get.snackbar(
                                        "Error",
                                        "Deletion failed",
                                        backgroundColor: Colors.red,
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> taskEditDialog(BuildContext context,
      TextEditingController editCtrl, Map<String, dynamic> task) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Task"),
        content: TextFormField(
          controller: editCtrl,
          decoration: const InputDecoration(
            labelText: "New Title",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              Get.back();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              FocusScope.of(context).unfocus();
              if (editCtrl.text.isNotEmpty) {
                LoaderDialog.show(context: context);
                final status =
                    await taskCtrl.updateTask(task['id'], editCtrl.text);
                if (mounted) LoaderDialog.hide(context: context);
                Get.back();
                if (status) {
                  Get.snackbar(
                    "Updated",
                    "Task updated",
                    backgroundColor: Colors.green,
                  );
                } else {
                  Get.snackbar(
                    "Error",
                    "Update failed",
                    backgroundColor: Colors.red,
                  );
                }
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
