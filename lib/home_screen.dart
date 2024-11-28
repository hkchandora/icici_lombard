import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icici/firebase_bloc.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final FirebaseBloc _firebaseBloc = FirebaseBloc();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase CRUD')),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'User Name'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_nameController.text.isNotEmpty) {
                    _firebaseBloc.addUser(_nameController.text);
                    _nameController.clear();
                  }
                },
                child: const Text('Add User'),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: _firebaseBloc.users.snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    return ListView(
                      children: snapshot.data!.docs.map((doc) {
                        return Row(
                          children: [
                            Expanded(child: Text(doc['name'])),
                            IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _showEditDialog(
                                    context, doc.id, doc['name'])),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _firebaseBloc.deleteUser(doc.id),
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, String docId, String currentName) {
    final TextEditingController editController =
        TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit User Name'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(labelText: 'User Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (editController.text.isNotEmpty) {
                  _firebaseBloc.updateUser(docId, editController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
