import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:firebase_demo_project/controllers/auth_controller.dart';
import 'package:firebase_demo_project/controllers/task_controller.dart';

class TaskScreen extends StatelessWidget {
  final taskCtrl = Get.put(TaskController());
  final textCtrl = TextEditingController();

  TaskScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    taskCtrl.fetchTasks();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text("Your Tasks"),
        actions: [
          IconButton(
            onPressed: () => Get.find<AuthController>().signOut(),
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
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: TextFormField(
                      controller: textCtrl,
                      decoration: const InputDecoration(
                        labelText: "Enter New Task Details",
                        hintText: "Enter task details",
                        //border: InputBorder.none,
                        prefixIcon: Icon(Icons.task_alt_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter task details';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.indigo),
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    if (_formKey.currentState?.validate() ?? false) {
                      final status = await taskCtrl.addTask(textCtrl.text);
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
                    }
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () => taskCtrl.tasks.isEmpty
                  ? const Center(child: Text("No tasks yet."))
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
                                vertical: 16, horizontal: 12),
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
                                  icon: const Icon(Icons.edit,
                                      color: Colors.grey),
                                  tooltip: "Edit Task",
                                  onPressed: () async {
                                    FocusScope.of(context).unfocus();
                                    final editCtrl = TextEditingController(
                                        text: task['title']);
                                    await showDialog(
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
                                                final status =
                                                    await taskCtrl.updateTask(
                                                        task['id'],
                                                        editCtrl.text);
                                                Get.back();
                                                if (status) {
                                                  Get.snackbar(
                                                      "Updated", "Task updated",
                                                      backgroundColor:
                                                          Colors.green,
                                                      snackPosition:
                                                          SnackPosition.BOTTOM);
                                                } else {
                                                  Get.snackbar(
                                                      "Error", "Update failed",
                                                      backgroundColor:
                                                          Colors.red,
                                                      snackPosition:
                                                          SnackPosition.BOTTOM);
                                                }
                                              }
                                            },
                                            child: const Text("Save"),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  tooltip: "Delete Task",
                                  onPressed: () async {
                                    FocusScope.of(context).unfocus();
                                    final status =
                                        await taskCtrl.deleteTask(task['id']);
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
}
