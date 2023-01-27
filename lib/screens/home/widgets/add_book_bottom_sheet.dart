import 'package:flutter/material.dart';
import 'package:mally_book/screens/home/utils/create_book.dart';

addBookBottomSheet({
  required BuildContext context,
  required GlobalKey<FormState> addBookFormKey,
  required TextEditingController addBookController,
  required FocusNode addBookNode,
  required var book
}) {

  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0)
        )
    ),
    builder: (context) {
      return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return SizedBox(
              // height: 200,
              child: Form(
                key: addBookFormKey,
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
                          "Add New Book",
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
                        controller: addBookController,
                        focusNode: addBookNode,
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
                          addBookNode.unfocus();
                          if(addBookFormKey.currentState!.validate()) {
                            createBook(
                              addBookController: addBookController,
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
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 10,),
                                Text(
                                  "ADD NEW BOOK",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                              ],
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