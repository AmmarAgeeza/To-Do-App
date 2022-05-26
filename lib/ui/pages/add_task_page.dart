import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/models/task.dart';
import 'package:todo/ui/theme.dart';
import 'package:todo/ui/widgets/button.dart';
import 'package:todo/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Add Task',
                style: headingStyle,
              ),
              InputField(
                title: 'Title',
                hint: 'Enter something.',
                controller: _titleController,
              ),
              InputField(
                title: 'Note',
                hint: 'Enter note here.',
                controller: _noteController,
              ),
              InputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    getDateFromUser();
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: 'Start Time',
                      hint: _startTime,
                      widget: IconButton(
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          getTimeFromUser(isStartTime: true);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InputField(
                      title: 'End Time',
                      hint: _endTime,
                      widget: IconButton(
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          getTimeFromUser(isStartTime: false);
                        },
                      ),
                    ),
                  )
                ],
              ),
              InputField(
                title: 'Remind',
                hint: '$_selectedRemind minutes early',
                widget: DropdownButton(
                  elevation: 3,
                  underline: Container(height: 0),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  iconSize: 32,
                  dropdownColor: Colors.grey,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRemind = int.parse(newValue!);
                    });
                  },
                  items: remindList
                      .map<DropdownMenuItem<String>>(
                        (int value) => DropdownMenuItem(
                          value: value.toString(),
                          child: Text(
                            '$value',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              InputField(
                title: 'Repeat',
                hint: _selectedRepeat,
                widget: DropdownButton(
                  elevation: 4,
                  underline: Container(height: 0),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  iconSize: 32,
                  dropdownColor: Colors.grey,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRepeat = newValue!;
                    });
                  },
                  items: repeatList
                      .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        'Color',
                        style: titleStyle,
                      ),
                      Wrap(
                        // direction :Axis.vertical,
                        children: List<Widget>.generate(
                          3,
                          (index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedColor = index;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: CircleAvatar(
                                child: _selectedColor == index
                                    ? const Icon(
                                        Icons.done,
                                        color: Colors.white,
                                      )
                                    : null,
                                backgroundColor: index == 0
                                    ? primaryClr
                                    : index == 1
                                        ? pinkClr
                                        : orangeClr,
                                radius: 14,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  //const SizedBox(width: 20,),
                  MyButton(
                      title: 'Create Task',
                      onTap: () {
                        validateDate();
                      }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar() => AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: primaryClr,
          ),
        ),
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        actions: const [
          CircleAvatar(
            backgroundImage: AssetImage('images/person.jpeg'),
            radius: 18,
          ),
          SizedBox(
            width: 15,
          )
        ],
      );

  validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      addTaskToDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar('required', 'All Fields are reqiured',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: pinkClr,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    } else {
      print('null');
    }
  }

  addTaskToDb() async {
    int value = await _taskController.addTask(
      task: Task(
        title: _titleController.text,
        note: _noteController.text,
        isCompleted: 0,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        color: _selectedColor,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
      ),
    );
    print('$value');
  }

  void getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? _pickedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(
              DateTime.now().add(
                const Duration(minutes: 15),
              ),
            ),
    );
    if (isStartTime) {
      setState(() {
        _startTime = _pickedTime!.format(context);
      });
    } else if (!isStartTime) {
      setState(() {
        _endTime = _pickedTime!.format(context);
      });
    } else {
      print('error in picked time');
    }
  }

  void getDateFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (_pickedDate != null) {
      setState(() {
        _selectedDate = _pickedDate;
      });
    } else {
      print('pickedDate = null');
    }
  }
}
