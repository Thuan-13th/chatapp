import 'package:chatapp/components/my_button.dart';
import 'package:chatapp/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController oldPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    final auth = FirebaseAuth.instance;

    void changePassword() async {
      try {
        User? user = auth.currentUser;
        if (user != null) {
          // Thay đổi mật khẩu
          await user.updatePassword(newPasswordController.text);
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Password changed successfully.'),
          ));
          // ignore: use_build_context_synchronously
          Navigator.pop(context); // Quay lại màn hình trước đó
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('User not found.'),
          ));
        }
      } catch (error) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to change password: $error'),
        ));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),

            //Old Password:
            MyTextField(
              hintText: "Old Password",
              obscureText: true,
              controller: oldPasswordController,
            ),

            const SizedBox(height: 20),

            //New Password:
            MyTextField(
              hintText: "New Password",
              obscureText: true,
              controller: newPasswordController,
            ),

            const SizedBox(height: 20),

            //Confirm Password
            MyTextField(
              hintText: "New Password",
              obscureText: true,
              controller: confirmPasswordController,
            ),

            const SizedBox(height: 20),

            //Change Password button
            Container(
              alignment: Alignment.center,
              // padding: const EdgeInsets.all(25),
              child: MyButton(
                text: "Change Password",
                onTap: () => changePassword(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
