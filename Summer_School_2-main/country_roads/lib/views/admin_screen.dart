import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/user_profile_provider.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProfileProvider = Provider.of<UserProfileProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Screen'),
      ),
      body: Center(
        child: ListView.builder(itemCount: userProfileProvider.userProfiles.length, itemBuilder: (context, index) {
          final profile = userProfileProvider.userProfiles[index];
          return ListTile(
            title: Text("${profile.firstName} ${profile.lastName} - ${profile.email}"),
            subtitle: Text('isAdmin: ${profile.isAdmin}'),
          );
        }),
      ),
    );
  }
}