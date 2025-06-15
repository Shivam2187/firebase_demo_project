import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TaskController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final tasks = <Map<String, dynamic>>[].obs;

  Future<void> fetchTasks() async {
    final querySnapshot = await _firestore.collection("tasks").get();
    tasks.assignAll(querySnapshot.docs
        .map((doc) => {
              'id': doc.id,
              'title': doc['title'],
            })
        .toList());
  }

  Future<bool> addTask(String title) async {
    try {
      await _firestore.collection("tasks").add({"title": title});
      fetchTasks();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> updateTask(String id, String newTitle) async {
    try {
      await _firestore.collection("tasks").doc(id).update({"title": newTitle});
      fetchTasks();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> deleteTask(String id) async {
    try {
      await _firestore.collection("tasks").doc(id).delete();
      fetchTasks();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
