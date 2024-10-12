import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notesf/constrant/customTextStyle.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController subTitleController = TextEditingController();
  FirebaseFirestore fireBaseStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    var collectionRef = fireBaseStore.collection("notes");
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent),
              onPressed: () async {
                /// Get the current user
                FirebaseAuth auth = FirebaseAuth.instance;
                User? user = auth.currentUser;

                if (user != null) {
                  String uid = user.uid; // Get the current user's UID

                  /// Save the note with the user's UID
                  await collectionRef.add({
                    "uid": uid,
                    "title": titleController.text,
                    "description": subTitleController.text,
                    "timestamp": FieldValue
                        .serverTimestamp() // Add timestamp for sorting
                  });

                  /// Clear the text fields after saving
                  titleController.clear();
                  subTitleController.clear();

                  /// Go back after saving
                  Navigator.pop(context);
                } else {
                  // Handle case when user is not logged in
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("User not logged in")));
                }
              },
              child: Text(
                "Save",
                style: mTextStyle22(
                    fontWeight: FontWeight.bold, fontColor: Colors.white),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
                hintText: "Title",
                hintStyle: mTextStyle28(
                    fontColor: Colors.black45, fontWeight: FontWeight.w900),
                border: const OutlineInputBorder(borderSide: BorderSide.none)),
          ),
          TextField(
            controller: subTitleController,
            cursorColor: Colors.blueAccent,
            showCursor: true,
            autofocus: true,
            decoration: InputDecoration(
              hintStyle: mTextStyle28(
                  fontColor: Colors.black45, fontWeight: FontWeight.w900),
              border: const OutlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }
}
