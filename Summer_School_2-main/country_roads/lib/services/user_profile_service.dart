import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:task_manager/models/user_profile_model.dart';
import 'package:task_manager/services/deepface_api_service.dart';

class UserProfileService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<UserProfile> fetchUserProfile(String userId) async {
    final snapshot = await _db.collection('users').doc(userId).get();
    final data = snapshot.data();

    if (data == null) {
      return UserProfile.empty;
    }

    return UserProfile.fromMap(data, userId);
  }

  Future<List<UserProfile>> fetchAllUserProfiles() async {
    final snapshot = await _db.collection('users').get();
    return snapshot.docs
        .map((doc) => UserProfile.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> setUserProfile(String userId, Map<String, dynamic> data) async {
    try{
      await _getLatLon(data, {});
      _db.collection('users').doc(userId).set(data);

      DeepfaceApiService.uploadUserPicture(userId, data['profileImage']);
    }
    catch (e){
      throw(e);
    }
  }

  Future<void> changeUserProfile(String userId, Map<String,dynamic> data, Map<String, dynamic> currData) async {
    try{
      await _getLatLon(data, currData);

      _db.collection('users').doc(userId).update(data);

      if(data.containsKey('profileImage')) {
        DeepfaceApiService.uploadUserPicture(userId, data['profileImage']);
      }
    }catch(e){
      throw(e);
    }
    
  }

  Future<Map<String, dynamic>> _getLatLon(Map<String, dynamic> data, Map<String, dynamic> currData) async {
    final city = data['addressCity'] ?? currData['addressCity'];
    final street = data['addressStreet'] ?? currData['addressStreet'];

    List<Location> locations = await locationFromAddress("$street, $city, Switzerland");
    if(locations[0].latitude==46.818188&&locations[0].longitude==8.227511999999999){
      throw("Unknown location");
    }
    data['addressLatitude'] = locations[0].latitude;
    data['addressLongitude'] = locations[0].longitude;

    return data;
  }
}