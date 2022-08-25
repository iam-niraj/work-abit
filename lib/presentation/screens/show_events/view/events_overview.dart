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
          return Center(
              child:
                  SizedBox(height: 50, width: 50, child: Text("NASCHBSCWNC")));
        } else {
          return Expanded(
            child: ListView.builder(
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
