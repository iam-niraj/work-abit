import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar/data/models/models.dart';
import 'package:flutter_calendar/domain/usecases/usecases.dart';
import 'package:flutter_calendar/presentation/screens/show_events/bloc/events_bloc.dart';
import 'package:flutter_calendar/presentation/utils/utils.dart';
import 'package:flutter_calendar/presentation/widgets/widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:intl/intl.dart';

class EventsOverviewPage extends StatelessWidget {
  EventsOverviewPage({Key? key, required this.dateBarDate}) : super(key: key);

  final DateTime dateBarDate;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventsBloc(
        eventsUsecases: context.read<EventsUseCases>(),
      )..add(const LoadEvents()),
      child: EventsOverviewView(
        dateBarDate: dateBarDate,
      ),
    );
  }
}

class EventsOverviewView extends StatelessWidget {
  EventsOverviewView({Key? key, required this.dateBarDate}) : super(key: key);

  final DateTime dateBarDate;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsBloc, EventsOverviewState>(
      builder: (context, state) {
        if (state.events.isEmpty) {
          if (state.status != EventsOverviewStatus.loading) {
            return const Center(child: CupertinoActivityIndicator());
          } else if (state.status != EventsOverviewStatus.success) {
            return const SizedBox();
          }
        }

        List<EventModel> events = state.events
            .where(((element) =>
                DateFormat.yMd().format(element.date!) ==
                DateFormat.yMd().format(dateBarDate)))
            .toList();

        if (events.isEmpty) {
          return Align(
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/img1.png"),
                    fit: BoxFit.fill),
              ),
            ),
          );
        } else {
          return Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: events.length,
              itemBuilder: (_, int index) {
                events.sort((a, b) =>
                    toDouble(a.startTime!).compareTo(toDouble(b.startTime!)));
                events.sort((a, b) => a.isCompleted!.compareTo(b.isCompleted!));
                EventModel event = events[index];
                if (event.repeat == 'Daily') {
                  return AnimationConfiguration.staggeredList(
                      position: index,
                      child: SlideAnimation(
                        child: FadeInAnimation(
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    _showBottomSheet(context, event, index),
                                child: TaskTile(event),
                              )
                            ],
                          ),
                        ),
                      ));
                }
                if (event.repeat == 'Weekly') {
                  if (event.date!.weekday == dateBarDate.weekday) {
                    if (toDouble(event.startTime as TimeOfDay) >
                        toDouble(TimeOfDay.now())) {
                      showWeeklyTaskReminderNotification(
                        event.startTime!.hour,
                        event.startTime!.minute,
                        event.date!.weekday,
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
                                      _showBottomSheet(context, event, index),
                                  child: TaskTile(event),
                                )
                              ],
                            ),
                          ),
                        ));
                  }
                }
                if (DateFormat.yMd().format(event.date as DateTime) ==
                    DateFormat.yMd().format(dateBarDate)) {
                  if (toDouble(event.startTime as TimeOfDay) >
                      toDouble(TimeOfDay.now())) {
                    showTaskReminderNotification(
                      event.startTime!.hour,
                      event.startTime!.minute,
                      event.date!.day,
                      event.date!.month,
                      event.date!.year,
                    );
                  }
                  return GestureDetector(
                    onLongPress: () => _showBottomSheet(context, event, index),
                    child: TaskTile(event),
                  );
                  /* TimelineTile(
                    alignment: TimelineAlign.manual,
                    lineXY: 0.27,
                    beforeLineStyle:
                        LineStyle(color: Colors.teal.withOpacity(0.3)),
                    isFirst: index == 0 ? true : false,
                    indicatorStyle: IndicatorStyle(
                      indicatorXY: 0.3,
                      drawGap: true,
                      width: 30,
                      height: 30,
                      indicator: IconIndicator(
                          iconData: AssetImage(
                              "assets/images/icons8-event-accepted-tentatively-96.png")),
                    ),
                    isLast: index == events.length - 1 ? true : false,
                    startChild: Container(
                      padding: EdgeInsets.only(right: 9),
                      alignment: const Alignment(0.0, -0.50),
                      child: Text(
                        event.startTime!.format(context),
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Colors.teal.withOpacity(0.6),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    endChild: Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 10, top: 10, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            event.title!,
                            style: GoogleFonts.lato(
                              fontSize: 18,
                              color: Colors.teal.withOpacity(0.8),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "From: " +
                                event.startTime!.format(context) +
                                " to " +
                                event.endTime!,
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.teal.withOpacity(0.8),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            event.note!,
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              color: Colors.teal.withOpacity(0.6),
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ],
                      ),
                    ),
                  ); */
                } else {
                  return Text("dscvjisv");
                }
              },
            ),
          );
        }
      },
    );
  }

  _showBottomSheet(BuildContext context, EventModel event, index) {
    Get.bottomSheet(Container(
      padding: const EdgeInsets.only(top: 4),
      height: event.isCompleted == 1
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
          event.isCompleted == 1
              ? Container()
              : _bottomSheetButton(
                  label: "Task Completed",
                  onTap: () {
                    context.read<EventsBloc>().add(UpdateEvent(event, index));
                    Navigator.pop(context);
                  },
                  clr: primaryClr,
                  context: context),
          _bottomSheetButton(
              label: "Delete Task",
              onTap: () {
                context.read<EventsBloc>().add(DeleteEvent(event, index));
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

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;
}

class IconIndicator extends StatelessWidget {
  const IconIndicator({
    Key? key,
    required this.iconData,
    //required this.size,
  }) : super(key: key);

  //final IconData iconData;
  final AssetImage iconData;
  //final double size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.teal.withOpacity(0.3),
          ),
        ),
        Positioned.fill(
          child: Align(
              alignment: Alignment.center,
              child: Image(
                image: iconData,
                width: 20,
                height: 20,
                color: null,
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
              )
              /*  SizedBox(
              height: 30,
              width: 30,
              child: Icon(
                iconData,
                size: size,
                color: const Color(0xFF9E3773).withOpacity(0.7),
              ),
            ), */
              ),
        ),
      ],
    );
  }
}
