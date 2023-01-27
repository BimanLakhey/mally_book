import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash/splash_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        primaryColor: Color(0xffa62a6c),
        backgroundColor: Color(0xffffe0ec)
        // accentColor: Colors.pinkAccent
      ),
      home: const SplashPage(),
    );
  }
}



