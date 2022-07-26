import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar/presentation/cubit/events_cubit.dart';
import 'package:flutter_calendar/presentation/screens/add_event_page.dart';
import 'package:flutter_calendar/presentation/utils/aap_theme/theme.dart';
import 'bloc_observer.dart';
import 'data/models/tasks.dart';
import 'data/repositories/task_repositories';
import 'presentation/screens/home_page.dart';
import 'presentation/utils/aap_theme/get_theme_mode.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

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

  //initializing HIVE (vi)

  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path); //initialized HIVE.
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(TimeOfDayAdapter());

  BlocOverrides.runZoned(
    () => runApp(MyApp()),
    blocObserver: TodoBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key) {
    //_controller.getThemeStatus();
  }

//  final _controller = Get.put(GetThemeMode());

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => EventsCubit(EventsRepository()))
      ],
      child: GetMaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: Themes.lightTheme,
        darkTheme: Themes.darkTheme,
        themeMode: ThemeMode.system,
        routes: {
          "/addEvent": (context) => AddTaskScreen(),
          "/home": (context) => HomePage(),
        },
        home: HomePage(),
      ),
    );
  }
}
