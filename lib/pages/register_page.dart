import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unnispick/components/customelevatedbutotn.dart';
import 'package:unnispick/components/customsnackbar.dart';
import 'package:unnispick/components/customtextformfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void _registerWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    setState(() {
      isLoading = true;
    });

    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Register with email: ${user!.email} Success!'),
          ),
        );
        Navigator.pop(context);
      }
    } catch (error) {
      CustomSnackbar().customSnackBar(
        content: 'Error durig registration: $error',
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextFormField(
              labelText: 'Email',
              textEditingController: emailController,
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              labelText: 'Password',
              textEditingController: passwordController,
            ),
            CustomElevatedButton(
              title: 'Register',
              onPressed: () => _registerWithEmailAndPassword(
                context,
                emailController.text,
                passwordController.text,
              ),
            ),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
