class User {
  int userId = 0;
  String username = '';
  String password = ''; // Should be hashed before saving
  String email = '';
  String fullName = '';
  String phoneNum = '';
  String address = '';
  String state = '';
  String role = '';

  bool get isCleaner => role.toLowerCase() == 'cleaner';
  
  User({
    required this.userId,
    required this.username,
    required this.password,
    required this.email,
    required this.fullName,
    required this.phoneNum,
    required this.address,
    required this.state,
    required this.role,
    
  });

  get id => null;

  bool isValidUsername() => username.isNotEmpty;
  bool isValidPassword() => password.length >= 6;

  bool isValid() => isValidUsername() && isValidPassword();

  // Convert user data to Firestore format
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'password': password,
      'email': email,
      'fullName': fullName,
      'phoneNum': phoneNum,
      'address': address,
      'state': state,
      'role': role,
    };
  }

  // Create a UserModel from Firestore data
  static User fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['userId'] ?? 0,
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      phoneNum: map['phoneNum'] ?? '',
      address: map['address'] ?? '',
      state: map['state'] ?? '',
      role: map['role'] ?? '',
    );
  }
}
