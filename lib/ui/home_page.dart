import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_todo_app/ui/profile.dart';
import 'package:sqflite_todo_app/ui/theme.dart';
import 'package:sqflite_todo_app/ui/widgets/button.dart';
import 'package:sqflite_todo_app/ui/widgets/task_tile.dart';

import '../controllers/task_controller.dart';
import '../models/task.dart';
import '../services/theme_services.dart';
import 'package:get/get.dart';

import 'add_task_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final TaskController _taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      appBar: _appBar(context),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          SizedBox(height: 10),
          _showTasks(),
        ],
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (context, index) {
            //print(_taskController.taskList.length);
            Task task = _taskController.taskList[index];
            print(task.toJson());

            if (task.repeat == 'Daily') {
              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showBottomSheet(context, task);
                          },
                          child: TaskTile(task),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            if (task.date == DateFormat.yMd().format(_selectedDate)) {
              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showBottomSheet(context, task);
                          },
                          child: TaskTile(task),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        );
      }),
    );
  }

  Container _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 75,
        initialSelectedDate: DateTime.now(),
        selectionColor: PrimaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  Container _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () async {
              final theme = Theme.of(context);
              final colorScheme = theme.colorScheme;
              final isDark = Theme.of(context).brightness == Brightness.dark;
              final buttonTextColor = isDark ? Colors.white : Colors.black;
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
                builder: (context, child) {
                  // Force light theme for the picker
                  return Theme(
                    data: ThemeData.light().copyWith(
                      colorScheme: ColorScheme.light(
                        primary: Colors.blue, // Header color, selection color
                        onPrimary: Colors.white, // Text on header
                        surface: Colors.white, // Dialog background
                        onSurface: Colors.black, // Text color
                      ),
                      dialogTheme: DialogThemeData(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (pickedDate != null) {
                String formattedDate = DateFormat.yMMMMd().format(pickedDate);

                final bool? confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    // Derive best-contrast text color
                    final Color background = colorScheme.surface;
                    final Color textColor =
                        ThemeData.estimateBrightnessForColor(background) ==
                                Brightness.dark
                            ? Colors.white
                            : Colors.black;

                    return AlertDialog(
                      backgroundColor: background,
                      title: Text(
                        'Add Task',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      content: Text(
                        'Do you want to add a task for $formattedDate?',
                        style: TextStyle(
                          color: textColor.withOpacity(0.9),
                          fontSize: 16,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                          ),
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: Text(
                            'Add',
                            style: TextStyle(color: buttonTextColor),
                          ),
                        ),
                      ],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  },
                );

                if (confirm == true) {
                  await Get.to(() => AddTaskPage(selectedDate: pickedDate));
                  _taskController.getTasks();
                }
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text('Today', style: HeadingStyle),
              ],
            ),
          ),
          MyButton(
            label: '+ Add Task',
            onTap: () async {
              await Get.to(() => AddTaskPage());
              _taskController.getTasks();
            },
          ),
        ],
      ),
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height:
            task.isCompleted == 1
                ? MediaQuery.of(context).size.height * 0.24
                : MediaQuery.of(context).size.height * 0.32,
        width: MediaQuery.of(context).size.width,
        color: Get.isDarkMode ? Colors.black : Colors.white,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
              ),
            ),
            Spacer(),
            task.isCompleted == 1
                ? Container()
                : _bottomSheetButton(
                  label: 'Task Completed',
                  onTap: () {
                    _taskController.markTaskCompleted(task.id!);
                    Get.back();
                  },
                  clr: PrimaryClr,
                  context: context,
                ),
            _bottomSheetButton(
              label: 'Delete Task',
              onTap: () {
                _taskController.delete(task);

                Get.back();
              },
              clr: Colors.red[400]!,
              context: context,
            ),
            SizedBox(height: 20),
            _bottomSheetButton(
              label: 'Close',
              onTap: () {
                Get.back();
              },
              clr: Colors.red[300]!,
              context: context,
              isClose: true,
            ),
            SizedBox(height: 18),
          ],
        ),
      ),
    );
  }

  _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    required BuildContext context,
    bool isClose = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color:
                isClose == true
                    ? Get.isDarkMode
                        ? Colors.grey[600]!
                        : Colors.grey[300]!
                    : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style:
                isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.primary,
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
          Get.snackbar(
            "Theme Changed",
            Get.isDarkMode ? "Activated Light Theme " : "Activated Dark Theme",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.transparent,
            colorText: Get.isDarkMode ? Colors.black : Colors.white,

            duration: Duration(seconds: 2),
            margin: EdgeInsets.all(10),
            borderWidth: 1,
            borderColor: Colors.grey.withOpacity(0.3),
            snackStyle: SnackStyle.FLOATING,
          );
        },
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
          color: Get.isDarkMode ? Colors.white : Colors.black,
          size: 20,
        ),
      ),

      actions: [
        GestureDetector(
          onTap: () => Get.to(() => ProfilePage()),
          child: CircleAvatar(
            radius: 18,
            backgroundImage: AssetImage("assets/images/logo_test.png"),
            foregroundImage: AssetImage("assets/images/logo_test.png"),
            backgroundColor: Colors.black,
          ),
        ),
        SizedBox(width: 20),
      ],
    );
  }
}
