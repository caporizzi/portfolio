import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/user_profile_provider.dart';
import 'package:task_manager/services/deepface_api_service.dart';
import 'package:task_manager/services/user_profile_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:task_manager/views/itineraries_view.dart';

class FaceScanPage extends StatefulWidget {
  @override
  _FaceScanPageState createState() => _FaceScanPageState();
}

class _FaceScanPageState extends State<FaceScanPage> {
  late CameraController _controller;
  Future<void>? _initializeControllerFuture;
  late List<CameraDescription> cameras;
  bool _waitingForResponse = false;
  bool _liveModeActive = false;
  String _liveText = "⚫ Live";
  late Timer _liveAnimationTimer;
  String _liveFacesText = "Counting faces...";

  @override
  void initState() {
    super.initState();

    _liveAnimationTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _liveText = (t.tick % 2 == 0) ? "🟠 Live" : "⚫ Live");
    });

    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // Get the list of available cameras.
    cameras = await availableCameras();

    // Select the front camera if available.
    final CameraDescription camera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    // Initialize the camera controller.
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
    );

    // Initialize the controller future.
    _initializeControllerFuture = _controller.initialize();

    // Wait until the controller is initialized.
    await _initializeControllerFuture;

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    _liveAnimationTimer.cancel();
    super.dispose();
  }

  void _onBackButtonPressed() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Scan Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _onBackButtonPressed,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If the Future is complete, display the camera preview.
                    final size = MediaQuery.of(context).size;
                    var scale = size.aspectRatio * _controller.value.aspectRatio;
                    if (scale < 1) scale = 1 / scale;
        
                    return OrientationBuilder(
                      builder: (context, orientation) {
                        return Transform.scale(
                          scale: scale *
                              (orientation == Orientation.landscape
                                  ? 1 - 1 / _controller.value.aspectRatio
                                  : 1),
                          child: AspectRatio(
                            aspectRatio: orientation == Orientation.landscape
                                ? _controller.value.aspectRatio
                                : 1 / _controller.value.aspectRatio,
                            child: CameraPreview(_controller),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    // If the Future completes with an error.
                    return Center(
                      child: Text('Error initializing camera: ${snapshot.error}'),
                    );
                  } else {
                    // Otherwise, display a loading indicator.
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: 
                _liveModeActive 
                ? Container(
                  child: Padding(
                    padding: EdgeInsets.all(16.0), 
                    child: Text(_liveFacesText, style: TextStyle(color: Colors.white))
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ) 
                : ElevatedButton(
                  onPressed: _waitingForResponse ? null : handleTakePicture, 
                  child: Icon(Icons.camera),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(16.0),
                    shape: CircleBorder(),
                  ),
                ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _liveModeActive = !_liveModeActive;
            if(_liveModeActive) {
              pollFacesCount();
              setState(() {
                _liveFacesText = "Counting faces...";
              });
            }
          });
        },
        child: _liveModeActive ? Text(_liveText) : const Text("⚫ Live"),
        backgroundColor: _liveModeActive ? Colors.red: Colors.black,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  Future<void> pollFacesCount() async {
    if (!_liveModeActive || !mounted) return;

    var facesCount = 0;
    var base64Image = "";

    try {
      final image = await _controller.takePicture();
      final imageBytes = File(image.path).readAsBytesSync();
      base64Image = base64Encode(imageBytes);
      facesCount = await DeepfaceApiService.countFaces(base64Image);

      setState(() {
        _liveFacesText = switch(facesCount) {
          1 => "There is one face detected.",
          0 || _ => "There are $facesCount faces detected"
        };
      });
    }
    catch (e) {
      print(e);
    }

    // User may have disabled live mode while we were waiting for the response.
    if(!_liveModeActive || !mounted) return;

    if(facesCount == 1) {
      // Try to find the user by face, and navigate to the itineraries view if user found.
      try {
        final userId = await DeepfaceApiService.findUserByFace(base64Image);

        final userProfileProvider = Provider.of<UserProfileProvider>(context, listen: false);
        await userProfileProvider.loadUserProfileWithId(userId);

        // User may have disabled live mode while we were waiting for the response.
        if(!_liveModeActive || !mounted) return;

        Fluttertoast.showToast(
          msg: "Welcome ${userProfileProvider.userProfile.fullName}!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ItinerariesView()),
        );
      }
      catch (e) {
        Fluttertoast.showToast(
          msg: "Sorry, we couldn't recognize your face. Please try again.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
      }
    }

    pollFacesCount();
  }
  
  handleTakePicture() async {
    // Take the Picture in a try / catch block. If anything goes wrong, catch the error.
    try {
      // Ensure that the camera is initialized.
      await _initializeControllerFuture;

      // Attempt to take a picture and get the file `image`
      final image = await _controller.takePicture();

      if (!context.mounted) return;

      // Load the image and convert it to a base64 string.
      final imageBytes = File(image.path).readAsBytesSync();
      final base64Image = base64Encode(imageBytes);

      try {
        setState(() {
          _waitingForResponse = true;
        });

        final facesCount = await DeepfaceApiService.countFaces(base64Image);

        //print("Faces count: $facesCount");

        if (facesCount != 1) {
          final errorMessage = switch(facesCount) {
            0 => "We couldn't find a face in the image! Please try again.",
            _ => "$facesCount faces detected. Please make sure you're alone in the picture and try again."
          };

          Fluttertoast.showToast(
            msg: errorMessage,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
          );

          setState(() {
            _waitingForResponse = false;
          });

          return;
        }

        final userId = await DeepfaceApiService.findUserByFace(base64Image);

        final userProfileProvider = Provider.of<UserProfileProvider>(context, listen: false);
        await userProfileProvider.loadUserProfileWithId(userId);

        Fluttertoast.showToast(
          msg: "Welcome ${userProfileProvider.userProfile.fullName}!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ItinerariesView()),
        );
      }
      catch (e) {
        Fluttertoast.showToast(
          msg: "Sorry, we couldn't recognize your face. Please try again.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
      }
      finally {
        setState(() {
          _waitingForResponse = false;
        });
      }
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
    finally {
      setState(() {
        _waitingForResponse = false;
      });
    }
  }
}