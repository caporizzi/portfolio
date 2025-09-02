import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/user_profile_provider.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Screen'),
      ),
      body: Center(
        child: Column(
          children: [
            Title(color: Colors.black, child: Text("About this app")),
            const SizedBox(height: 8),
            Text("This app was developed in 2024 over the course of 2 weeks for the summer school of the HES-SO Valais/Wallis."),
            const SizedBox(height: 20),
            Title(color: Colors.black, child: Text("A note from the dev team")),
            const SizedBox(height: 8),
            Text("We are very proud to present this app. It was a fun challenge for us, as two weeks is really not a lot of time, and we are proud of what we achieved.")
          ],
        )
      ),
    );
  }
}