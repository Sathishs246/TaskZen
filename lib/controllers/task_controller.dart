import 'package:get/get.dart';
import '../db/db_helper.dart';
import '../models/task.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    getTasks();
  }

  var taskList = <Task>[].obs;

  /// Insert the data in table
  Future<int> addTask({Task? task}) async {
    final result = await DBHelper.insert(task);
    getTasks();
    return result;
  }

  ///Get all the data from table
  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  ///Delete the data
  void delete(Task task) {
    DBHelper.delete(task);
    getTasks();
  }

  void markTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTasks();
  }

  int get totalTasks => taskList.length;
  int get completedTasks =>
      taskList.where((task) => task.isCompleted == 1).length;
  int get pendingTasks =>
      taskList.where((task) => task.isCompleted == 0).length;

  void getTasksForPeriod(String period) async {
    final data = await DBHelper.getAllTasks();
    final now = DateTime.now();

    final filtered =
        data.map((e) => Task.fromJson(e)).where((task) {
          final taskDate = DateTime.tryParse(task.date ?? '') ?? now;
          if (period == 'week') {
            final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
            final endOfWeek = startOfWeek.add(const Duration(days: 6));
            return taskDate.isAfter(
                  startOfWeek.subtract(const Duration(days: 1)),
                ) &&
                taskDate.isBefore(endOfWeek.add(const Duration(days: 1)));
          } else if (period == 'month') {
            return taskDate.month == now.month && taskDate.year == now.year;
          }
          return true;
        }).toList();

    taskList.assignAll(filtered);
  }
}
