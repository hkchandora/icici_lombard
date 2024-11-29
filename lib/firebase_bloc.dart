import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FirebaseBloc {

  //Create instance of firebase store collection reference
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  // Add User
  void addUser(String name) {
    users.add({'name': name}).then((value) {
      debugPrint("User Added");
    }).catchError((error) {
      debugPrint("Failed to add user: $error");
    });
  }

  // Update User
  void updateUser(String docId, String name) {
    users.doc(docId).update({'name': name}).then((value) {
      debugPrint("User Updated");
    }).catchError((error) {
      debugPrint("Failed to update user: $error");
    });
  }

  // Delete User
  void deleteUser(String docId) {
    users.doc(docId).delete().then((value) {
      debugPrint("User Deleted");
    }).catchError((error) {
      debugPrint("Failed to delete user: $error");
    });
  }
}
