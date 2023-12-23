import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todoapp/screens/home.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();

  addtasktodatabase() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    final uid = user!.uid;
    var time = DateTime.now();

    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('userTasks')
        .doc(time.toString())
        .set({
      "title": titlecontroller.text,
      "description": descriptioncontroller.text,
      'time': time.toString(),
    });
    Fluttertoast.showToast(msg: "Task Added Successfully");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Add Todo",
          style: GoogleFonts.roboto(),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView
        (child :Container(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Add New Task",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 50,
          ),
          TextField(
            controller: titlecontroller,
            decoration: InputDecoration(
              labelText: "Title",
              labelStyle: TextStyle(color: Colors.grey.shade700),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: descriptioncontroller,
            decoration: InputDecoration(
              labelText: "Description",
              labelStyle: TextStyle(color: Colors.grey.shade700),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              addtasktodatabase();
            },
            child: const Text(
              "Add Todo",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
                primary: Colors.green.shade300,
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                textStyle:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          )
        ]),
      ),
    ));
  }
}
