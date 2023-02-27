import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mally_book/screens/books/book_details/book_details_page.dart';
import 'package:mally_book/screens/books/book_details/cash_entry_details_page.dart';

import '../books/book_details/attatched_image_display.dart';

class SearchCashEntriesPage extends StatefulWidget {
  List<Map>? cashEntries;
  CollectionReference book;

  SearchCashEntriesPage({
    Key? key,
    required this.cashEntries,
    required this.book

  }) : super(key: key);

  @override
  State<SearchCashEntriesPage> createState() => _SearchCashEntriesPageState();
}

class _SearchCashEntriesPageState extends State<SearchCashEntriesPage> {
  TextEditingController searchController = TextEditingController();
  List<Map> searchedEntries = [];


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
      backgroundColor: Theme.of(context).backgroundColor,
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
                      child: Icon(Icons.arrow_back, color: Theme.of(context).splashColor,)
                  ),
                  const SizedBox(width: 20,),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Search by remark or amount",
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).splashColor,
                                width: 2
                            )
                        ),
                        suffixIcon: Icon(Icons.search, color: Theme.of(context).splashColor,),
                      ),
                      onSubmitted: (_) {
                        searchedEntries.clear();
                        searchedEntries = [];
                        for (var element in widget.cashEntries!) {
                          if(element["amount"].toString().contains(searchController.text) || element["remarks"].toString().contains(searchController.text)) {
                            searchedEntries.add(element);
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
                    itemCount:searchedEntries.isNotEmpty ? searchedEntries.length : widget.cashEntries!.length,
                    itemBuilder: (context, index) {
                      Map currentEntry;
                      if(searchedEntries.isNotEmpty) {
                        currentEntry
                        =  searchedEntries[index];
                      }
                      else {
                        currentEntry
                        =  widget.cashEntries![index];
                      }
                      return GestureDetector(
                        onTap: () {
                          // Navigator.of(context).push(
                          //     MaterialPageRoute(builder: (_) =>
                          //         CashEntryDetailsPage(
                          //             currentEntry: documents[index],
                          //             cashEntries: widget.cashEntries,
                          //             docRef: _documentReference,
                          //             bookId: widget.book.id,
                          //             bookCollection: widget.bookCollection
                          //         ))
                          // );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 30),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
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
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                        decoration: BoxDecoration(
                                            color: Colors.pink.shade50,
                                            borderRadius: BorderRadius.circular(12)
                                        ),
                                        child: Text(
                                          currentEntry["paymentType"].toString(),
                                          style: TextStyle(
                                              color: Theme.of(context).primaryColor
                                          ),
                                        ),
                                      ),
                                      SizedBox(height:currentEntry["remarks"] != "" ? 10 : 0),
                                      SizedBox(
                                        width: 70,
                                        height: 20,
                                        child: Text(
                                          currentEntry["remarks"],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height:currentEntry["imageUrl"] != " " ? 10 : 0),
                                      currentEntry["imageUrl"] != " " ? GestureDetector(
                                          onTap: () => Navigator
                                              .of(context)
                                              .push(
                                            MaterialPageRoute(builder: (_) => AttachedImageDisplay(
                                              imageUrl: currentEntry["imageUrl"],
                                            )),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(Icons.attach_file_outlined, color: Theme.of(context).primaryColor,),
                                              Text(
                                                "image",
                                                style: TextStyle(
                                                    color: Theme.of(context).primaryColor,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    decoration: TextDecoration.underline
                                                ),
                                              ),
                                            ],
                                          )
                                      ) : const SizedBox(),
                                    ],
                                  ),
                                  Text(
                                    currentEntry["amount"],
                                    style: TextStyle(
                                        color: currentEntry["entryType"] == "Add" ? Colors.green.shade700 : Colors.red.shade700,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 20.0, bottom: 10),
                                child: Divider(),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Entered at ",
                                        style: TextStyle(
                                            color: Colors.green.shade700,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500
                                        ),
                                      ),
                                      Text(
                                        "${currentEntry["entryTime"]}",
                                        style: const TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w500
                                        ),
                                      )
                                    ],
                                  ),
                                  Text(
                                    currentEntry["entryDate"],
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500
                                    ),
                                  )

                                ],
                              )

                            ],
                          ),
                        ),
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
