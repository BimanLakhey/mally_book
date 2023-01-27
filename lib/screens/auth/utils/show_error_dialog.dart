import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

showErrorDialog(FirebaseAuthException e, BuildContext context) {
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
