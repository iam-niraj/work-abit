import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar/data/data_source/data_source.dart';
import 'package:flutter_calendar/data/repositories/events_repository_Impl/event_repository_Impl.dart';
import 'package:flutter_calendar/domain/usecases/events_usecases/events_usecases.dart';
import 'package:flutter_calendar/presentation/screens/add_event/view/view.dart';
import 'package:flutter_calendar/presentation/screens/home/view/view.dart';
import 'package:flutter_calendar/presentation/utils/utils.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'bloc_observer.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final _controller = Get.put(GetThemeMode());
  _controller.getThemeStatus();

  AwesomeNotifications().initialize(
    'resource://drawable/res_notification_app_icon',
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Basic Notification showed when task is added',
        defaultColor: Colors.teal,
        importance: NotificationImportance.High,
        channelShowBadge: true,
      ),
      NotificationChannel(
        channelKey: 'scheduled_channel',
        channelName: 'Scheduled Notifications',
        channelDescription: '',
        defaultColor: Colors.teal,
        locked: true,
        importance: NotificationImportance.High,
        // soundSource: 'resource://raw/res_custom_notification',
      ),
    ],
  ); // creating notification channels.

  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter<EventTable>(EventTableAdapter());
  Hive.registerAdapter(TimeOfDayAdapter());

  final eventsUsecases = EventsUseCases(EventsRepositoryImpl());

  BlocOverrides.runZoned(
    () => runApp(MyApp(
      eventsUseCases: eventsUsecases,
    )),
    blocObserver: TodoBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key, required this.eventsUseCases}) : super(key: key) {}

  final EventsUseCases eventsUseCases;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: eventsUseCases,
      child: GetMaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: Themes.lightTheme,
        darkTheme: Themes.darkTheme,
        themeMode: ThemeMode.system,
        routes: {
          "/addEvent": (context) => AddTaskScreen(),
          "/home": (context) => HomePageView(),
        },
        home: HomePageView(),
      ),
    );
  }
}
