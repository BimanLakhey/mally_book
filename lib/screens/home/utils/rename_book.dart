import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> renameBook({
  required DocumentSnapshot documentSnapshot,
  required TextEditingController renameBookController,
  required var book
}) async {
  if (renameBookController.text.isNotEmpty) {
    await book
        .doc(documentSnapshot!.id)
        .update({"name": renameBookController.text});
    renameBookController.text = "";
  }
}