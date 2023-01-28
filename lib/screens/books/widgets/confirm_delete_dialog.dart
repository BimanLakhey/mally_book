import 'package:flutter/material.dart';

import '../utils/delete_book.dart';

confirmDeleteDialog({
  required String productId,
  required BuildContext context,
  required var book
}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
          ),
          title: const Text("Delete Book?"),
          content: const Text("Are you sure, you want to delete the book?"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("No, don't")
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                    )
                ),
                onPressed: () {
                  deleteBook(productId: productId, book: book);
                  Navigator.pop(context);
                },
                child: const Text("Yes, delete")
            )
          ],
        );
      }
  );
}
