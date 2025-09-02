import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/user_profile_provider.dart';
import 'package:task_manager/views/take_picture_screen.dart';
import 'dart:convert';
import 'package:image/image.dart' as img;
import 'package:task_manager/views/user_info_page.dart';

import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _npaController= TextEditingController();
  final TextEditingController _adressController=TextEditingController();
  final TextEditingController _cityController=TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _imagePath = "";
  

  bool _isLogin = true;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    // Ensure that plugin services are initialized so that `availableCameras()`
    // can be called before `runApp()`
    WidgetsFlutterBinding.ensureInitialized();

    CameraDescription? frontCamera;

    // Obtain a list of the available cameras on the device.
    final cameras = availableCameras().then((cameras) {
      frontCamera = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front);
    });

    return _isLogin?Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!regex.hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              if (_errorMessage != null) ...[
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                SizedBox(height: 10),
              ],
              ElevatedButton(
                onPressed: () => _authenticate(context),
                child: const Text('Login'),
              ),

              TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                    _errorMessage = null;  // Clear the error message when switching modes
                  });
                },
                child: const Text('Create an account'),
              ),
            ],
          ),
        ),
      ),
    ):Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child:Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!regex.hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordConfirmController,
                  decoration: const InputDecoration(labelText: 'Confirm password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    if(value!=_passwordController.text){
                      return 'Passwords must match!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(labelText: 'City'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a city';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _npaController,
                  decoration: const InputDecoration(labelText: 'NPA'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an NPA';
                    }
                    final regex = RegExp(r'^\d\d\d\d');
                    if (!regex.hasMatch(value)) {
                      return 'Please enter a valid NPA';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _adressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an address';
                    }
                    final regex = RegExp(r'^[\w ]+,? ?\d+');
                    if (!regex.hasMatch(value)) {
                      return 'Please enter a valid address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                IconButton(
                  onPressed: () async {
                    final data = await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TakePictureScreen(camera: frontCamera!))
                    );
                    if(data != null) {
                      setState(() {
                        final img.Image image = img.decodeImage(File(data).readAsBytesSync())!;
                        final img.Image imgOriented = img.bakeOrientation(image);
                        File(data).writeAsBytesSync(img.encodeJpg(imgOriented));

                        _imagePath = data;
                      });
                    }
                  }, 
                  icon: const Icon(Icons.camera),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
                  ),
                ),

                if(_imagePath!="")
                  Image.file(
                    File(_imagePath),
                    height: 200,
                  ),

                const SizedBox(height: 20),
                if (_errorMessage != null) ...[
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                  const SizedBox(height: 10),
                ],
                ElevatedButton(
                  onPressed: () => _authenticate(context),
                  child: const Text('Create account'),
                ),

                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                      _errorMessage = null;  // Clear the error message when switching modes
                    });
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      )
      
    );
  }

  void _authenticate(BuildContext context) async {
    if(_imagePath == "" && !_isLogin){
      setState(() {
        _errorMessage = "Please take a picture!";
      });
      return;
    }

    final imageOK = _isLogin || (_imagePath != "" && !_isLogin);

    if (imageOK && (_formKey.currentState?.validate() ?? false)) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final email = _emailController.text;
      final password = _passwordController.text;
      final lastName = _lastNameController.text;
      final firstName = _firstNameController.text;
      final profileImage = _imagePath;
      final npa = _npaController.text;
      final city = _cityController.text;
      final adress = _adressController.text;

      String? errorMessage;
      if (_isLogin) {
        errorMessage = await authProvider.signInWithEmailAndPassword(email, password);
      } else {
        errorMessage = await authProvider.registerWithEmailAndPassword(email, password);
      }

      // Reload the tasks and user profile after successful login or registration
      Provider.of<UserProfileProvider>(context, listen: false).loadUserProfile();
      Provider.of<UserProfileProvider>(context, listen: false).loadUserProfiles();

      if(!_isLogin) {
        final imageBytes = File(profileImage).readAsBytesSync();
        final base64Image = base64Encode(imageBytes);
        final userProfileProvider = Provider.of<UserProfileProvider>(context, listen:false);
        try{  
          await userProfileProvider.setUserProfile({
            "firstName": firstName,
            "lastName": lastName,
            "profileImage": base64Image,
            "addressCity":city,
            "addressNPA":npa,
            "addressStreet":adress,
            "email":email
          });
        }catch (e){
          errorMessage="Adress does not exist!";
        }
      }

      if (errorMessage != null) {
        setState(() {
          _errorMessage = errorMessage;
        });
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => UserInfoPage()),
        );
      }
    }
  }
}