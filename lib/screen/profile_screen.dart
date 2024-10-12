import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notesf/constrant/customTextStyle.dart';
import 'package:notesf/model/user_model.dart';

class ProfileScreen extends StatefulWidget {
  // Change to StatefulWidget to manage state
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  MediaQueryData? mqData;
  File? pickedFile;

  @override
  Widget build(BuildContext context) {
    mqData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: FutureBuilder<UserModel?>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("User data not found"));
          }

          UserModel user = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      /// ---------------------------Profile Image--------------------------------///
                      Container(
                        width: mqData!.size.width * 0.8,
                        height: mqData!.size.width * 0.8, // Adjusted height
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              100), // Optional: make it circular
                          image: DecorationImage(
                            image: pickedFile != null
                                ? FileImage(pickedFile!)
                                : const AssetImage("assets/user (1).png")
                                    as ImageProvider, // Default image
                            fit: BoxFit
                                .cover, // Make the image cover the container
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          style: IconButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            backgroundColor: Colors.orangeAccent,
                          ),

                          /// -------------- Edit button ----------------------///
                          onPressed: () async {
                            XFile? pickedImage = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            if (pickedImage != null) {
                              CroppedFile? cropFile = await ImageCropper()
                                  .cropImage(sourcePath: pickedImage.path);
                              if (cropFile != null) {
                                setState(() {
                                  pickedFile = File(cropFile.path);
                                });
                              }
                            }
                          },
                          icon: const Icon(Icons.edit),
                        ),
                      ),
                    ],
                  ),

                  /// ----------------------------------- Data Show ---------------------------------------///
                  const SizedBox(height: 20),
                  Text("Name: ${user.name}", style: mTextStyle22()),
                  const SizedBox(height: 10),
                  Text("Email: ${user.email}", style: mTextStyle18()),
                  const SizedBox(height: 10),
                  Text("Gender: ${user.gender}", style: mTextStyle18()),
                  const SizedBox(height: 10),
                  Text("Age: ${user.age}", style: mTextStyle18()),
                  const SizedBox(height: 10),
                  Text("Number: ${user.number}", style: mTextStyle18()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Function to fetch user data from Firestore
  Future<UserModel?> _getUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.uid)
          .get();
      if (userDoc.exists) {
        return UserModel.FromDoc(userDoc.data() as Map<String, dynamic>);
      }
    }
    return null;
  }
}
