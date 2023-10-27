import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:unnispick/components/customelevatedbutotn.dart';
import 'package:unnispick/components/customsnackbar.dart';
import 'package:unnispick/components/customtextformfield.dart';
import 'package:unnispick/pages/loginbyphone_page.dart';
import 'package:unnispick/pages/register_page.dart';
import 'package:unnispick/components/signin_btn.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : LoginWidget(setLoading: setLoading),
    );
  }
}

class LoginWidget extends StatelessWidget {
  LoginWidget({super.key, required this.setLoading});

  final Function(bool) setLoading;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  Future<void> _signInWithEmailAndPassword(
    BuildContext context,
    String email,
    String password,
  ) async {
    setLoading(true);
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;
      CustomSnackbar().customSnackBar(
        content: 'Welcome $user',
      );
    } catch (error) {
      CustomSnackbar().customSnackBar(
        content: 'Error fetching weather data: $error',
      );
    } finally {
      setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          CustomTextFormField(
            labelText: 'Email',
            textEditingController: emailController,
          ),
          const SizedBox(height: 8),
          CustomTextFormField(
            labelText: 'Password',
            textEditingController: passwordController,
          ),
          const SizedBox(height: 16),
          CustomElevatedButton(
            title: 'Login',
            onPressed: () => _signInWithEmailAndPassword(
              context,
              emailController.text,
              passwordController.text,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GoogleSignInButton(context: context),
              const SizedBox(width: 16),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginByPhone(),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  elevation: MaterialStateProperty.all<double>(0),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                child: const Icon(
                  Icons.phone,
                  size: 20,
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            children: [
              const Text("Don't have an account?"),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RegisterPage(),
                    ),
                  );
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
