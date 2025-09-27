import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Future<void> toggleUserState(String userId, bool currentState) async {
    await users
        .doc(userId)
        .update({'state': currentState ? 'inactive' : 'active'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Panel"),
        backgroundColor: Colors.amber,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 214, 202, 158),
          border: Border.all(color: Colors.black),
        ),
        child: StreamBuilder(
          stream: users.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData) {
              return const Center(child: Text("No users found."));
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var userDoc = snapshot.data!.docs[index];
                var userData = userDoc.data() as Map<String, dynamic>;
                bool isActive = userData['state'] == 'active';

                return ListTile(
                  title: Text(userData['fullName'] ?? 'No Name'),
                  subtitle: Text(userData['email'] ?? 'No Email'),
                  trailing: Switch(
                    value: isActive,
                    onChanged: (value) {
                      toggleUserState(userDoc.id, isActive);
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
