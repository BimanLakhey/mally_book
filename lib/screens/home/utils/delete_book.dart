
Future<void> deleteBook({required String productId, required var book}) async {
  await book.doc(productId).delete();
}