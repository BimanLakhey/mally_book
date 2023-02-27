import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mally_book/screens/books/book_details/book_details_page.dart';
import 'package:mally_book/screens/books/book_details/widgets/cash_add_floating_action_widget.dart';


class EditEntryPage extends StatefulWidget {
  String title;
  String entryType;
  DocumentSnapshot doc;
  String bookId;
  CollectionReference cashEntries;
  CollectionReference bookCollection;

  EditEntryPage({
    Key? key,
    required this.title,
    required this.doc,
    required this.entryType,
    required this.cashEntries,
    required this.bookId,
    required this.bookCollection,
  }) : super(key: key) {
    _documentReference = FirebaseFirestore.instance.collection("book").doc(bookId);
  }

  late DocumentReference _documentReference;

  @override
  State<EditEntryPage> createState() => _EditEntryPageState();
}

class _EditEntryPageState extends State<EditEntryPage> {

  var selectedDate;
  var selectedTimeOfDay;
  var formatter = DateFormat('dd-MM-yyyy');
  bool isCash = true;
  bool isOnline = false;
  String paymentType = "Cash";

  TextEditingController amountController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  final _addCashFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    amountController.text = widget.doc["amount"];
    remarkController.text = widget.doc["remarks"];
    paymentType = widget.doc["paymentType"];
    selectedDate = widget.doc["entryDate"];
    selectedTimeOfDay = widget.doc["entryTime"];
    if(paymentType.toLowerCase() == "cash") {
      isCash = true;
      isOnline = false;
    } else {
      isCash = false;
      isOnline = true;
    }
    setState(() {

    });
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
    amountController.dispose();
    remarkController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _addCashFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1000),
                          lastDate: DateTime(DateTime.now().year + 100)
                        );
                        setState(() {
                          selectedDate = formatter.format(selectedDate);
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_month_outlined,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 10,),
                          Text(
                            selectedDate != null ? selectedDate.toString() : formatter.format(DateTime.now()).toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Icon(
                            Icons.arrow_drop_down_sharp,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        selectedTimeOfDay = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        setState(() {

                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.clock_fill,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 10,),
                          Text(
                            selectedTimeOfDay != null ? selectedTimeOfDay.toString() : TimeOfDay.now().format(context),
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Icon(
                            Icons.arrow_drop_down_sharp,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50,),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Amount cannot be empty';
                    }
                    return null;
                  },
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                              color: Colors.red,
                              width: 2
                          )
                      ),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                              color: Colors.red,
                              width: 2
                          )
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2
                          )
                      ),
                      label: const Text("Amount"),
                      labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor
                      ),
                      hintText: "Enter your amount"
                  ),
                ),
                const SizedBox(height: 40,),
                TextField(
                  // controller: amountController,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2
                          )
                      ),
                      label: const Text("Contact"),
                      labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor
                      ),
                      hintText: "Enter your contact person"
                  ),
                ),
                const SizedBox(height: 40,),
                TextFormField(
                  controller: remarkController,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2
                          )
                      ),
                      label: const Text("Remarks"),
                      labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor
                      ),
                      hintText: "Enter your remarks"
                  ),
                ),
                const SizedBox(height: 40,),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1,),
                      borderRadius: BorderRadius.circular(30)
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 8
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.camera_alt_rounded, color: Theme.of(context).primaryColor,),
                        const SizedBox(width: 10,),
                        Text(
                          "Attach Image",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40,),
                TextFormField(
                  // controller: remarkController,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2
                          )
                      ),
                      label: const Text("Category"),
                      labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor
                      ),
                      hintText: "Enter your category"
                  ),
                ),
                const SizedBox(height: 40,),
                Text(
                  "Payment Mode",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                  ),
                ),
                const SizedBox(height: 30,),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          paymentType = "Cash";
                          isCash = true;
                          isOnline = false;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: isCash ? Theme.of(context).primaryColor : Colors.black12
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        child: Text("Cash", style: TextStyle(color:isCash ? Colors.white : Colors.black),),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          paymentType = "Online";
                          isCash = false;
                          isOnline = true;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: isOnline ? Theme.of(context).primaryColor : Colors.black12
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        child: Text("Online", style: TextStyle(color:isOnline ? Colors.white : Colors.black),),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: cashAddFloatingActionWidget(
          buttonName: "SAVE",
          buttonColor: Theme.of(context).primaryColor,
          isAddNew: false,
          screenWidth: screenWidth,
          context: context,
          onTap: cashEntryEdit
        ),
      ),
    );
  }

  cashEntryEdit() async {
    try{
      final docRef = widget.cashEntries.doc(widget.doc.id);
      await docRef.update({
        "amount": amountController.text.trim(),
        "remarks": remarkController.text.trim(),
        "paymentType": paymentType.trim(),
        "entryType": widget.entryType.trim(),
        "entryDate": selectedDate == null
            ? formatter.format(DateTime.now()).toString()
            : selectedDate.toString(),
        "entryTime": selectedTimeOfDay == null ? TimeOfDay.now().format(context) : selectedTimeOfDay.toString(),
      });
      double? currentBalance;
      await widget._documentReference.get().then((DocumentSnapshot doc) {
        final data = (doc.data() ?? {}) as Map;
        currentBalance = double.parse("${data["balance"] ?? 0.0}");
      }, onError: (e) => print("Error getting document $e"));
      if(widget.entryType == "Add") {
        await widget._documentReference
            .update({
          "balance": (currentBalance! - double.parse(widget.doc["amount"])) + double.parse(amountController.text.trim())
        });
      } else {
        await widget._documentReference
            .update({
          "balance": (currentBalance! + double.parse(widget.doc["amount"])) - double.parse(amountController.text.trim())
        });
      }
      Navigator.pop(context);
      Navigator.pop(context);

      // Navigator.of(context)
      //     .pushReplacement(MaterialPageRoute(builder: (_)
      // => BookDetailsPage(
      //     book: widget.doc,
      //     bookCollection: widget.bookCollection
      // )
      // ));
    }
    catch(e) {
      print(e);
    }

  }
}
