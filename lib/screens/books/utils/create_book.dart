import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

Future<void> createBook({
  required TextEditingController addBookController,
  required var book,
}) async {
  if(addBookController.text.isNotEmpty) {
    await book.add({
      "name": addBookController.text,
      "uId": FirebaseAuth.instance.currentUser!.uid
    });
    addBookController.text = "";
  }
}