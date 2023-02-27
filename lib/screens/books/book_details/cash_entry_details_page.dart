import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mally_book/screens/books/book_details/book_details_page.dart';
import 'package:mally_book/screens/books/book_details/edit_entry_page.dart';
import 'package:mally_book/screens/books/widgets/confirm_delete_dialog.dart';
import 'package:mally_book/screens/books/widgets/custom_popup_menu_item_widget.dart';

class CashEntryDetailsPage extends StatefulWidget {
  QueryDocumentSnapshot currentEntry;
  CollectionReference cashEntries;
  DocumentReference docRef;
  String bookId;
  CollectionReference bookCollection;
  CashEntryDetailsPage({Key? key, required this.currentEntry, required this.cashEntries, required this.docRef, required this.bookId, required this.bookCollection}) : super(key: key);

  @override
  State<CashEntryDetailsPage> createState() => _CashEntryDetailsPageState();
}

class _CashEntryDetailsPageState extends State<CashEntryDetailsPage> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Entry Details"),
        actions: [
          showDeleteEntryPopUp(
            currentEntry: widget.currentEntry,
            cashEntries: widget.cashEntries,
          )
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Theme.of(context).shadowColor,
                      offset: const Offset(3,3)
                    )
                  ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 5,
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        color: widget.currentEntry["entryType"] == "Add"
                            ? Colors.green.shade700
                            : Colors.red.shade700
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.currentEntry["entryType"] == "Add" ? "Cash In" : "Cash Out",
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400
                                ),
                              ),
                              Text(
                                "On ${widget.currentEntry["entryDate"]}, ${widget.currentEntry["entryTime"]}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15,),
                          Text(
                            widget.currentEntry["amount"],
                            style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                              color: widget.currentEntry["entryType"] == "Add"
                                ? Colors.green.shade700
                                : Colors.red.shade700
                            ),
                          ),
                          const Divider(),
                          Text(
                            widget.currentEntry["remarks"],
                            style: const TextStyle(
                              color: Colors.black54
                            ),
                          ),
                          const SizedBox(height: 20,),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                            decoration: BoxDecoration(
                                color: Colors.pink.shade50,
                                borderRadius: BorderRadius.circular(12)
                            ),
                            child: Text(
                              widget.currentEntry["paymentType"].toString(),
                              style: TextStyle(
                                color: Theme.of(context).primaryColor
                              ),
                            ),
                          ),
                          const Divider(),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (_) => EditEntryPage(
                                  title: "Edit Entry",
                                  doc: widget.currentEntry,
                                  entryType: widget.currentEntry["entryType"],
                                  cashEntries: widget.cashEntries,
                                  bookId: widget.bookId,
                                  bookCollection: widget.bookCollection,
                                ))
                              );
                            },
                            child: SizedBox(
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.edit, size: 23, color: Theme.of(context).primaryColor,),
                                    const SizedBox(width: 15,),
                                    Text(
                                      "EDIT ENTRY",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Theme.of(context).primaryColor
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: screenHeight / 20,),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10,
                        color: Theme.of(context).shadowColor,
                        offset: const Offset(3,3)
                    )
                  ]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Created At",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                    Text(
                      "On ${widget.currentEntry["entryDate"]}, ${widget.currentEntry["entryTime"]}",
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w400
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  showDeleteEntryPopUp({
    required QueryDocumentSnapshot currentEntry,
    required CollectionReference cashEntries
  }) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)
      ),
      icon: const Icon(Icons.more_vert_outlined),
      itemBuilder: (context) {
        return <PopupMenuItem>[
          customPopupMenuItem(
            icon: const Icon(Icons.delete),
            title: "Delete Entry",
            onTap: () {
              confirmDeleteDialog(
                  entryId: currentEntry.id,
                  context: context,
                  cashEntries: cashEntries
              );
            }
          ),
        ];
      }
    );
  }

  Future<void> deleteEntry({required String entryId, required CollectionReference cashEntries}) async {
    try {
      await cashEntries.doc(entryId).delete();
      double? currentBalance;
      int? totalIn;
      int? totalOut;
      await widget.docRef.get().then(
            (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          currentBalance = double.parse("${data["balance"] ?? 0.0}");
          totalIn = int.parse("${data["totalIn"] ?? 0}");
          totalOut = int.parse("${data["totalOut"] ?? 0}");
        },
        onError: (e) => print("Error getting document: $e"),
      );
      if(widget.currentEntry["entryType"] == "Add") {
        await widget.docRef
          .update({
            "balance": currentBalance! - double.parse(widget.currentEntry["amount"]),
            "totalIn": totalIn! - 1
          });
      }
      else {
        await widget.docRef
            .update({
          "balance": currentBalance! + double.parse(widget.currentEntry["amount"]),
          "totalOut": totalOut! - 1
        });
      }
    } catch(e) {
      print(e);
    }
  }

  confirmDeleteDialog({
    required String entryId,
    required BuildContext context,
    required var cashEntries
  }) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            ),
            title: const Text("Delete Entry?"),
            content: const Text("Are you sure, you want to delete the entry?"),
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
                  onPressed: () async {
                    await deleteEntry(entryId: entryId, cashEntries: cashEntries);
                    final docRef = widget.bookCollection.doc(widget.bookId);
                    DocumentSnapshot? book;
                    await docRef.get().then(
                          (DocumentSnapshot doc) {
                        book = doc;
                      },
                      onError: (e) => print("Error getting document: $e"),
                    );
                    Navigator.of(this.context).pop();
                    Navigator.of(this.context).pop();
                    Navigator.of(this.context).pop();
                    Navigator.of(this.context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) =>
                          BookDetailsPage(
                            book: book!,
                            bookCollection: widget.bookCollection
                          )
                      )
                    );

                  },
                  child: const Text("Yes, delete")
              )
            ],
          );
        }
    );
  }
}
