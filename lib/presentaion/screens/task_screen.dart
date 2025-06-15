// lib/screens/task_screen.dart
import 'package:firebase_demo_project/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskScreen extends StatelessWidget {
  final taskCtrl = Get.put(TaskController());
  final textCtrl = TextEditingController();

  TaskScreen({
    super.key,
  });

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    taskCtrl.fetchTasks();
    return Scaffold(
      appBar: AppBar(title: Text("Your Tasks"), actions: [
        IconButton(
            onPressed: () => Get.find<AuthController>().signOut(),
            icon: Icon(Icons.logout)),
      ]),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: TextFormField(
                      controller: textCtrl,
                      decoration:
                          InputDecoration(labelText: "New Task Details"),
                      validator: (value) {
                        if (value == null) return null;
                        if (value.isEmpty) {
                          return 'Please enter a task Details';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () async {
                    bool status = false;
                    if (_formKey.currentState!.validate() &&
                        textCtrl.text.isNotEmpty) {
                      status = await taskCtrl.addTask(textCtrl.text);
                    }

                    if (status) {
                      Get.snackbar("Task Added", "Task added successfully",
                          backgroundColor: Colors.green);
                      textCtrl.clear();
                    } else {
                      Get.snackbar("Task Error", "Failed to add task",
                          backgroundColor: Colors.red);
                    }
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: taskCtrl.tasks.length,
                itemBuilder: (_, i) => ListTile(
                  title: Text(taskCtrl.tasks[i]['title'] ?? ""),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            final status = await taskCtrl
                                .deleteTask(taskCtrl.tasks[i]['id']);

                            if (status) {
                              Get.snackbar(
                                  "Task Deleted", "Task deleted successfully",
                                  backgroundColor: Colors.green);
                            } else {
                              Get.snackbar(
                                  "Task Error", "Failed to delete task",
                                  backgroundColor: Colors.red);
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () async {
                            await showDialog<String>(
                              context: context,
                              builder: (context) {
                                final editCtrl = TextEditingController(
                                    text: taskCtrl.tasks[i]['title']);
                                return AlertDialog(
                                  title: Text("Edit Task"),
                                  content: TextFormField(
                                    controller: editCtrl,
                                    decoration:
                                        InputDecoration(labelText: "New Title"),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a new title';
                                      }
                                      return null;
                                    },
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Get.back(result: null),
                                      child: Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        if (editCtrl.text.isEmpty) {
                                          Get.snackbar("Task Error",
                                              "Please enter a new title",
                                              backgroundColor: Colors.red);
                                          return;
                                        }

                                        final status =
                                            await taskCtrl.updateTask(
                                          taskCtrl.tasks[i]['id'],
                                          editCtrl.text,
                                        );
                                        Get.back(result: editCtrl.text);

                                        if (status) {
                                          Get.snackbar("Task Deleted",
                                              "Task deleted successfully",
                                              backgroundColor: Colors.green);
                                        } else {
                                          Get.snackbar("Task Error",
                                              "Failed to delete task",
                                              backgroundColor: Colors.red);
                                        }
                                      },
                                      child: Text("Save"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
