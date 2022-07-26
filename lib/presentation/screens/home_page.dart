import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/tasks.dart';
import '../cubit/events_cubit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import '../utils/aap_theme/get_theme_mode.dart';
import '../utils/aap_theme/theme.dart';
import '../utils/notifications.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/button_widget.dart';
import '../widgets/task_tile.dart';
import '../widgets/toast.dart';
import 'add_event_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();

  final DatePickerController _controller = DatePickerController();

  final GetThemeMode _themeController = Get.put(GetThemeMode());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.jumpToSelection();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        widget: ObxValue(
          (data) => DayNightSwitcherIcon(
            isDarkModeEnabled: _themeController.isLightTheme.value,
            onStateChanged: (state) {
              Get.isDarkMode
                  ? commonToast("Switched to Light Theme")
                  : commonToast("Switched to Dark Theme");
              _themeController.isLightTheme.value = state;
              Get.changeThemeMode(
                _themeController.isLightTheme.value
                    ? ThemeMode.light
                    : ThemeMode.dark,
              );
              _themeController.saveThemeStatus();
              //  _taskController.getThemeStatus(state);
            },
          ),
          false.obs,
        ),
      ),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          const SizedBox(
            height: 10,
          ),
          _showTasks()
        ],
      ),
    );
  }

  _showTasks() {
    return Expanded(
        child: BlocBuilder<EventsCubit, TodoState>(builder: (context, state) {
      if (state is TodoInitial) {
        context.read<EventsCubit>().getData();
        return CircularProgressIndicator();
      } else if (state is TodoLoaded) {
        if (state.events.isEmpty) {
          return Text("No Events");
        }
        return ListView.builder(
            itemCount: state.events.length,
            itemBuilder: (_, int index) {
              Task task = state.events[index];

              if (task.repeat == 'Daily') {
                return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  _showBottomSheet(context, task, index),
                              child: TaskTile(task),
                            )
                          ],
                        ),
                      ),
                    ));
              }
              if (task.repeat == 'Weekly') {
                if (task.date!.weekday == _selectedDate.weekday) {
                  if (toDouble(task.startTime as TimeOfDay) >
                      toDouble(TimeOfDay.now())) {
                    showWeeklyTaskReminderNotification(
                      task.startTime!.hour,
                      task.startTime!.minute,
                      task.date!.weekday,
                    );
                  }
                  return AnimationConfiguration.staggeredList(
                      position: index,
                      child: SlideAnimation(
                        child: FadeInAnimation(
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    _showBottomSheet(context, task, index),
                                child: TaskTile(task),
                              )
                            ],
                          ),
                        ),
                      ));
                }
              }
              if (DateFormat.yMd().format(task.date as DateTime) ==
                  DateFormat.yMd().format(_selectedDate)) {
                if (toDouble(task.startTime as TimeOfDay) >
                    toDouble(TimeOfDay.now())) {
                  task.startTime!.minute;
                  task.startTime!.hour;
                  task.remind;
                  showTaskReminderNotification(
                      task.startTime!.hour,
                      task.startTime!.minute,
                      task.date!.day,
                      task.date!.month,
                      task.date!.year);
                }
                return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  _showBottomSheet(context, task, index),
                              child: TaskTile(task),
                            )
                          ],
                        ),
                      ),
                    ));
              } else {
                return Container();
              }
            });
      } else {
        return CircularProgressIndicator();
      }
    }));
  }

  _showBottomSheet(BuildContext context, Task task, index) {
    Get.bottomSheet(Container(
      padding: const EdgeInsets.only(top: 4),
      height: task.isCompleted == 1
          ? MediaQuery.of(context).size.height * 0.24
          : MediaQuery.of(context).size.height * 0.32,
      color: Get.isDarkMode ? darkGreyClr : Colors.white,
      child: Column(
        children: [
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
          ),
          const Spacer(),
          task.isCompleted == 1
              ? Container()
              : _bottomSheetButton(
                  label: "Task Completed",
                  onTap: () {
                    // _taskController.markTaskComplete(index);
                    final eventsCubit = BlocProvider.of<EventsCubit>(context);
                    eventsCubit.updateData(index);
                    Navigator.pop(context);
                  },
                  clr: primaryClr,
                  context: context),
          _bottomSheetButton(
              label: "Delete Task",
              onTap: () {
                // _taskController.deleteTask(index);
                final eventsCubit = BlocProvider.of<EventsCubit>(context);
                eventsCubit.deleteData(index);
                Navigator.pop(context);
              },
              clr: Colors.red,
              context: context),
          const SizedBox(
            height: 20,
          ),
          _bottomSheetButton(
              label: "Close",
              onTap: () {
                Get.back();
              },
              clr: Colors.red,
              context: context,
              isClose: true),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    ));
  }

  _bottomSheetButton(
      {required String label,
      required Function()? onTap,
      required Color clr,
      bool isClose = false,
      required BuildContext context}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            color: isClose == true ? Colors.transparent : clr,
            border: Border.all(
                width: 2,
                color: isClose == true
                    ? Get.isDarkMode
                        ? Colors.grey[600]!
                        : Colors.grey[300]!
                    : clr),
            borderRadius: BorderRadius.circular(20)),
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

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime(DateTime.now().year, DateTime.now().month),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
        controller: _controller,
        daysCount: 60,
      ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  'Today',
                  style: headingStyle,
                )
              ],
            ),
          ),
          MyButton(
              label: "+ Add Task",
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTaskScreen(),
                  ),
                );
                // _taskController.getTask();
              })
        ],
      ),
    );
  }

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;
}
