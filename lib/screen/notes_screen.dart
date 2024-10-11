import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
              onPressed: () async {
                await collectionRef.add({
                  "title": titleController.text,
                  "description": subTitleController.text
                });
                Navigator.pop(context);
              },
              child:  Text(
                "Save" , style: mTextStyle22(fontWeight: FontWeight.bold , fontColor: Colors.white),
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
