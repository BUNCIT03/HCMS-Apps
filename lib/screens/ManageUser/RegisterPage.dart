import 'package:flutter/material.dart';
import 'package:hcms_application/controllers/UserController.dart';
import 'package:hcms_application/domains/User.dart';

class RegisterPage extends StatefulWidget {
  final UserController userController;

  const RegisterPage(this.userController, {super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _selectedState;
  String? _selectedRole;

  final List<String> _malaysiaStates = [
    'Johor',
    'Kedah',
    'Kelantan',
    'Malacca',
    'Negeri Sembilan',
    'Pahang',
    'Penang',
    'Perak',
    'Perlis',
    'Sabah',
    'Sarawak',
    'Selangor',
    'Terengganu',
    'Kuala Lumpur',
  ];

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      final newUser = User(
        userId: DateTime.now().millisecondsSinceEpoch, // Example unique ID
        username: _usernameController.text,
        password: _passwordController.text,
        email: _emailController.text,
        fullName: _fullNameController.text,
        phoneNum: _phoneNumberController.text,
        address: _addressController.text,
        state: _selectedState!,
        role: _selectedRole!,
      );

      final isRegistered = await widget.userController.registerUser(newUser);
      if (isRegistered) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful!')),
        );
        Navigator.pop(context);
      } else {
        _showErrorDialog('Username already exists!');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Full Name', _fullNameController),
              SizedBox(height: 16),
              _buildTextField('Username', _usernameController),
              SizedBox(height: 16),
              _buildPasswordField('Password', _passwordController),
              SizedBox(height: 16),
              _buildPasswordField('Confirm Password', _confirmPasswordController),
              SizedBox(height: 16),
              _buildTextField('Email', _emailController),
              SizedBox(height: 16),
              _buildTextField('Phone Number', _phoneNumberController),
              SizedBox(height: 16),
              _buildTextField('Address', _addressController),
              SizedBox(height: 16),
              _buildDropdown('State', _malaysiaStates, (value) {
                setState(() {
                  _selectedState = value;
                });
              }),
              SizedBox(height: 16),
              _buildRoleSelector(),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _registerUser,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        if (label == 'Confirm Password' && value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  Widget _buildDropdown(
      String label, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      items: items.map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select $label';
        }
        return null;
      },
    );
  }

  Widget _buildRoleSelector() {
    return Row(
      children: [
        _buildRoleButton('House Owner', Colors.green),
        SizedBox(width: 16),
        _buildRoleButton('Cleaner', Colors.purple),
      ],
    );
  }

  Widget _buildRoleButton(String role, Color color) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedRole = role;
          });
        },
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _selectedRole == role ? color : Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _selectedRole == role ? color : Colors.grey,
            ),
          ),
          child: Center(
            child: Text(
              role,
              style: TextStyle(
                color: _selectedRole == role ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
