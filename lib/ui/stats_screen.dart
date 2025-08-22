import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pie_chart/pie_chart.dart';
import '../controllers/task_controller.dart';

class StatsScreen extends StatelessWidget {
  final TaskController _taskController = Get.find();

  StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final total = _taskController.totalTasks;
    final completed = _taskController.completedTasks;
    final pending = _taskController.pendingTasks;

    final dataMap = <String, double>{
      "Completed": completed.toDouble(),
      "Pending": pending.toDouble(),
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Statistics"),
        backgroundColor: theme.primaryColor,
      ),
      body: Center(
        child:
            total == 0
                ? Text("No tasks to show", style: theme.textTheme.headlineSmall)
                : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: PieChart(
                    dataMap: dataMap,
                    animationDuration: const Duration(milliseconds: 800),
                    chartRadius: MediaQuery.of(context).size.width / 2,
                    colorList: [Colors.green, Colors.red],
                    chartType: ChartType.disc,
                    chartValuesOptions: const ChartValuesOptions(
                      showChartValuesInPercentage: true,
                      showChartValues: true,
                    ),
                    legendOptions: const LegendOptions(
                      legendPosition: LegendPosition.bottom,
                    ),
                  ),
                ),
      ),
    );
  }
}
