import 'package:flutter/foundation.dart';
import '../models/user.dart';

class AuthService with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  
  final List<User> _registeredUsers = [
    User(
      id: '1',
      name: 'Test User',
      email: 'test@test.com',
      password: '123456',
      profileImage: 'https://via.placeholder.com/150',
    ),
    User(
      id: '2', 
      name: 'John Doe',
      email: 'john@test.com',
      password: '123456',
      profileImage: 'https://via.placeholder.com/150',
    ),
    User(
      id: '3',
      name: 'Jane Smith',
      email: 'jane@test.com',
      password: '123456',
      profileImage: 'https://via.placeholder.com/150',
    ),
  ];

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    try {
      print('🔍 LOGIN ATTEMPT: $email');
      
      for (var user in _registeredUsers) {
        if (user.email == email && user.password == password) {
          _user = user;
          _isLoading = false;
          notifyListeners();
          print('✅ LOGIN SUCCESS: Welcome ${user.name}!');
          return true;
        }
      }

      _isLoading = false;
      notifyListeners();
      print('❌ LOGIN FAILED: Invalid email or password');
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('❌ LOGIN ERROR: $e');
      return false;
    }
  }

  Future<bool> signup(String name, String email, String password, String profileImage) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    try {
      print('👤 SIGNUP ATTEMPT: $name ($email)');
      
      for (var user in _registeredUsers) {
        if (user.email == email) {
          _isLoading = false;
          notifyListeners();
          print('❌ SIGNUP FAILED: Email already registered');
          return false;
        }
      }

      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        password: password,
        profileImage: profileImage,
      );

      _registeredUsers.add(newUser);
      _user = newUser;
      
      _isLoading = false;
      notifyListeners();
      
      print('✅ SIGNUP SUCCESS: Account created for $name');
      print('📊 Total users: ${_registeredUsers.length}');
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('❌ SIGNUP ERROR: $e');
      return false;
    }
  }

  void logout() {
    _user = null;
    notifyListeners();
    print('👋 USER LOGGED OUT');
  }

  void printAllUsers() {
    print('=== ALL REGISTERED USERS ===');
    for (var user in _registeredUsers) {
      print('${user.name} | ${user.email} | ${user.password}');
    }
    print('============================');
  }
}