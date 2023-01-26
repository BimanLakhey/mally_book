import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mally_book/screens/home/widgets/confirm_delete_dialog.dart';
import 'package:mally_book/screens/home/widgets/custom_popup_menu_item_widget.dart';
import 'package:mally_book/screens/home/widgets/rename_book_bottom_sheet.dart';

showPopUp({
  required DocumentSnapshot documentSnapshot,
  required GlobalKey<FormState> renameBookFormKey,
  required TextEditingController renameBookController,
  required FocusNode renameBookNode,
  required var book

}) {
  return PopupMenuButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)
      ),
      icon: const Icon(Icons.more_vert_outlined),
      itemBuilder: (context) {
        return <PopupMenuItem>[
          customPopupMenuItem(
              icon: const Icon(CupertinoIcons.pen),
              title: "Rename",
              onTap: ()  {
                bookBottomSheet(
                  documentSnapshot: documentSnapshot,
                  context: context,
                  renameBookFormKey: renameBookFormKey,
                  renameBookController: renameBookController,
                  renameBookNode: renameBookNode,
                  book: book
                );
              }
          ),

          customPopupMenuItem(
              icon: const Icon(Icons.delete),
              title: "Delete Book",
              onTap: () {
                confirmDeleteDialog(
                  productId: documentSnapshot.id,
                  context: context,
                  book: book
                );
              }
          ),
        ];
      }
  );
}
