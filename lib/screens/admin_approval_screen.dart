import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminApprovalScreen extends StatefulWidget {
  const AdminApprovalScreen({super.key});

  @override
  State<AdminApprovalScreen> createState() => _AdminApprovalScreenState();
}

class _AdminApprovalScreenState extends State<AdminApprovalScreen> {
  List pendingUsers = [];

  @override
  void initState() {
    super.initState();
    fetchPendingUsers();
  }

  Future<void> fetchPendingUsers() async {
    final response = await http.get(
      Uri.parse("http://10.0.2.2:3000/auth/pending"),
    );

    if (response.statusCode == 200) {
      setState(() {
        pendingUsers = jsonDecode(response.body);
      });
    }
  }

  Future<void> approveUser(String username) async {
    await http.post(
      Uri.parse("http://10.0.2.2:3000/auth/approve"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username}),
    );

    fetchPendingUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Approval")),

      body: pendingUsers.isEmpty
          ? const Center(child: Text("No pending users"))
          : ListView.builder(
              itemCount: pendingUsers.length,
              itemBuilder: (context, index) {
                final user = pendingUsers[index];

                return ListTile(
                  title: Text(user["username"]),
                  trailing: ElevatedButton(
                    onPressed: () {
                      approveUser(user["username"]);
                    },
                    child: const Text("Approve"),
                  ),
                );
              },
            ),
    );
  }
}

