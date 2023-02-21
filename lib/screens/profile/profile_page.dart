import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../auth/utils/show_error_dialog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? profileImageFile;
  ImagePicker imagePicker = ImagePicker();

  TextEditingController? firstNameController;
  TextEditingController? lastNameController;

  bool _isLoading = false;


  @override
  void initState() {
    firstNameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    firstNameController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: screenHeight * 0.1,),
                Stack(
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 5, color: Theme.of(context).primaryColor),
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            offset: const Offset(3,3),
                            color: Colors.grey.shade300
                          )
                        ],
                      ),
                      child: profileImageFile != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.file(
                            profileImageFile!,
                            fit: BoxFit.cover,
                          ),
                        )
                        : Icon(
                          Icons.person,
                          color: Colors.grey.shade200,
                          size: 80,
                        ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Theme.of(context).primaryColor
                        ),
                        child: customImagePopup()
                      ),
                    )
                  ],
                ),
                SizedBox(height: screenHeight * 0.2,),
                Column(
                  children: [
                    TextFormField(
                      controller: firstNameController,
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
                          label: const Text("First Name"),
                          labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor
                          ),
                          hintText: "Enter your first name"
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.1,),
                    TextFormField(
                      controller: lastNameController,
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
                          label: const Text("Last Name"),
                          labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor
                          ),
                          hintText: "Enter your last name"
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.15,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 20)
                      ),
                      onPressed: _isLoading ? () {}  : updateUserProfile,
                      child: Center(
                        child: _isLoading
                            ? const SizedBox(
                          height: 21,
                          width: 21,
                          child: CircularProgressIndicator(color: Colors.white,),
                        )
                            : const Text(
                          "Save Changes",
                          style: TextStyle(
                              fontSize: 18
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  customImagePopup() {
    return PopupMenuButton(
      icon: const Icon(Icons.camera_alt_rounded, color: Colors.white,),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: Row(
              children: const [
                Icon(Icons.image),
                SizedBox(width: 20,),
                Text("Gallery"),
              ],
            ),
            onTap: () => getProfileImage(isFromCamera: false),
          ),
          PopupMenuItem(
            child: Row(
              children: const [
                Icon(Icons.image),
                SizedBox(width: 20,),
                Text("Camera"),
              ],
            ),
            onTap: () => getProfileImage(isFromCamera: true),
          )
        ];
      }
    );
  }

  Future getProfileImage({required bool isFromCamera}) async {
    final result = await imagePicker.pickImage(
      source:isFromCamera == true
        ? ImageSource.camera
        : ImageSource.gallery
    );
    if(result == null) return;
    setState(() {
      profileImageFile = File(result.path);
    });
  }

  Future updateUserProfile() async{
    setState(() {
      _isLoading = true;
    });
    try {
      await FirebaseAuth.instance.currentUser!.updateDisplayName(
        "${firstNameController?.text ?? ""} ${lastNameController?.text ?? ""}"
      );
      await FirebaseAuth.instance.currentUser!.updatePhotoURL(
        profileImageFile!.path
      );
    } on FirebaseAuthException catch(e) {
      showErrorDialog(e, context);
      setState(() {
        _isLoading = false;
      });
    }
  }
}

