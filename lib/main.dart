import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mally_book/configs/app_config.dart';
import 'package:mally_book/firebase/firebase_notification_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/splash/splash_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  prefs = await SharedPreferences.getInstance();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    themeSettings.addListener(() {
      setState(() {
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "MallyBook",
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xffa62a6c),
        backgroundColor: Colors.white,
        canvasColor: const Color(0xffa62a6c),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xffa62a6c),
          centerTitle: true
        ),
        splashColor: const Color(0xffa62a6c),
        shadowColor: Colors.grey.shade300,
        textTheme: const TextTheme(
          titleSmall: TextStyle(
            color: Colors.black54,
            fontSize: 15
          )
        ),
        timePickerTheme: TimePickerTheme.of(context).copyWith(
          hourMinuteTextColor: const Color(0xffa62a6c),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          dayPeriodTextColor: const Color(0xffa62a6c),
          dialHandColor: const Color(0xffa62a6c),
          dialBackgroundColor: const Color(0xffffe0ec)
        ),
        // accentColor: Colors.pinkAccent
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xff3b202f),
        canvasColor: Colors.white,
        splashColor: Colors.pink.shade400,
        backgroundColor: Colors.grey.shade800,
        shadowColor: Colors.black26,
        appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xff3b202f),
            centerTitle: true
        ),
        textTheme: const TextTheme(
          titleSmall: TextStyle(
              color: Colors.white,
              fontSize: 15
          )
        ),
      ),
      themeMode: themeSettings.currentTheme(),
      home: const SplashPage(),
    );
  }
}



