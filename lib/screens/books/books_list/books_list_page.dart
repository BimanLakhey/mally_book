import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mally_book/screens/books/widgets/show_popup_widget.dart';
import 'package:mally_book/screens/search_book/search_book_page.dart';
import '../book_details/book_details_page.dart';
import '../widgets/add_book_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

class BooksListPage extends StatefulWidget {
  const BooksListPage({Key? key}) : super(key: key);

  @override
  State<BooksListPage> createState() => _BooksListPageState();
}

class _BooksListPageState extends State<BooksListPage> {
  final currentUser = FirebaseAuth.instance;
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

  List<BookExample> bookExamples = [
    BookExample(bookName: "January Expenses"),
    BookExample(bookName: "Daily Expenses"),
    BookExample(bookName: "Miscellaneous"),
    BookExample(bookName: "Loans"),
  ];
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
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth *  0.05, vertical: screenHeight * 0.05),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 30),
          child: StreamBuilder(
            stream: _book.where("uId", isEqualTo: currentUser.currentUser!.uid).snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if(streamSnapshot.hasData) {
                if (streamSnapshot.data!.size > 0) {
                  return _buildBookListWidget(
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    streamSnapshot: streamSnapshot
                  );
                } else {
                  return _buildAddFirstBookWidget(screenHeight: screenHeight);
                }
              }
              else {
                return Center(
                  child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),
                );
              }
            },
          ),
        ),
      ),

      floatingActionButton: GestureDetector(
        onTap: () {
          addBookBottomSheet(
            context: context,
            addBookFormKey: _addBookFormKey,
            addBookController: addBookController,
            addBookNode: addBookNode,
            book: _book,
            bookExamples: bookExamples
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

  _buildBookListWidget({
    required double screenWidth,
    required double screenHeight,
    required AsyncSnapshot streamSnapshot,

  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Your Books",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) =>
                          SearchBookPage(
                            renameBookController: renameBookController,
                            renameBookFormKey: _renameBookFormKey,
                            renameBookNode: renameBookNode,
                            book: _book,
                            books: streamSnapshot.data!.docs,
                          )));
                },
                icon: Icon(
                  Icons.search,
                  color: Theme
                      .of(context)
                      .primaryColor,
                )
            )
          ],
        ),
        SizedBox(height: screenHeight * 0.03,),
        ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: streamSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot
              = streamSnapshot.data!.docs[index];
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator
                          .of(context)
                          .push(MaterialPageRoute(
                          builder: (_) =>
                              BookDetailsPage(
                                bookCollection: _book,
                                book: documentSnapshot,))
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    color: Colors.cyan.shade50,
                                    borderRadius: BorderRadius
                                        .circular(100)
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Icon(
                                  Icons.book, color: Theme
                                    .of(context)
                                    .primaryColor,)
                            ),
                            SizedBox(width: screenWidth * 0.07,),
                            Column(
                              children: [
                                Text(
                                  documentSnapshot["name"],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: screenWidth / 21
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "${documentSnapshot["balance"]}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: documentSnapshot["balance"] < 0 ? Colors.red.shade700 : Colors.green.shade700
                              ),
                            ),
                            showPopUp(
                                documentSnapshot: documentSnapshot,
                                renameBookFormKey: _renameBookFormKey,
                                renameBookController: renameBookController,
                                renameBookNode: renameBookNode,
                                book: _book
                            )
                          ],
                        ),

                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: Divider(),
                  )
                ],
              );
            }
        ),
        SizedBox(height: screenHeight * 0.03,),
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 25, horizontal: 20,),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).shadowColor,
                    blurRadius: 10,
                    offset: const Offset(3, 3)
                )
              ]
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Add New Book",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01,),
                      const Text(
                        "Click to quickly add books for",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: Icon(Icons.book, color: Theme
                          .of(context)
                          .primaryColor,),),
                  )
                ],
              ),
              SizedBox(height: screenHeight * 0.03,),
              GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10
                  ),
                  physics: const BouncingScrollPhysics(),
                  itemCount: bookExamples.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        TextEditingController addBookExampleController = TextEditingController(
                            text: bookExamples[index].bookName);
                        addBookBottomSheet(
                            context: context,
                            addBookFormKey: _addBookFormKey,
                            addBookController: addBookExampleController,
                            addBookNode: addBookNode,
                            book: _book,
                            bookExamples: bookExamples
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                30),
                            border: Border.all(color: Theme
                                .of(context)
                                .primaryColor),
                            color: Colors.pink.shade50
                        ),
                        child: Center(
                          child: Text(
                            bookExamples[index].bookName,
                            style: TextStyle(
                                color: Theme
                                    .of(context)
                                    .primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 14
                            ),
                          ),
                        ),
                      ),
                    );
                  }
              )
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.04,),
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 25, horizontal: 20,),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).shadowColor,
                    blurRadius: 10,
                    offset: const Offset(3, 3)
                )
              ]
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.pink.shade50,
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(Icons.phone, color: Theme
                    .of(context)
                    .primaryColor,),
              ),
              SizedBox(width: screenWidth * 0.03,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Need help in business setup?",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      color: Colors.black
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01,),
                  const Text(
                    "Our support team will help you",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: Colors.black54
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02,),
                  InkWell(
                    onTap: () async {
                      if (await canLaunchUrl(
                          Uri(scheme: "tel",
                              path: "9819016941"))) {
                        await launchUrl(Uri(scheme: "tel",
                            path: "9819016941"));
                      } else {
                        throw 'Could not launch';
                      }
                    },
                    child: Text(
                      "Contact Us",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Theme
                              .of(context)
                              .primaryColor
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );

  }

  _buildAddFirstBookWidget({double? screenHeight}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Center(
        child: Column(
          children: [
            SizedBox(height: screenHeight! * 0.2,),
            Icon(
              Icons.book_rounded,
              size: 60,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: screenHeight! * 0.03,),
            const Text(
              "Add your first book to get started",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight! * 0.03,),
            const Text(
              "Setup your business by adding \"new books\"",
              style: TextStyle(
                fontSize: 17,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight! * 0.03,),
            InkWell(
              onTap: () {
                addBookBottomSheet(
                    context: context,
                    addBookFormKey: _addBookFormKey,
                    addBookController: addBookController,
                    addBookNode: addBookNode,
                    book: _book,
                    bookExamples: bookExamples
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.book, size: 30, color: Colors.white,),
                      SizedBox(width: 20,),
                      Text(
                        "ADD FIRST BOOK",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.white
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}

class BookExample {
  String bookName;
  BookExample({
    required this.bookName
  });
}