class User {
  int user_id = 0;
  String username = '';
  String password = ''; // The password will be hashed before saving
  String email = '';
  String full_name = '';
  String phone_num = '';
  String address = '';
  String role = '';

  bool isValidUsername() => username.isNotEmpty;
  bool isValidPassword() => password.length >= 6;

  bool isValid() => isValidUsername() && isValidPassword();

  // Convert user data to Firestore format
  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'username': username,
      'password': password,
      'email': email,
      'full_name': full_name,
      'phone_num': phone_num,
      'address': address,
      'role': role,
    };
  }

  // Create a UserModel from Firestore data
  static User fromMap(Map<String, dynamic> map) {
    return User()
      ..username = map['username']
      ..password = map['password'];
  }
}
