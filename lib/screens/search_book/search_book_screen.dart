import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mally_book/screens/books/widgets/show_popup_widget.dart';

class SearchBookScreen extends StatefulWidget {
  TextEditingController renameBookController;
  FocusNode renameBookNode;
  GlobalKey<FormState> renameBookFormKey;
  SearchBookScreen({
    Key? key,
    required this.renameBookController,
    required this.renameBookNode,
    required this.renameBookFormKey

  }) : super(key: key);

  @override
  State<SearchBookScreen> createState() => _SearchBookScreenState();
}

class _SearchBookScreenState extends State<SearchBookScreen> {
  TextEditingController searchController = TextEditingController();
  final CollectionReference _book = FirebaseFirestore.instance.collection("book");


  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back)
                  ),
                  const SizedBox(width: 20,),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Search by book name",
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2
                          )
                        )
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: StreamBuilder(
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
                              renameBookFormKey: widget.renameBookFormKey,
                              renameBookNode: widget.renameBookNode,
                              renameBookController: widget.renameBookController,
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
            ),

          ],
        ),
      ),
    );
  }
}
