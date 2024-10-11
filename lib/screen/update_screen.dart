import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notesf/constrant/customTextStyle.dart';

class UpdateScreen extends StatefulWidget {
  final String? title;
  final String? description;
  final String docId; // Add docId to the constructor

  const UpdateScreen({super.key, this.title, this.description, required this.docId});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  late TextEditingController titleController;
  late TextEditingController subTitleController;

  FirebaseFirestore fireBaseStore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();

    /// Initialize controllers with the passed title and description
    titleController = TextEditingController(text: widget.title);
    subTitleController = TextEditingController(text: widget.description);
  }

  @override
  Widget build(BuildContext context) {
    var collectionRef = fireBaseStore.collection("notes");
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ElevatedButton(
                  onPressed: () async {
                    // Use the docId to update the specific document
                    await collectionRef.doc(widget.docId).update({
                      "title": titleController.text,
                      "description": subTitleController.text,
                    });

                    // Navigate back after updating
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent),
                  child: Text(
                    "Update",
                    style: mTextStyle22(
                        fontWeight: FontWeight.bold, fontColor: Colors.white),
                  ))),
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
              hintText: "Description",
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
