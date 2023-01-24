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
            Text(
              "Your Books",
              style: TextStyle(
                  fontSize: screenWidth / 20,
                  color: Colors.black54
              ),
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
                          title: Text(documentSnapshot["name"]),
                          leading: Container(
                              decoration: BoxDecoration(
                                  color: Colors.cyan.shade50,
                                  borderRadius: BorderRadius.circular(100)
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Icon(Icons.book, color: Theme.of(context).primaryColor,)
                          ),
                          trailing: showPopUp()

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
          customAddBookBottomSheet();
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

  showPopUp() {
    return PopupMenuButton(
      onSelected: (item) {
        //TODO: add menu item on select functionality
      },
      icon: const Icon(Icons.more_vert_outlined),
      itemBuilder: (context) {
        return <PopupMenuItem>[
          customPopupMenuItem(
            icon: const Icon(CupertinoIcons.pen),
            title: "Rename",
            onTap: () {}
          ),
          customPopupMenuItem(
            icon: const Icon(Icons.delete),
            title: "Delete Book",
            onTap: () {}
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
        onTap: onTap(),
      )
    );
  }

  customAddBookBottomSheet() {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Container(
              height: 150,
            );
          }
        );
      },
    );
  }
}