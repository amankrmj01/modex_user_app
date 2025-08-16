import '../models/user_model.dart';

class AuthRepository {
  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email.isNotEmpty && password.isNotEmpty) {
      return UserModel(id: 'user_123', email: email, name: 'Test User');
    } else {
      throw Exception('Invalid credentials');
    }
  }

  Future<UserModel> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
      return UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
      );
    } else {
      throw Exception('Invalid registration data');
    }
  }
}
