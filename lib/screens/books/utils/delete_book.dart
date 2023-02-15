
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> deleteBook({required String productId, required CollectionReference book}) async {
  await book.doc(productId).delete();
}