import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mally_book/screens/auth/register/register_page.dart';
import 'package:mally_book/screens/auth/reset_password/reset_password_page.dart';
import 'package:mally_book/screens/auth/utils/show_error_dialog.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);


  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  bool _hidePassword = true;
  final _loginKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Form(
          key: _loginKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset("assets/images/app_logo.png"),
              const SizedBox(height: 50,),
              Text(
                "Login",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor
                ),
              ),
              const SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email cannot be empty';
                    }
                    return null;
                  },
                  controller: emailController,
                  focusNode: emailFocus,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2
                        )
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2
                        )
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2
                      )
                    ),
                    label: const Text("Email"),
                    labelStyle: TextStyle(
                      color: Theme.of(context).primaryColor
                    ),
                    hintText: "Enter your email",
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Stack(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password cannot be empty';
                        }
                        return null;
                      },
                      obscureText: _hidePassword,
                      controller: passwordController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2
                          )
                        ),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2
                            )
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2
                            )
                        ),
                        label: const Text("Password"),
                        labelStyle: TextStyle(
                            color: Theme.of(context).primaryColor
                        ),
                        hintText: "Enter your password"
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 7,
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              _hidePassword = !_hidePassword;
                            });
                          },
                          icon: Icon(
                            _hidePassword
                              ? CupertinoIcons.eye_slash_fill
                              : CupertinoIcons.eye_solid,
                            color: Theme.of(context).primaryColor,
                          )
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 20)
                  ),
                  onPressed: _isLoading ? () {}  : loginUser,
                  child: Center(
                    child: _isLoading
                      ? const SizedBox(
                        height: 21,
                        width: 21,
                        child: CircularProgressIndicator(color: Colors.white,),
                      )
                      : const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 18
                        ),
                      ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                      Navigator.of(context)
                          .pushReplacement(MaterialPageRoute(builder: (_) => RegisterPage())),
                    child: Text(
                      "Register now",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        decoration: TextDecoration.underline
                      ),
                    )
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Forgot password? ",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                  TextButton(
                      onPressed: () =>
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (_) => ResetPasswordPage())),
                      child: Text(
                        "Reset now",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.underline
                        ),
                      )
                  )
                ],
              )

            ],
          ),
        ),
      ),
    );
  }

  Future loginUser() async{
    setState(() {
      _isLoading = true;
    });
    if(_loginKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      } on FirebaseAuthException catch(e) {
        showErrorDialog(e, context);
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
