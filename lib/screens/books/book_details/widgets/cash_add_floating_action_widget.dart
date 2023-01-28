import 'package:flutter/material.dart';

cashAddFloatingActionWidget({
  required String buttonName,
  required Color buttonColor,
  required double screenWidth,
  required bool isAddNew,
  var onTap,
  required BuildContext context
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: buttonColor,
        border: Border.all(color: Theme.of(context).primaryColor)
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: 45,
          vertical: 12
      ),
      child: Text(
        buttonName,
        style: TextStyle(
          color: isAddNew ? Theme.of(context).primaryColor : Colors.white
        ),
      ),
    ),
  );
}