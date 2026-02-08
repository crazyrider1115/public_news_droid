import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AdminApprovalScreen extends StatefulWidget {
  const AdminApprovalScreen({super.key});

  @override
  State<AdminApprovalScreen> createState() => _AdminApprovalScreenState();
}

class _AdminApprovalScreenState extends State<AdminApprovalScreen> {
  @override
  Widget build(BuildContext context) {
    final List<UserModel> pendingUsers =
        AuthService.getPendingUsers();

    return Scaffold(
      appBar: AppBar(title: const Text("Admin Approval")),
      body: pendingUsers.isEmpty
          ? const Center(child: Text("No pending users"))
          : ListView.builder(
              itemCount: pendingUsers.length,
              itemBuilder: (context, index) {
                final user = pendingUsers[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(user.name),
                    subtitle: Text(user.username),
                    trailing: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          AuthService.approveUser(user);
                        });
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


