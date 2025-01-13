class User {
  String username = '';
  String password = ''; // The password will be hashed before saving

  bool isValidUsername() => username.isNotEmpty;
  bool isValidPassword() => password.length >= 6;

  bool isValid() => isValidUsername() && isValidPassword();

  // Convert user data to Firestore format
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
    };
  }

  // Create a UserModel from Firestore data
  static User fromMap(Map<String, dynamic> map) {
    return User()
      ..username = map['username']
      ..password = map['password'];
  }
}
