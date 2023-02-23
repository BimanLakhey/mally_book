import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mally_book/firebase/firebase_notification_handler.dart';
import 'screens/splash/splash_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "MallyBook",
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xffa62a6c),
        backgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xffa62a6c),
          centerTitle: true
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
        brightness: Brightness.dark
      ),
      themeMode: ThemeMode.dark,
      home: const SplashPage(),
    );
  }
}



