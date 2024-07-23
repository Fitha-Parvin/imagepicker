// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// void main()async {
//
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//       options: const FirebaseOptions(
//         apiKey: "AIzaSyDXK8LliUtK2D8sEdDeyJZKosUkSvRViz0",
//         appId: "1:83388347692:android:a157b9af43c9c1071fa889",
//         messagingSenderId: "",
//         projectId: "storage-66870",
//         storageBucket: "storage-66870.appspot.com",
//       ));
//   runApp(MaterialApp(
//     home: exToDo(),
//   ));
// }
//
// class exToDo extends StatelessWidget {
//   late CollectionReference usercollection;
//
//
//
//
//
//   @override
//   initSate(){
//     usercollection=FirebaseFirestore.instance.collection("users");
//    // super.initState();
//   }
//
//
//   var createname = TextEditingController();
//   var createemail = TextEditingController();
//   var updatename=TextEditingController();
//   var updateemail=TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//
//     Stream<QuerySnapshot> readUser() {
//       return usercollection.snapshots();
//     }
//
//
//     return Scaffold(
//         body: StreamBuilder<QuerySnapshot>(
//           stream: readUser(),
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return Center(child: Text('error ${snapshot.error}'));
//             }
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }
//
//             final users=snapshot.data!.docs;
//
//
//             return ListView.builder(
//                 itemBuilder: (context, index) {
//
//                   final user=users[index];
//                   final UserId=user.id;
//                   final username=user["name"];
//                   final useremail=user["email"];
//
//               return ListTile(
//                 title: Text('$username'),
//                 subtitle: Text('$useremail'),
//                 trailing: Wrap(
//                   children: [
//                     IconButton(onPressed: () {
//                       updatename.text=username;
//                       updateemail.text=useremail;
//                       editUser(UserId);
//
//                     }, icon: Icon(Icons.edit)),
//                     IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
//                   ],
//                 ),
//               );
//             });
//           },
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {},
//           child: Icon(Icons.add),
//           backgroundColor: Colors.pink,
//         ));
//   }
//
//   void createUser() {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text("AddUser"),
//             content: Column(
//               children: [
//                 TextField(
//                   controller: createname,
//                   decoration: InputDecoration(hintText: "name"),
//                 ),
//                 TextField(
//                   controller: createemail,
//                   decoration: InputDecoration(hintText: "email"),
//                 ),
//               ],
//             ),
//             actions: [
//               OutlinedButton(onPressed: () {}, child: Text("cancel")),
//               OutlinedButton(onPressed: () {
//                 updatename.text;
//                 updateemail.text;
//               }, child: Text("create user")),
//             ],
//           );
//         });
//   }
//
//   readUser() {}
//
//   void editUser(userId) async{
//     showBottomSheet(context:
//     context,
//         builder: (context){
//       return Column(
//         children: [
//           TextField(
//             controller: updatename,
//             decoration: InputDecoration(hintText: "name"),),
//           TextField(
//             controller: updateemail,
//             decoration: InputDecoration(hintText: "email"),),
//           ElevatedButton(onPressed: (){
//             updatename.clear();
//             updateemail.clear();
//             updateUser(userId,updatename.text,updateemail.text);
//           }, child: Text("edit"))
//         ],
//       );
//         });
//   }
//
//   addUserDB(String name, String email) async {
//     return usercollection.add({'name': name, 'email': email}).then((Value) {
//       print("user added successfully");
//       createname.clear();
//       createemail.clear();
//       Navigator.of(context).pop();
//     }).catchError((error) {
//       print("failed to add data $error");
//     });
//   }
//
//   Future<void> updateUser(String userId, String uname, String uemail) async {
//     var updatedvalues = {'name': uname, 'email': uemail};
//     return usercollection.doc(userId).update(updatedvalues).then((Value) {
//       Navigator.of(context).pop();
//       print("user data updated successfully");
//     }).catchError((error) {
//       print("userdata updation failed");
//     });
//   }
//
//   Future<void> deleteUser(var id) async {
//     return usercollection.doc(id).delete().then((value) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("user deleted successfully")));
//     }).catchError((error) {
//       print("deletion failed");
//     });
//   }
// }
//
//
//
//
//
