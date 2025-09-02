import 'package:flutter/material.dart';
import 'package:task_manager/views/login_screen.dart';
import 'package:task_manager/views/face_scan_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          leading: const Icon(Icons.menu),
          backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
          title: const Text(
            "Country Roads",
            textAlign: TextAlign.start,
          ),
        ), // AppBar
        body: SingleChildScrollView(child:Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/logo.svg',
                semanticsLabel: 'My SVG Image',
                height: 200,
                width: 200,
              ),
              const Text(
                "Welcome!",
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
              const SizedBox(height: 20), // Add some space between the text and button
              ElevatedButton(
                onPressed: () {
                  // Button action here
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: const Text("Go to Login!"),
              ),
              const SizedBox(height: 20), // Add some space between the text and button
              ElevatedButton(
                onPressed: () {
                  // Button action here
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => FaceScanPage()),
                  );
                },
                child: const Text("Get your itinerary !"),
                
              ),
            ],
          ),),
        ), // Center
      ), // Scaffold
    ); // MaterialApp
  }
}
