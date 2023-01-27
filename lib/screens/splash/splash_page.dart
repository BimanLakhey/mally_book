import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mally_book/screens/auth/login/login_page.dart';
import 'package:mally_book/screens/auth/verify_email/verify_email_page.dart';
import 'package:mally_book/screens/home/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    Timer(Duration(seconds: 3),
      ()=>Navigator.pushReplacement(context,
        MaterialPageRoute(builder:
          (context) => StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                return const SplashPage();
              }
              else if(snapshot.hasError) {
                return const ScaffoldMessenger(
                  child: SnackBar(
                    content: Text("Something went wrong"),
                  )
                );
              }
              else if(snapshot.hasData) {
                return VerifyEmailPage();
              }
              else {
                return LoginPage();
              }
            }
          )
        )
      )
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              "assets/images/app_logo.png",
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
          ),
          const CircularProgressIndicator(color: Colors.white, strokeWidth: 5,),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          const Text(
            "Developed by Biman Lakhey",
            style: TextStyle(
              color: Colors.white54,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic
            ),
          )
        ],
      ),
    );
  }
}
