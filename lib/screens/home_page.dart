import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference _book = FirebaseFirestore.instance.collection("book");
  TextEditingController renameBookController = TextEditingController();
  FocusNode renameBookNode = FocusNode();
  final _renameBookFormKey = GlobalKey<FormState>();
  TextEditingController addBookController = TextEditingController();
  FocusNode addBookNode = FocusNode();
  final _addBookFormKey = GlobalKey<FormState>();


  var popUpMenuItems = {
    "Rename",
    "Delete Book",
  };
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mally Book"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth *  0.05, vertical: screenHeight * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Your Books",
                  style: TextStyle(
                      fontSize: screenWidth / 23,
                      color: Colors.black54
                  ),
                ),
                IconButton(
                  onPressed: () {

                  },
                  icon: Icon(
                    Icons.search,
                    color: Theme.of(context).primaryColor,
                  )
                )
              ],
            ),
            SizedBox(height: screenHeight * 0.03,),
            StreamBuilder(
              stream: _book.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if(streamSnapshot.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot
                        = streamSnapshot.data!.docs[index];
                        return ListTile(
                          contentPadding: index == streamSnapshot.data!.docs.length - 1
                              ? EdgeInsets.zero
                              : const EdgeInsets.only(bottom: 20),
                          title: Text(
                            documentSnapshot["name"],
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth / 21
                            ),
                          ),
                          leading: Container(
                              decoration: BoxDecoration(
                                  color: Colors.cyan.shade50,
                                  borderRadius: BorderRadius.circular(100)
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Icon(Icons.book, color: Theme.of(context).primaryColor,)
                          ),
                          trailing: showPopUp(documentSnapshot: documentSnapshot)

                        );

                      }
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),

      floatingActionButton: GestureDetector(
        onTap: () {
          addBookBottomSheet();
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Theme.of(context).primaryColor,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.add,
                color: Colors.white,
              ),
              SizedBox(width: screenWidth / 30,),
              const Text(
                "ADD NEW BOOK",
                style: TextStyle(
                  color: Colors.white
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  showPopUp({required DocumentSnapshot documentSnapshot}) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)
      ),
      icon: const Icon(Icons.more_vert_outlined),
      itemBuilder: (context) {
        return <PopupMenuItem>[
          customPopupMenuItem(
            icon: const Icon(CupertinoIcons.pen),
            title: "Rename",
            onTap: ()  {
              bookBottomSheet(documentSnapshot: documentSnapshot);
            }
          ),
          customPopupMenuItem(
            icon: const Icon(Icons.delete),
            title: "Delete Book",
            onTap: () {
              confirmDeleteDialog(productId: documentSnapshot.id);
            }
          ),
        ];
      }
    );
  }

  customPopupMenuItem({
    required Icon icon,
    required String title,
    required var onTap
  }) {
    return PopupMenuItem(
      child: ListTile(
        leading: icon,
        title: Text(title),
        onTap: onTap,
      )
    );
  }

  addBookBottomSheet() {
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
                  key: _addBookFormKey,
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
                            if(_addBookFormKey.currentState!.validate()) {
                              _createBook();
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
  bookBottomSheet({required DocumentSnapshot documentSnapshot}) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {

          },
          builder: (context) {
            return SizedBox(
              // height: 200,
              child: Form(
                key: _renameBookFormKey,
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
                          if(_renameBookFormKey.currentState!.validate()) {
                            _renameBook(documentSnapshot);
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
  confirmDeleteDialog({required String productId}) {
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
                _deleteBook(productId: productId);
                Navigator.pop(context);
              },
              child: const Text("Yes, delete")
            )
          ],
        );
      }
    );
  }

  Future<void> _renameBook([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null && renameBookController.text.isNotEmpty) {
      await _book
          .doc(documentSnapshot!.id)
          .update({"name": renameBookController.text});
      renameBookController.text = "";
    }
  }
  Future<void> _createBook() async {
    if(addBookController.text.isNotEmpty) {
      await _book.add({"name": addBookController.text});
      addBookController.text = "";
    }
  }
  Future<void> _deleteBook({required String productId}) async {
    await _book.doc(productId).delete();
  }

}