import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/screens/addTodo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todoapp/screens/authscreens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String uid = '';
  String? email = '';
  @override
  void initState() {
    super.initState();
    getuid();
  }

  getuid() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    setState(() {
      uid = user!.uid;
      email = user.email;
      print(user!);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blue,
          elevation: 100,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: Container()),
              const Text(
                "HomePage",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
              Expanded(child: Container()),
              GestureDetector(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AuthScreen()),
                    );
                  },
                  child: const Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  )),
            ],
          )),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('tasks')
              .doc(uid)
              .collection('userTasks')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 20,
                          child: ListTile(
                        title: Text(
                            snapshot.data!.docs[index]["title"],
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                        ),
                        subtitle: Text(snapshot.data!.docs[index]["description"]),
                        trailing: IconButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection("tasks")
                                  .doc(uid)
                                  .collection("userTasks")
                                  .doc(snapshot.data!.docs[index].id)
                                  .delete();
                            },
                            icon: const Icon(Icons.delete)),
                      ));
                    }),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddTodo()));
          }),
    );
  }
}
