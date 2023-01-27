import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mally_book/screens/auth/login/login_page.dart';
import 'package:mally_book/screens/home/home_page.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if(!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        Duration(seconds: 3),
        (_) => checkEmailVerified()
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
  Future sendVerificationEmail() async {
    try{
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() {
        canResendEmail = false;
      });
      await Future.delayed(Duration(seconds: 10));
      setState(() {
        canResendEmail = true;
      });
    }
    catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()))
      );
    }
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if(isEmailVerified) timer?.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return isEmailVerified
      ? HomePage()
      : Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Verify your email"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 200,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "A verification email has been sent to your email",
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).primaryColor
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30)
                ),
                onPressed: canResendEmail ? sendVerificationEmail : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please wait 10 seconds before resending"))
                  );
                },
                child: const Text(
                  "Resend email",
                  style: TextStyle(
                    color: Colors.white
                  ),
                )

              ),
              const SizedBox(height: 20,),
              TextButton(
                onPressed: () => FirebaseAuth.instance.signOut(),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor
                  ),
                )
              )
            ],
          ),
        ),
      );
  }

}
