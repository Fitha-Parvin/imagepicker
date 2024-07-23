import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyDXK8LliUtK2D8sEdDeyJZKosUkSvRViz0",
    appId: "1:83388347692:android:a157b9af43c9c1071fa889",
    messagingSenderId: "",
    projectId: "storage-66870",
    storageBucket: "storage-66870.appspot.com",
  ));

  runApp(MaterialApp(
    home: toDofire(),
  ));
}

class toDofire extends StatefulWidget {
  @override
  State<toDofire> createState() => _toDofireState();
}

class _toDofireState extends State<toDofire> {
  late CollectionReference _userCollection;

  @override
  void initState() {
    _userCollection = FirebaseFirestore.instance.collection("users");
    super.initState();
  }

  // inistate() {
  //   _userCollection = FirebaseFirestore.instance.collection("users");
  //   super.initState();
  // }

  var cname = TextEditingController();
  var cemail = TextEditingController();
  var uname = TextEditingController();
  var uemail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: readUser(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error ${snapshot.error}'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final userId = user.id;
                final userName = user["name"];
                final userEmail = user["email"];

                return ListTile(
                    title: Text('$userName'),
                    subtitle: Text('$userEmail'),
                    trailing: Wrap(
                      children: [
                        IconButton(
                            onPressed: () {
                              uname.text = userName;
                              uemail.text = userEmail;
                              editUserData(userId);
                            },
                            icon: Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {
                              deleteUser(userId);
                            },
                            icon: Icon(Icons.delete))
                      ],
                    ));
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createUser(),
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  void createUser() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("AddUser"),
            content: Column(
              children: [
                TextField(
                  controller: cname,
                  decoration: InputDecoration(hintText: "name"),
                ),
                TextField(
                  controller: cemail,
                  decoration: InputDecoration(hintText: "email"),
                ),
              ],
            ),
            actions: [
              OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("cancel")),
              OutlinedButton(
                  onPressed: () => addUserDB(cname.text, cemail.text),
                  child: Text("create user")),
            ],
          );
        });
  }

  void editUserData(String userId) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            children: [
              TextField(
                controller: uname,
                decoration: InputDecoration(hintText: "Name"),
              ),
              TextField(
                controller: uemail,
                decoration: InputDecoration(hintText: "Email"),
              ),
              ElevatedButton(
                  onPressed: () {
                    updateUser(userId, uname.text, uemail.text);
                    uname.clear();
                    uemail.clear();
                  },
                  child: Text("edit"))
            ],
          );
        });
  }

  addUserDB(String name, String email) async {
    return _userCollection.add({'name': name, 'email': email}).then((Value) {
      print("user added successfully");
      cname.clear();
      cemail.clear();
      Navigator.of(context).pop();
    }).catchError((error) {
      print("failed to add data $error");
    });
  }

  Stream<QuerySnapshot> readUser() {
    return _userCollection.snapshots();
  }

  Future<void> updateUser(String userId, String uname, String uemail) async {
    var updatedvalues = {'name': uname, 'email': uemail};
    return _userCollection.doc(userId).update(updatedvalues).then((Value) {
      Navigator.of(context).pop();
      print("user data updated successfully");
    }).catchError((error) {
      print("userdata updation failed");
    });
  }

  Future<void> deleteUser(var id) async {
    return _userCollection.doc(id).delete().then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("user deleted successfully")));
    }).catchError((error) {
      print("deletion failed");
    });
  }
}
