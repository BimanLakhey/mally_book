import 'package:flutter/material.dart';

class AttachedImageDisplay extends StatelessWidget {
  String imageUrl;
  AttachedImageDisplay({Key? key,required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () =>Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Attachment Preview"),
      ),
      body: Image.network(
        imageUrl,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}
