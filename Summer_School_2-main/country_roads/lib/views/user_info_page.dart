import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/providers/auth_provider.dart';
import 'package:task_manager/providers/user_profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/views/about_page.dart';
import 'package:task_manager/views/admin_screen.dart';
import 'package:task_manager/views/take_picture_screen.dart';
import 'package:image/image.dart' as img;
import 'package:task_manager/views/welcome_page.dart';
import 'package:task_manager/widgets/profile_option.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({Key? key}) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  String _firstName = "John";
  String _lastName = "Doe";
  String _addressCity = "Sion";
  String _addressNPA = "1950";
  String _addressStreet = "Rue de l'industrie 23";
  String _email = "johndoe@example.com";
  String _pictureBase64 = "";
  late UserProfileProvider _userProfileProvider;

  @override
  void initState() {
    super.initState();
    _userProfileProvider = Provider.of<UserProfileProvider>(context, listen: false);
    _userProfileProvider.addListener(_updateUserProfileState);
  }

  @override
  void dispose() {
    _userProfileProvider.removeListener(_updateUserProfileState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ensure that plugin services are initialized so that `availableCameras()`
    // can be called before `runApp()`
    WidgetsFlutterBinding.ensureInitialized();

    CameraDescription? frontCamera;

    // Obtain a list of the available cameras on the device.
    final cameras = availableCameras().then((cameras) {
      frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front);
    });

    final userProfileProvider = Provider.of<UserProfileProvider>(context, listen: false);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          title: const Text("User Information", textAlign: TextAlign.start),
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                await authProvider.signOut();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const WelcomePage()),
                );
              },
            ),
          ],
        ), // AppBar
        body: userProfileProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  ProfileOption(
                    fieldName: "firstName",
                    label: "First Name",
                    value: _firstName,
                    onEdit: (newValue) {
                      setState(() {
                        _firstName = newValue;
                      });
                    },
                  ),
                  ProfileOption(
                    fieldName: "lastName",
                    label: "Last Name",
                    value: _lastName,
                    onEdit: (newValue) {
                      setState(() {
                        _lastName = newValue;
                      });
                    },
                  ),
                  ProfileOption(
                    fieldName: "email",
                    label: "Email",
                    value: _email,
                    onEdit: (newValue) {
                      setState(() {
                        _email = newValue;
                      });
                    },
                  ),
                  const Divider(),
                  ProfileOption(
                    fieldName: "addressCity",
                    label: "City",
                    value: _addressCity,
                    onEdit: (newValue) {
                      setState(() {
                        _addressCity = newValue;
                      });
                    },
                  ),
                  ProfileOption(
                    fieldName: "addressNPA",
                    label: "City NPA",
                    value: _addressNPA,
                    onEdit: (newValue) {
                      setState(() {
                        _addressNPA = newValue;
                      });
                    },
                  ),
                  ProfileOption(
                    fieldName: "addressStreet",
                    label: "Street and street number",
                    value: _addressStreet,
                    onEdit: (newValue) {
                      setState(() {
                        _addressStreet = newValue;
                      });
                    },
                  ),
                  const Divider(),
                  const SizedBox(height: 10),




                  Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      color: Colors.grey[300],
                      child: Center(
                        child: _pictureBase64 == ""
                            ? Text("no image")
                            : Image.memory(base64Decode(_pictureBase64)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        final data = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    TakePictureScreen(camera: frontCamera!)));
                        if (data != null) {
                          setState(() {
                            final img.Image image =
                                img.decodeImage(File(data).readAsBytesSync())!;
                            final img.Image imgOriented =
                                img.bakeOrientation(image);
                            File(data)
                                .writeAsBytesSync(img.encodeJpg(imgOriented));
                            final imageBytes = File(data).readAsBytesSync();
                            final base64Image = base64Encode(imageBytes);

                            setState(() {
                              _pictureBase64 = base64Image;
                            });

                            final userProfileProvider =
                                Provider.of<UserProfileProvider>(context,
                                    listen: false);
                            try{
                              userProfileProvider.changeUserProfile(
                                {"profileImage": base64Image});
                            }catch(e){}
                            
                          });
                        }
                      },
                      child: const Text("Change Picture"),
                    ),
                  ),


                  const SizedBox(height: 10),
                  if (_userProfileProvider.userProfile.isAdmin)
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => AdminScreen()),
                          );
                        },
                        child: const Text("Admin Panel"),
                      ),
                    ),
                ],
              ),
      ), // Scaffold
    ); // MaterialApp
  }

  void _updateUserProfileState() {
    setState(() {
      _firstName = _userProfileProvider.userProfile.firstName;
      _lastName = _userProfileProvider.userProfile.lastName;
      _email = _userProfileProvider.userProfile.email;
      _addressCity = _userProfileProvider.userProfile.addressCity;
      _addressNPA = _userProfileProvider.userProfile.addressNPA;
      _addressStreet = _userProfileProvider.userProfile.addressStreet;
      _pictureBase64 = _userProfileProvider.userProfile.profileImage;
    });
  }
}
