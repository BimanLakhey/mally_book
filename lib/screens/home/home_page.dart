import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mally_book/screens/home/widgets/add_book_bottom_sheet.dart';
import 'package:mally_book/screens/home/widgets/show_popup_widget.dart';
import 'package:mally_book/screens/search_book/search_book_screen.dart';

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
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text("MallyBook"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            onPressed: () => showLogoutDialog(),
            icon: const Icon(Icons.logout_outlined)
          )
        ],
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
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => SearchBookScreen(
                      renameBookController: renameBookController,
                      renameBookFormKey: _renameBookFormKey,
                      renameBookNode: renameBookNode,
                    )));
                  } ,
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
                          trailing: showPopUp(
                            documentSnapshot: documentSnapshot,
                            renameBookFormKey: _renameBookFormKey,
                            renameBookController: renameBookController,
                            renameBookNode: renameBookNode,
                            book: _book
                          )

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
          addBookBottomSheet(
            context: context,
            addBookFormKey: _addBookFormKey,
            addBookController: addBookController,
            addBookNode: addBookNode,
            book: _book
          );
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

  showLogoutDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Text("Logout"),
            titleTextStyle: TextStyle(
                color: Theme.of(context).primaryColor
            ),
            content: const Text(
              "Are you sure that you want to logout?",
            ),
            contentTextStyle: TextStyle(
                color: Theme.of(context).primaryColor
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor
                  ),
                )
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                    )
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  await FirebaseAuth.instance.signOut();
                },
                child: const Text(
                  "Yes, logout",
                  style: TextStyle(
                      color: Colors.white
                  ),
                )
              )
            ],
          );
        }
    );
  }
}