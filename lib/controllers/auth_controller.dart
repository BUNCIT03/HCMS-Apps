// controller/auth_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hcms_application/domains/user_model.dart';

class AuthController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> isUserRegistered() async {
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs.isNotEmpty;
  }

  Future<bool> registerUser(UserModel user) async {
    if (user.isValid()) {
      try {
        await _firestore
            .collection('users')
            .doc(user.username)
            .set(user.toMap());
        return true;
      } catch (e) {
        print('Error registering user: $e');
        return false;
      }
    }
    return false;
  }

  Future<bool> loginUser(String username, String password) async {
    try {
      final doc = await _firestore.collection('users').doc(username).get();
      if (doc.exists) {
        final user = UserModel.fromMap(doc.data()!);
        return user.password ==
            password; // Replace with hashed password verification
      }
    } catch (e) {
      print('Error logging in user: $e');
    }
    return false;
  }

  Future<void> logoutUser() async {
    // Perform cleanup logic, if needed
    print("User logged out.");
  }
}
