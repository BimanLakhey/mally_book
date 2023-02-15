import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mally_book/screens/books/book_details/book_details_page.dart';
import 'package:mally_book/screens/books/widgets/show_popup_widget.dart';

class SearchBookScreen extends StatefulWidget {
  TextEditingController renameBookController;
  FocusNode renameBookNode;
  GlobalKey<FormState> renameBookFormKey;
  List<QueryDocumentSnapshot> books;
  CollectionReference book;
  SearchBookScreen({
    Key? key,
    required this.renameBookController,
    required this.renameBookNode,
    required this.renameBookFormKey,
    required this.books,
    required this.book

  }) : super(key: key);

  @override
  State<SearchBookScreen> createState() => _SearchBookScreenState();
}

class _SearchBookScreenState extends State<SearchBookScreen> {
  TextEditingController searchController = TextEditingController();
  List<QueryDocumentSnapshot> searchedBooks = [];


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
            SizedBox(height: screenHeight * 0.025,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor,)
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
                        ),
                        suffixIcon: Icon(Icons.search, color: Theme.of(context).primaryColor,),
                      ),
                      onSubmitted: (_) {
                        searchedBooks.clear();
                        searchedBooks = [];
                        for (var element in widget.books) {
                          if(element["name"].toString().contains(searchController.text)) {
                            searchedBooks.add(element);
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.05,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount:searchedBooks.isNotEmpty ? searchedBooks.length : widget.books.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot;
                  if(searchedBooks.isNotEmpty) {
                    documentSnapshot
                    =  searchedBooks[index];
                  }
                  else {
                    documentSnapshot
                    =  widget.books[index];
                  }

                  return ListTile(
                      onTap: () {
                        Navigator
                            .of(context)
                            .push(MaterialPageRoute(
                            builder: (_) => BookDetailsPage(book: documentSnapshot, bookCollection: widget.book,))
                        );
                      },
                    contentPadding: index == widget.books.length - 1
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
                      book: widget.book
                    )
                  );
                }
              )
            ),
          ],
        ),
      ),
    );
  }
}
