import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'HomePage.dart';


class myDrawer extends StatefulWidget {
  const myDrawer({super.key});

  @override
  State<myDrawer> createState() => _myDrawerState();
}


class _myDrawerState extends State<myDrawer> {

  TextEditingController nameController = TextEditingController();

  Future SignOut() async {
    try{
      await FirebaseAuth.instance.signOut();
    }
    on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Fluttertoast.showToast(msg: 'Try again..');
    }
  }

  void showMessageDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Dear Learner!"),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await SignOut(); // Close the dialog
                },
                child: const Text('Yes'),
              ),
            ],
          );
        }
    );
  }

  @override
  void initState() {
    super.initState();
    fetchUserProfileData();
  }

  User? user = FirebaseAuth.instance.currentUser;

  Future<void> fetchUserProfileData() async {
    try{
      String? email = user?.email;
      String? uid = user?.uid;

      DocumentSnapshot document = await FirebaseFirestore.instance.collection("USERS").doc(email).collection('Personal Details').doc(uid).get();
      if(document.exists) {
        Map<String, dynamic> userProfileData = document.data() as Map<String, dynamic>;

        setState(() {
          nameController.text = userProfileData['Name'];
        });
      }
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Error during fetch Intern name: $e");
      }
      Fluttertoast.showToast(msg: 'Somethong went wrong..');
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }


  Widget buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.teal,
              Colors.blue.shade400,
              Colors.deepPurple.shade400,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
              radius: 52,
              backgroundImage: AssetImage('assets/manIcon.png',)
          ),
          const SizedBox(height: 10),
          Text(nameController.text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 2),
          Text(user?.email ?? "",
            style: const TextStyle(
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuItems(BuildContext context) {
    return Container(
      color: Colors.deepPurple.shade400,
      child: Container(
          height: MediaQuery.of(context).size.height * 0.70,
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(60),
              )
          ),
          child: Wrap(
            runSpacing: 24,
            children: [
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                iconColor: Colors.deepPurple,
                textColor: Colors.deepPurple,
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
                },
              ),
              ListTile(
                  leading: const Icon(Icons.output_rounded),
                  title: const Text('Log Out',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  iconColor: Colors.deepPurple,
                  textColor: Colors.deepPurple,
                  onTap: () {
                    Navigator.pop(context);
                    showMessageDialog(context, 'Do you really want to log out?');
                  }
              ),
            ],
          )
      ),
    );
  }
}