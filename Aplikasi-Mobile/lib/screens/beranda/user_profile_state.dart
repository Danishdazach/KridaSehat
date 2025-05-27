// user_profile_state.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileState extends ChangeNotifier {
  // Proper singleton implementation
  static final UserProfileState _instance = UserProfileState._internal();
  factory UserProfileState() => _instance;
  UserProfileState._internal();

  bool _isProfileComplete = false;
  String _userName = '';
  String _userClass = '';
  List<String> _schedulePreferences = [];
  bool _isLoaded = false; // Add loading flag

  // Getters
  bool get isProfileComplete => _isProfileComplete;
  String get userName => _userName;
  String get userClass => _userClass;
  List<String> get schedulePreferences => _schedulePreferences;
  bool get isLoaded => _isLoaded;

  // Load profile status from SharedPreferences
  Future<void> loadProfileStatus() async {
    if (_isLoaded) return; // Prevent multiple loads
    
    final prefs = await SharedPreferences.getInstance();
    _isProfileComplete = prefs.getBool('profile_complete') ?? false;
    _userName = prefs.getString('user_name') ?? '';
    _userClass = prefs.getString('user_class') ?? '';
    _schedulePreferences = prefs.getStringList('schedule_preferences') ?? [];
    _isLoaded = true;
    
    notifyListeners();
  }

  // Save profile data and mark as complete
  Future<void> saveProfile({
    required String name,
    required String className,
    required List<String> schedulePrefs,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setBool('profile_complete', true);
    await prefs.setString('user_name', name);
    await prefs.setString('user_class', className);
    await prefs.setStringList('schedule_preferences', schedulePrefs);
    
    _isProfileComplete = true;
    _userName = name;
    _userClass = className;
    _schedulePreferences = schedulePrefs;
    
    notifyListeners();
  }

  // Reset profile (for testing or logout)
  Future<void> resetProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('profile_complete');
    await prefs.remove('user_name');
    await prefs.remove('user_class');
    await prefs.remove('schedule_preferences');
    
    _isProfileComplete = false;
    _userName = '';
    _userClass = '';
    _schedulePreferences = [];
    
    notifyListeners();
  }
}