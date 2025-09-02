import 'package:flutter/material.dart';
import 'package:task_manager/models/user_profile_model.dart';
import 'package:task_manager/services/user_profile_service.dart';

class UserProfileProvider with ChangeNotifier {
  final UserProfileService _userProfileService = UserProfileService();
  UserProfile _userProfile = UserProfile.empty;
  List<UserProfile> _userProfiles = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  UserProfile get userProfile => _userProfile;
  List<UserProfile> get userProfiles => _userProfiles;

  UserProfileProvider() {
    _init();
  }

  Future<void> _init() async {
    await _loadUserProfile();
    await _loadUserProfiles();
  }

  Future<void> _loadUserProfile() async {
    final user = _userProfileService.auth.currentUser;
    if (user != null) {
      setLoading(true);
      _userProfile = await _userProfileService.fetchUserProfile(user.uid);
      setLoading(false);
      notifyListeners();
    }
  }

  Future<void> loadUserProfileWithId(String userId) async {
    setLoading(true);
    _userProfile = await _userProfileService.fetchUserProfile(userId);
    setLoading(false);
    notifyListeners();
  }

  Future<void> _loadUserProfiles() async {
    setLoading(true);
    await _loadUserProfile();

    if(!userProfile.isAdmin) { 
      _userProfiles = [];
    }
    else {
      _userProfiles = await _userProfileService.fetchAllUserProfiles();
    }

    setLoading(false);
    notifyListeners();
  }

  void loadUserProfile() {
    _loadUserProfile();
  }

  void loadUserProfiles() {
    _loadUserProfiles();
  }

  void setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  Future<void> setUserProfile(Map<String, dynamic> data) async {
    final user = _userProfileService.auth.currentUser;
    if (user != null) {
      try{
        await _userProfileService.setUserProfile(user.uid, data);
      }
      catch (e){
        throw(e);
      }
    }
    await _loadUserProfile();
    notifyListeners();
  }

  Future<void> changeUserProfile(Map<String,dynamic> data) async{
    final user = _userProfileService.auth.currentUser;
    
    if (user != null) {
      try{
        await _userProfileService.changeUserProfile(user.uid, data, _userProfile.toMap());
      }catch(e){
        
      }
    }
    await _loadUserProfile();
    notifyListeners();
  }
}