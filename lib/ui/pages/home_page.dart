import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/models/task.dart';
import 'package:todo/services/notification_services.dart';
import 'package:todo/services/theme_services.dart';
import 'package:todo/ui/pages/add_task_page.dart';
import 'package:todo/ui/size_config.dart';
import 'package:todo/ui/widgets/button.dart';

import 'package:todo/ui/widgets/task_tile.dart';

import '../theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NotifyHelper notifyHelper;
  @override
  void initState() {
    super.initState();
    _taskController.getTasks();

    notifyHelper = NotifyHelper();
    notifyHelper.requestAndroidPermissions();
    notifyHelper.initializeNotification();
  }

  final TaskController _taskController = Get.put(TaskController());
  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          const SizedBox(
            height: 6,
          ),
          _showTasks(),
        ],
      ),
    );
  }

  AppBar _appBar() => AppBar(
        leading: IconButton(
            onPressed: () {
              ThemeServices().switchMode();
              NotifyHelper()
                  .displayNotification(title: 'MeroOo', body: 'Ammar');
              // NotifyHelper()
              //     .displayNotification(title: 'MeroOo', body: 'Ammar');
              // NotifyHelper().scheduledNotification(4,5,);
            },
            icon: Icon(
              Get.isDarkMode
                  ? Icons.wb_sunny_outlined
                  : Icons.nightlight_round_outlined,
              size: 25,
              color: Get.isDarkMode ? Colors.white : darkGreyClr,
            )),
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

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  DateFormat.yMMMMd().format(
                    DateTime.now(),
                  ),
                  style: subheadingStyle),
              Text(
                'Today',
                style: headingStyle,
              )
            ],
          ),
          MyButton(
            title: '+ Add Task',
            onTap: () async {
              await Get.to(const AddTaskPage());
              _taskController.getTasks();
            },
          )
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(left: 10, top: 10),
      child: DatePicker(
        DateTime.now(),
        width: 80,
        height: 100,
        initialSelectedDate: DateTime.now(),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        onDateChange: (newDate) => setState(() {
          selectedDate = newDate;
        }),
      ),
    );
  }

  Future<void> _onRefresh() async {
    _taskController.getTasks();
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        if (_taskController.taskList.isEmpty) {
          return _noTaskMSG();
        } else {
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              scrollDirection: SizeConfig.orientation == Orientation.landscape
                  ? Axis.horizontal
                  : Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                var task = _taskController.taskList[index];
                var hour = task.startTime.toString().split(':')[0];
                var minutes = task.startTime.toString().split(':')[1];
                debugPrint(hour);
                debugPrint(minutes);

                var date = DateFormat.jm().parse(task.startTime!);
                var myTime = DateFormat('HH:mm').format(date);

                notifyHelper.scheduledNotification(
                  int.parse(myTime.split(':')[0]),
                  int.parse(myTime.split(':')[1]),
                  task,
                );
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 1375),
                  child: SlideAnimation(
                    horizontalOffset: 300,
                    child: FadeInAnimation(
                      //duration: const Duration(),
                      child: GestureDetector(
                        onTap: () => showBottomSheet(context, task),
                        child: TaskTile(
                          task,
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: _taskController.taskList.length,
            ),
          );
        }
      }),
    );
  }

  _noTaskMSG() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 2000),
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SvgPicture.asset(
                    'images/task.svg',
                    height: 150,
                    color: primaryClr.withOpacity(0.5),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Text(
                      'You do not have ant Tasks yet!\n Add new Tasks to make your day productive.',
                      style: subtitleStyle,
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 4),
          width: SizeConfig.screenWidth,
          height: (SizeConfig.orientation == Orientation.landscape)
              ? (task.isCompleted == 1
                  ? SizeConfig.screenHeight * 0.6
                  : SizeConfig.screenHeight * 0.8)
              : (task.isCompleted == 1
                  ? SizeConfig.screenHeight * 0.3
                  : SizeConfig.screenHeight * 0.39),
          color: Get.isDarkMode ? darkHeaderClr : Colors.white,
          child: Column(
            children: [
              Flexible(
                child: Container(
                  height: 6,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              task.isCompleted == 1
                  ? Container()
                  : _buildBottomSheet(
                      lable: 'Task Completed',
                      onTab: () {
                        Get.back();
                      },
                      clr: primaryClr,
                    ),
              _buildBottomSheet(
                lable: 'Delete Task',
                onTab: () {
                  Get.back();
                },
                clr: primaryClr,
              ),
              Divider(
                color: Get.isDarkMode ? Colors.grey : darkGreyClr,
              ),
              _buildBottomSheet(
                lable: 'Cancel',
                onTab: () {
                  Get.back();
                },
                clr: primaryClr,
              ),
              const SizedBox(
                height: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildBottomSheet({
    required String lable,
    required Function() onTab,
    required Color clr,
    bool isClose = false,
  }) {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: 65,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
          border: Border.all(
              width: 2,
              color: isClose
                  ? Get.isDarkMode
                      ? Colors.grey[600]!
                      : Colors.grey[300]!
                  : clr),
        ),
        child: Center(
          child: Text(
            lable,
            style: isClose
                ? titleStyle
                : titleStyle.copyWith(
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    );
  }
}
