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
                  child: TextField(
                    controller: textCtrl,
                    decoration: InputDecoration(labelText: "New Task"),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => taskCtrl.addTask(textCtrl.text),
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
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () =>
                        taskCtrl.deleteTask(taskCtrl.tasks[i]['id']),
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
