import 'package:chatapp/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController _oldPasswordController = TextEditingController();
    TextEditingController _newPasswordController = TextEditingController();
    TextEditingController _confirmPasswordController = TextEditingController();

    final _auth = FirebaseAuth.instance;

    void _changePassword() async {
      try {
        User? user = _auth.currentUser;
        if (user != null) {
          // Thay đổi mật khẩu
          await user.updatePassword(_newPasswordController.text);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Password changed successfully.'),
          ));
          Navigator.pop(context); // Quay lại màn hình trước đó
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('User not found.'),
          ));
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to change password: $error'),
        ));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),

            //Old Password:
            MyTextField(
              hintText: "Old Password",
              obscureText: true,
              controller: _oldPasswordController,
            ),

            const SizedBox(height: 20),

            //New Password:
            MyTextField(
              hintText: "New Password",
              obscureText: true,
              controller: _newPasswordController,
            ),

            const SizedBox(height: 20),

            //Confirm Password
            MyTextField(
              hintText: "New Password",
              obscureText: true,
              controller: _confirmPasswordController,
            ),

            SizedBox(height: 20),

            Container(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: _changePassword,
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
