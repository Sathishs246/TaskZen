import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_todo_app/models/task.dart';
import 'package:sqflite_todo_app/ui/theme.dart';
import 'package:sqflite_todo_app/ui/widgets/button.dart';
import 'package:sqflite_todo_app/ui/widgets/input_field.dart';

import '../controllers/task_controller.dart';

class AddTaskPage extends StatefulWidget {
  final DateTime? selectedDate;

  const AddTaskPage({Key? key, this.selectedDate}) : super(key: key);

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime = "9:30 AM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = "None";
  List<String> RepeatList = ["None", "Daily", "Weekly", "Monthly"];
  int _selectedColor = 0;

  @override
  void initState() {
    super.initState();

    if (widget.selectedDate != null) {
      _selectedDate = widget.selectedDate!;
      _dateController.text = DateFormat.yMd().format(widget.selectedDate!);
    } else {
      _dateController.text = DateFormat.yMd().format(_selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      appBar: _appBar(context),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add Task', style: HeadingStyle),
              MyInputField(
                title: 'Title',
                hint: 'Enter your title',
                controller: _titleController,
              ),
              MyInputField(
                title: 'Note',
                hint: 'Enter your note',
                controller: _noteController,
              ),
              MyInputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: () {
                    _getDateFromUser();
                  },
                  icon: Icon(Icons.calendar_today_outlined, color: Colors.grey),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: MyInputField(
                      title: 'Start Time',
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: true);
                        },
                        icon: Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: MyInputField(
                      title: 'End Time',
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: false);
                        },
                        icon: Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              MyInputField(
                title: 'Remind',
                hint: "$_selectedRemind minutes early",
                widget: DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRemind = int.parse(newValue!);
                    });
                  },
                  items:
                      remindList.map<DropdownMenuItem<String>>((int value) {
                        return DropdownMenuItem<String>(
                          value: value.toString(),
                          child: Text(value.toString()),
                        );
                      }).toList(),
                ),
              ),
              MyInputField(
                title: 'Repeat',
                hint: "$_selectedRepeat",
                widget: DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRepeat = newValue!;
                    });
                  },
                  items:
                      RepeatList.map<DropdownMenuItem<String>>((String? value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value!,
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }).toList(),
                ),
              ),
              SizedBox(height: 17),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPallete(),
                  MyButton(label: 'Create Task', onTap: () => _validateDate()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column _colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Color', style: titleStyle),
        SizedBox(height: 8.0),
        Wrap(
          children: List<Widget>.generate(3, (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor:
                      index == 0
                          ? PrimaryClr
                          : index == 1
                          ? pinkClr
                          : yellowClr,
                  child:
                      _selectedColor == index
                          ? Icon(Icons.done, color: Colors.white, size: 16)
                          : Container(),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      //Add to Data base
      _addTaskToDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        "Required",
        "All fields are required !",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: Icon(Icons.warning_amber_rounded, color: Colors.red),
      );
    }
  }

  ///Add Task
  _addTaskToDb() async {
    int value = await _taskController.addTask(
      task: Task(
        title: _titleController.text,
        note: _noteController.text,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
        color: _selectedColor,
        isCompleted: 0,
      ),
    );
    print("My id is " + "$value");
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.primary,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(Icons.arrow_back_ios, size: 20),
      ),

      actions: [
        CircleAvatar(
          radius: 18,
          backgroundImage: AssetImage("assets/images/logo_test.png"),
          foregroundImage: AssetImage("assets/images/logo_test.png"),
          backgroundColor: Colors.black,
        ),
        SizedBox(width: 20),
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue, // header background
              onPrimary: Colors.white, // header text color
              onSurface:
                  Colors.black, // body text color (including selected date)
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    } else {
      print("It's null or something is wrong");
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String _formatedTime = pickedTime.format(context);
    if (pickedTime == null) {
      print("Time Canceled");
    } else if (isStartTime == true) {
      setState(() {
        _startTime = _formatedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(":")[0]),
        minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue, // Dial/clock hand and active elements
              onSurface: Colors.black, // Text color for time and numbers
              surface: Colors.white, // Background color of the time picker
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, // Button color (OK/Cancel)
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
