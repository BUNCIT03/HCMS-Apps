import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hcms_application/domains/User.dart';

class UserController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Check if a user is registered by username
  Future<bool> isUserRegistered(String username) async {
    final doc = await _firestore.collection('users').doc(username).get();
    return doc.exists;
  }

  // Register a new user
  Future<bool> registerUser(User user) async {
    if (user.isValid()) {
      try {
        final isRegistered = await isUserRegistered(user.username);
        if (!isRegistered) {
          await _firestore.collection('users').doc(user.username).set(user.toMap());
          return true;
        }
        return false; // Username already exists
      } catch (e) {
        print('Error registering user: $e');
        return false;
      }
    }
    return false; // Validation failed
  }

  // Login user
  Future<bool> loginUser(String username, String password) async {
    try {
      final doc = await _firestore.collection('users').doc(username).get();
      if (doc.exists) {
        final user = User.fromMap(doc.data()!);
        return user.password == password; // Replace with hashed password verification
      }
    } catch (e) {
      print('Error logging in user: $e');
    }
    return false;
  }

  // Update user details
  Future<bool> updateUser(String username, User updatedUser) async {
    try {
      final isRegistered = await isUserRegistered(username);
      if (isRegistered) {
        await _firestore.collection('users').doc(username).update(updatedUser.toMap());
        return true;
      }
      return false; // User does not exist
    } catch (e) {
      print('Error updating user: $e');
      return false;
    }
  }

  // Delete a user
  Future<bool> deleteUser(String username) async {
    try {
      final isRegistered = await isUserRegistered(username);
      if (isRegistered) {
        await _firestore.collection('users').doc(username).delete();
        return true;
      }
      return false; // User does not exist
    } catch (e) {
      print('Error deleting user: $e');
      return false;
    }
  }

  // Fetch all users
  Future<List<User>> fetchAllUsers() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      return snapshot.docs.map((doc) => User.fromMap(doc.data())).toList();
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  // Fetch a user by username
Future<User?> fetchUserByUsername(String username) async {
  try {
    final doc = await _firestore.collection('users').doc(username).get();
    if (doc.exists) {
      return User.fromMap(doc.data()!);
    }
  } catch (e) {
    print('Error fetching user: $e');
  }
  return null;
}

void testFetchUser(UserController userController, String username) async {
  final user = await userController.fetchUserByUsername(username);
  if (user != null) {
    print('User found: ${user.fullName}');
  } else {
    print('User not found');
  }
}

}
