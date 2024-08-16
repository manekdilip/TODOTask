import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:platform_device_id_v3/platform_device_id.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/repository/notification_repo.dart';
import 'package:workmanager/workmanager.dart';

import 'utils/app_pages.dart';
final navigatorKey = GlobalKey<NavigatorState>();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
sendData() async {
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyCGLhIWawIBUiV4lQss36XsG9M3_be3fuQ',
    appId: '1:13084226496:android:d7b8909c13e434b96cce25',
    projectId: 'demowebrtc-eccfe',
    storageBucket: 'demowebrtc-eccfe.appspot.com',
    messagingSenderId: '13084226496',
  ));
  var currentUserId = await PlatformDeviceId.getDeviceId ?? 'default';
  // SharedPreferences pref = await SharedPreferences.getInstance();
  // var str = pref.getString(AppStrings.prefStringsNotSyncedTodos);
  // List<Todo> todos = todosFromJson(str!);
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  await Hive.initFlutter();
  Hive.registerAdapter<Todo>(TodoAdapter());
  var box = await Hive.openBox<Todo>(AppStrings.tasksBox);
  List<Todo> notSyncedTodos=[];
  for (var todo in box.values) {
    if (!todo.isSynced) {
      notSyncedTodos.add(todo);
    }
  }

 if(notSyncedTodos.isNotEmpty) {
   for (var todo in notSyncedTodos) {
     final todoUpdate = Todo(
         id: todo.id,
         title: todo.title,
         description: todo.description,
         createdDT: todo.createdDT,
         updatedDT:todo.updatedDT,
         isCompleted: todo.isCompleted ,
         isSynced: true);
     await FirebaseFirestore.instance
         .collection("todos")
         .doc(currentUserId)
         .collection('user_todos')
         .doc(todo.id)
         .set(
         { 'title': todo.title,
           'description': todo.description,
           'createdDT': todo.createdDT,
           'updatedDT':todo.updatedDT,
           'isCompleted': todo.isCompleted,
           'isSynced': true,
           'lastUpdateDT':FieldValue.serverTimestamp()
         });
     await box.put(todoUpdate.id, todoUpdate);
     LocalNotifications.showSimpleNotification(
         title: "Remote Sync",
         body: "Remote Sync is Executed Successfully",
         payload: "This is simple data");
   }
 }
}

@pragma("vm:entry-point")
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    // Switch case to run all the list of background tasks you have
    switch (taskName) {
      case AppStrings.taskName:
        await sendData();
        break;
      // case Workmanager.iOSBackgroundTask:
      //   stderr.writeln("The iOS background fetch was triggered");
      //   break;
      default:
        if (kDebugMode) {
          print("Hello from switch case default");
        }
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher);
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyCGLhIWawIBUiV4lQss36XsG9M3_be3fuQ',
    appId: '1:13084226496:android:d7b8909c13e434b96cce25',
    projectId: 'demowebrtc-eccfe',
    storageBucket: 'demowebrtc-eccfe.appspot.com',
    messagingSenderId: '13084226496',
  ));
  await Hive.initFlutter();
  Hive.registerAdapter<Todo>(TodoAdapter());
  var box = await Hive.openBox<Todo>(AppStrings.tasksBox);
  for (var task in box.values) {
    if (task.createdDT.day != DateTime.now().day) {
      task.delete();
    }
  }
  await LocalNotifications.init();

//  handle in terminated state
  var initialNotification =
  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (initialNotification?.didNotificationLaunchApp == true) {
    // LocalNotifications.onClickNotification.stream.listen((event) {
    Future.delayed(const Duration(seconds: 1), () {
      // print(event);
      navigatorKey.currentState!.pushNamed('/home');
    });
  }

  runApp(BaseWidget(child: const MyApp()));
}

class BaseWidget extends InheritedWidget {
  BaseWidget({super.key, required this.child}) : super(child: child);
  final HiveDataStore dataStore = HiveDataStore();
  @override
  final Widget child;

  static BaseWidget of(BuildContext context) {
    final base = context.dependOnInheritedWidgetOfExactType<BaseWidget>();
    if (base != null) {
      return base;
    } else {
      throw StateError('Could not find ancestor widget of type BaseWidget');
    }
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<TodoBloc>(
            create: (context) => TodoBloc(FireStoreService()),
          ),
        ],
        child: ScreenUtilInit(
            designSize: const Size(430, 932),
            builder: (context, _) {
              return ChangeNotifierProvider(
                create: (context) => LocaleModel(),
                child: Consumer<LocaleModel>(
                  builder: (context, localeModel, child) => MaterialApp(
                    title: 'ToDo App',
                    localizationsDelegates:
                        AppLocalizations.localizationsDelegates,
                    supportedLocales: AppLocalizations.supportedLocales,
                    locale: localeModel.locale,
                    debugShowCheckedModeBanner: false,
                    theme: ThemeData(
                      colorScheme:
                          ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                      useMaterial3: true,
                    ),
                    home: const OnboardPage(),
                    routes: {
                      '/home': (context) => const HomePage(),
                    },
                  ),
                ),
              );
            }));
  }
}
