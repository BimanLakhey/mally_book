import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mally_book/screens/auth/login/login_page.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);


  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  final _registerKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Form(
          key: _registerKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset("assets/images/app_logo.png"),
              const SizedBox(height: 50,),
              Text(
                "Register",
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
              const SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Stack(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirm password cannot be empty';
                        }
                        else if(value != passwordController.text) {
                          return "The passwords do not match";
                        }
                        return null;
                      },
                      obscureText: _hideConfirmPassword,
                      controller: confirmPasswordController,
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
                          label: const Text("Confirm Password"),
                          labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor
                          ),
                          hintText: "Re-enter your password"
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 7,
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              _hideConfirmPassword = !_hideConfirmPassword;
                            });
                          },
                          icon: Icon(
                            _hideConfirmPassword
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
                  onPressed: _isLoading ? () {}  : registerUser,
                  child: Center(
                    child: _isLoading
                        ? const SizedBox(
                      height: 21,
                      width: 21,
                      child: CircularProgressIndicator(color: Colors.white,),
                    )
                        : const Text(
                      "Register",
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
                    "Already have an account?",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context)
                          .pushReplacement(
                            MaterialPageRoute(builder: (_) => LoginPage())
                          );
                      },
                      child: Text(
                        "Login",
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
  showErrorDialog(FirebaseAuthException e) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            title: const Text("Error while logging in"),
            titleTextStyle: const TextStyle(
                color: Colors.white
            ),
            content: Text(
              e.message ?? "",
            ),
            contentTextStyle: TextStyle(
                color: Colors.white
            ),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)
                      )
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "OK",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor
                    ),
                  )
              )
            ],
          );
        }
    );
  }

  Future registerUser() async{
    setState(() {
      _isLoading = true;
    });
    if(_registerKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        setState(() {
          _isLoading = false;
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => LoginPage()));
        });
      } on FirebaseAuthException catch(e) {
        showErrorDialog(e);
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
