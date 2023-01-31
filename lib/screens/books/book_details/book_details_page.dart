import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mally_book/screens/books/book_details/cash_entry_details_page.dart';
import 'package:mally_book/screens/books/book_details/cash_in_entry_page.dart';
import 'package:mally_book/screens/books/book_details/widgets/floating_action_widget.dart';

class BookDetailsPage extends StatefulWidget {
  CollectionReference bookCollection;
  DocumentSnapshot book;
  BookDetailsPage({Key? key, required this.book, required this.bookCollection}) : super(key: key);
  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  late DocumentReference _documentReference;
  late CollectionReference _referenceCashEntry;
  late Stream<QuerySnapshot> _cashEntriesStream;
  int totalIn = 0;
  int totalOut = 0;
  double? currentBalance;
  loadBalance() async {
    await _documentReference.get().then(
          (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        currentBalance = double.parse("${data["balance"] ?? 0.0}");
      },
      onError: (e) => print("Error getting document: $e"),
    );
    setState(() {

    });
  }

  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    _documentReference = FirebaseFirestore.instance.collection("book").doc(widget.book.id);
    loadBalance();
    _referenceCashEntry = _documentReference.collection("cashEntries");
    _cashEntriesStream = _referenceCashEntry.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book["name"]),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildSearchEntry(),
            const SizedBox(height: 30,),
            buildBookToNetBalanceWidget(),
            const SizedBox(height: 30,),
            buildCashEntriesListView(),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            customFloatingActionButton(
              buttonName: "CASH IN",
              buttonIcon: Icons.add,
              buttonColor: Colors.green.shade700,
              screenWidth: screenWidth,
              onTap: cashInOnTap
            ),
            const SizedBox(width: 20,),
            customFloatingActionButton(
              buttonName: "CASH OUT",
              buttonIcon: Icons.remove,
              buttonColor: Colors.red.shade700,
              screenWidth: screenWidth,
              onTap: cashOutOnTap

            )
          ],
        ),
      ),
    );
  }

  cashInOnTap() {
    Navigator
      .of(context)
        .pushReplacement(
          MaterialPageRoute(builder: (_) => AddCashPage(
            title: "Add Cash In Entry",
            doc: widget.book,
            bookCollection: widget.bookCollection,
            entryType: "Add"
          ))
        );
  }
  cashOutOnTap() {
    Navigator
        .of(context)
        .pushReplacement(
        MaterialPageRoute(builder: (_) => AddCashPage(
          title: "Add Cash Out Entry",
          doc: widget.book,
          bookCollection: widget.bookCollection,
          entryType: "Remove"

        ))
    );
  }

  Widget buildCashEntriesListView() {
    return StreamBuilder<QuerySnapshot>(
      stream: _cashEntriesStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasError) {
          return Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,));
        }
        else if(snapshot.hasData) {
          QuerySnapshot data = snapshot.data;
          List<QueryDocumentSnapshot> documents = data.docs;
          documents.forEach((element) {
            if(element["entryType"] == "Add") {
              totalIn++;
            }
            else if(element["entryType"] == "Remove") {
              totalOut++;
            }
          });
          List<Map> cashEntries = documents.map((e) => {
            "id": e.id,
            "amount": e["amount"],
            "remarks": e["remarks"],
            "paymentType": e["paymentType"],
            "entryType": e["entryType"],
            "entryDate": e["entryDate"],
            "entryTime": e["entryTime"],
          }).toList();

          return Column(
            children: [
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Text(
                    "Showing ${cashEntries.length} entries",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20,20,20,80),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: cashEntries.length,
                  itemBuilder: (context, index) {
                    Map currentEntry = cashEntries[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) =>
                          CashEntryDetailsPage(currentEntry: documents[index], cashEntries: _referenceCashEntry,))
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 30),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
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
                                        currentEntry["paymentType"].toString()
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
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
                ),
              ),
            ],
          );
        }
        else {
          return Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,));
        }
      }
    );
  }

  buildSearchEntry() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          print("search");
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 10,
                offset: const Offset(3,3)
              )
            ]
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Theme.of(context).primaryColor,),
              const SizedBox(width: 20,),
              const Text(
                "Search by remark or amount",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black54
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildBookToNetBalanceWidget() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.grey.shade300,
            offset: const Offset(5,5)
          )
        ]
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Net Balance",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              ),
              Text(
              "${currentBalance ?? 0.0}",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),
              ),

            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total In (+)",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                ),
              ),
              Text(
                totalIn.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.green.shade700
                ),
              ),

            ],
          ),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Out (-)",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                ),
              ),
              Text(
                totalOut.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.red.shade700
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }

}
