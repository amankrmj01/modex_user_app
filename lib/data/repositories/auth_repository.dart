import '../models/user_model.dart';

class AuthRepository {
  // Simulate a network call
  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    // In a real app, you'd check credentials. Here, we'll always succeed.
    if (email.isNotEmpty && password.isNotEmpty) {
      return UserModel(id: 'user_123', email: email, name: 'Test User');
    } else {
      throw Exception('Invalid credentials');
    }
  }
}
