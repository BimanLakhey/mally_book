import 'package:flutter/material.dart';

customFloatingActionButton({
  required String buttonName,
  required IconData buttonIcon,
  required Color buttonColor,
  required double screenWidth,
  var onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: buttonColor,
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: 35,
          vertical: 10
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            buttonIcon,
            color: Colors.white,
          ),
          SizedBox(width: screenWidth / 30,),
          Text(
            buttonName,
            style: const TextStyle(
                color: Colors.white
            ),
          )
        ],
      ),
    ),
  );
}