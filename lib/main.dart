// ignore_for_file: non_constant_identifier_names, unused_element, avoid_print

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gdsc_app/InternetConnection/chechConnection.dart';
import 'package:gdsc_app/InternetConnection/noInternetConnection.dart';
import 'package:gdsc_app/UI/Authentication/Login/login_page.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import 'Controller/app_controller.dart';
import 'UI/Authentication/user_logic.dart';
import 'UI/Home/Home.dart';

String userID = '';
User? the_User;
String userName = '';
String userEmail = '';
String? token;
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

final controller = Get.put(AppController());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await FirebaseMessaging.instance.subscribeToTopic("Name");
  ConnectionStatusSingleton connectionStatus =
      ConnectionStatusSingleton.getInstance();
  connectionStatus.initialize();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(mainChannel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
 
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  Get.lazyPut<AppController>(() => AppController(), fenix: true);



  runApp(MyApp());
}

const AndroidNotificationChannel mainChannel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'this channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final controller = Get.put(AppController());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: Authentication.initializeFirebase(context: context),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return const NoInternetScreen();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          User? user = FirebaseAuth.instance.currentUser;

          if (user != null) {
            return GetMaterialApp(
              onUnknownRoute: (RouteSettings settings) {
                return MaterialPageRoute(
                    builder: (context) => Scaffold(
                          body: Center(
                            child:
                                Text('No route defined for ${settings.name}'),
                          ),
                        ));
              },
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: const Home(),
              color: Colors.blue,
            );
          } else {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: const Login(),
              color: Colors.blue,
            );
          }
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Container();
      },
    );
  }
}

// how to pick image in flutter web?



