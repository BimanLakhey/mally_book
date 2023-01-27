import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mally_book/screens/auth/utils/show_error_dialog.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController emailController = TextEditingController();
  FocusNode emailNode = FocusNode();
  final _resetPasswordKey = GlobalKey<FormState>();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: const Text("Reset Password"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: _resetPasswordKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 250,),
                  Text(
                    "You will receive an email verification link in the email below",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20
                    ),
                  ),
                  const SizedBox(height: 30,),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email cannot be empty';
                      }
                      return null;
                    },
                    controller: emailController,
                    focusNode: emailNode,
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
                  const SizedBox(height: 40,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 20)
                    ),
                    onPressed: _isLoading ? () {}  : resetPassword,
                    child: Center(
                      child: _isLoading
                        ? const SizedBox(
                          height: 21,
                          width: 21,
                          child: CircularProgressIndicator(color: Colors.white,),
                        )
                        : const Text(
                          "Reset password",
                          style: TextStyle(
                              fontSize: 18
                          ),
                        ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future resetPassword() async {
    if(_resetPasswordKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password reset email has been sent!")));
      }
      on FirebaseAuthException catch(e) {
        setState(() {
          _isLoading = false;
        });
        showErrorDialog(e, context);

      }
    }
  }
}
