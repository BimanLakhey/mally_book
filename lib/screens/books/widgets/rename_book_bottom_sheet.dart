import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utils/rename_book.dart';

bookBottomSheet({
  required DocumentSnapshot documentSnapshot,
  required BuildContext context,
  required GlobalKey<FormState> renameBookFormKey,
  required TextEditingController renameBookController,
  required FocusNode renameBookNode,
  required var book,

}) {
  return showModalBottomSheet(
    enableDrag: false,
    context: context,
    builder: (context) {
      return BottomSheet(
          onClosing: () {

          },
          builder: (context) {
            return SizedBox(
              // height: 200,
              child: Form(
                key: renameBookFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close)
                        ),
                        const Text(
                          "Rename cashbook",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18
                          ),
                        )
                      ],
                    ),
                    const Divider(thickness: 2,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                      child: TextFormField(
                        controller: renameBookController,
                        focusNode: renameBookNode,
                        autofocus: true,
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return "The book name cannot be empty";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            label: const Text("Book Name"),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2
                              ),

                            ),
                            labelStyle: TextStyle(
                                color: Theme.of(context).primaryColor
                            ),
                            hintText: "Enter book name",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)
                            )
                        ),
                      ),
                    ),
                    const Divider(thickness: 2,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                      child: GestureDetector(
                        onTap: () {
                          renameBookNode.unfocus();
                          if(renameBookFormKey.currentState!.validate()) {
                            renameBook(
                              documentSnapshot: documentSnapshot,
                              renameBookController: renameBookController,
                              book: book
                            );
                            Navigator.of(context).pop();
                          }

                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(12)
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 150
                          ),
                          child: const Center(
                            child: Text(
                              "SAVE",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)),
                  ],
                ),
              ),
            );
          }
      );
    },
  );
}
