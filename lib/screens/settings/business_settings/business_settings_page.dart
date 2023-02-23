import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mally_book/screens/books/books_list/books_list_page.dart';

class BusinessSettingsPage extends StatefulWidget {
  BusinessSettingsPage({Key? key}) : super(key: key);

  @override
  State<BusinessSettingsPage> createState() => _BusinessSettingsPageState();
}

class _BusinessSettingsPageState extends State<BusinessSettingsPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Business Settings"),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "General",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400
                ),
              ),
            ),
            const SizedBox(height: 20,),
            ListTile(
              onTap: () => confirmDeleteDialog(
                context: context,
              ),
              leading: const Icon(
                Icons.delete_forever,
                size: 25,
                color: Colors.red,
              ),
              title: const Text(
                "Delete Business",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: const Text("Delete all the data of this business\npermanently"),
            ),
          ],
        ),
      ),

    );
  }

  Future<void> deleteBusiness() async {
    try {
      firestore.collection('book').get().then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
    } catch(e) {
      print(e);
    }
  }

  confirmDeleteDialog({
    required BuildContext context,
  }) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            ),
            title: const Text("Delete Business?"),
            content: const Text("Are you sure, you want to delete the business?"),
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
                    await deleteBusiness();
                    Navigator.pop(this.context);
                  },
                  child: const Text("Yes, delete")
              )
            ],
          );
        }
    );
  }
}
