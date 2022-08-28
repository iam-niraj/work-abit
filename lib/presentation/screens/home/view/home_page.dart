import 'dart:async';

import 'package:flutter/material.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar/data/models/models.dart';
import 'package:flutter_calendar/data/repositories/repositories.dart';
import 'package:flutter_calendar/domain/usecases/usecases.dart';
import 'package:flutter_calendar/presentation/screens/add_event/view/view.dart';
import 'package:flutter_calendar/presentation/screens/home/cubit/home_cubit.dart';
import 'package:flutter_calendar/presentation/screens/show_events/view/view.dart';
import 'package:flutter_calendar/presentation/utils/utils.dart';
import 'package:flutter_calendar/presentation/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_calendar/presentation/utils/colors.dart' as color;
import 'package:date_picker_timeline/date_picker_timeline.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(
        indianHolidaysUseCases: IndianHolidaysUseCases(
          IndianHolidaysRepositoryImpl(),
        ),
      )..setHolidays(),
      child: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DateTime _selectedDate = DateTime.now();
  final DatePickerController _controller = DatePickerController();
  final GetThemeMode _themeController = Get.put(GetThemeMode());

  @override
  void initState() {
    Timer.run(() => _controller.jumpToSelection());
    super.initState();
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final list = context.select((HomeCubit cubit) => cubit.state.items);
    final item = list.firstWhereOrNull((element) =>
        element.start.date == DateFormat('yyyy-MM-dd').format(_selectedDate));
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.AppColor.gradientFirst.withOpacity(0.9),
              color.AppColor.gradientSecond,
            ],
            begin: const FractionalOffset(0.0, 0.4),
            end: Alignment.topRight,
          ),
        ),
        child: Column(
          children: [
            /* Container(
              height: 160.0,
              child: Stack(
                children: <Widget>[
                  Container(
                    color: Colors.red,
                    width: MediaQuery.of(context).size.width,
                    height: 100.0,
                    child: Center(
                      child: Text(
                        "Home",
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 80.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1.0),
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.5),
                                width: 1.0),
                            color: Colors.white),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.menu,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                print("your menu action here");
                                _scaffoldKey.currentState!.openDrawer();
                              },
                            ),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Search",
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.search,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                print("your menu action here");
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.notifications,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                print("your menu action here");
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ), */
            //TopBar(actions: [], title: "Thus",),
            _addTaskBar(item),
            _addDateBar(list),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(70),
                    )),
                child: Column(
                  children: [
                    _addEventsTab(),
                    EventsOverviewPage(
                      dateBarDate: _selectedDate,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _addEventsTab() {
    return Container(
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Events",
            style: subHeadingStyle,
          ),
          /* MyButton(
            label: "+ Add Task",
            onTap: () => Navigator.of(context).push(AddTaskPage.route()),
          ), */
        ],
      ),
    );
  }

  _addDateBar(List<Items> list) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 20),
      child: DatePicker(
        DateTime(DateTime.now().year, DateTime.now().month),
        height: 80,
        width: 60,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        choiceDates: list.map((e) => DateTime.parse(e.start.date)).toList(),
        choiceColor: Colors.amber,
        deactivatedColor: Colors.redAccent.shade100,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
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

  _addTaskBar(Items? item) {
    String? data = item?.summary ?? "";
    return Container(
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(_selectedDate),
                  style: subHeadingStyle,
                ),
                DateFormat('yyyy-MM-dd').format(_selectedDate) ==
                        DateFormat('yyyy-MM-dd').format(DateTime.now())
                    ? Text(
                        'Today, ' + data,
                        style: headingStyle,
                      )
                    : Text(
                        data,
                        style: titleStyle,
                      )
              ],
            ),
          ),
          /* MyButton(
            label: "+ Add Task",
            onTap: () => Navigator.of(context).push(AddTaskPage.route()),
          ), */
        ],
      ),
    );
  }
}
