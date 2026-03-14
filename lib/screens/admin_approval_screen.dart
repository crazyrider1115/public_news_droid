import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AdminApprovalScreen extends StatefulWidget {
  const AdminApprovalScreen({super.key});

  @override
  State<AdminApprovalScreen> createState() => _AdminApprovalScreenState();
}

class _AdminApprovalScreenState extends State<AdminApprovalScreen> {

  List<dynamic> pendingUsers = [];

  @override
  void initState() {
    super.initState();

    loadPendingUsers();
  }

  Future<void> loadPendingUsers() async {
    final users = await AuthService.getPendingUsers();
    setState(() {
      pendingUsers = users;
    });
  }

  Future<void> approveUser(String username) async {
    await AuthService.approveUser(username);
    await loadPendingUsers();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Approval"),
      ),

      body: pendingUsers.isEmpty
          ? const Center(child: Text("No pending users"))

          : ListView.builder(
              itemCount: pendingUsers.length,
              itemBuilder: (context, index) {

                final user = pendingUsers[index];


                return Card(
                  margin: const EdgeInsets.all(10),

                  child: ListTile(
                    title: Text(user['name']),
                    subtitle: Text(user['username']),

                    trailing: ElevatedButton(
                      onPressed: () {
                        approveUser(user['username']);
                      },
                      child: const Text("Approve"),
                    ),
                  ),
                );
              },
            ),
    );
  }

}
