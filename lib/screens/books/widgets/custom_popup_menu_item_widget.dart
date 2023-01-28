import 'package:flutter/material.dart';

customPopupMenuItem({
  required Icon icon,
  required String title,
  required var onTap
}) {
  return PopupMenuItem(
      child: ListTile(
        leading: icon,
        title: Text(title),
        onTap: onTap,
      )
  );
}