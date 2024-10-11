import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notesf/screen/notes_screen.dart';
import 'package:notesf/screen/update_screen.dart';
import '../constrant/customTextStyle.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseFirestore fireBaseStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    var collectionRef = fireBaseStore.collection("notes");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notes",
          style: mTextStyle28(fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Icon(
              Icons.search_rounded,
              size: 30,
            ),
          ),
        ],
      ),

      /// Floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const NotesScreen()));
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),

      /// stream builder user for instance update
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          // builder : collectionRef.get(), /// when using futureBuilder
          stream: collectionRef.snapshots(),
          builder: (context, snapShot) {
            if (snapShot.hasData) {
              return snapShot.data!.docs.isNotEmpty
                  ? ListView.builder(
                      itemCount: snapShot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var noteData = snapShot.data!.docs[index].data();

                        /// ----------------- Dismissible -----------------------///
                        return Dismissible(
                          key: Key(snapShot.data!.docs[index].id),
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          secondaryBackground: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          direction: DismissDirection.horizontal,
                          onDismissed: (direction) async {
                            await collectionRef
                                .doc(snapShot.data!.docs[index].id)
                                .delete();
                          },
                          child: Card(
                            elevation: 4,
                            shadowColor: Colors.orangeAccent,
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UpdateScreen(
                                            title: noteData['title'],
                                            description: noteData['description'],
                                            docId: snapShot.data!.docs[index].id)));
                              },
                              title: Text(noteData['title']),
                              subtitle: Text(noteData['description']),
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text("Has no notes"),
                    );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
