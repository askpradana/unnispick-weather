import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unnispick/components/customdialogbox.dart';
import 'package:unnispick/components/customelevatedbutotn.dart';
import 'package:unnispick/components/customsnackbar.dart';
import 'package:unnispick/components/customtextformfield.dart';

class LoginByPhone extends StatefulWidget {
  const LoginByPhone({super.key});

  @override
  State<LoginByPhone> createState() => _LoginByPhoneState();
}

class _LoginByPhoneState extends State<LoginByPhone> {
  final TextEditingController numberController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  String verifId = '';
  bool isVerifying = false;

  Future<void> sendVerificationCode(
    BuildContext context,
    String phoneNumber,
  ) async {
    try {
      // Set loading state while sending verification code
      setState(() {
        isVerifying = true;
      });

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          // The verification is automatically completed.
          // You can proceed with signing in the user.
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackbar().customSnackBar(
              content: 'Phone number verified. Logging in...',
            ),
          );
          // You can proceed with signing in the user.
        },
        verificationFailed: (FirebaseAuthException e) {
          // Handle verification failure, such as an invalid phone number.
          setState(() {
            isVerifying = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackbar().customSnackBar(
              content: 'Error: $e',
            ),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          // Store the verification ID to use it when the user enters the code.
          // You can also navigate to the code verification screen.
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackbar().customSnackBar(
              content:
                  'OTP sent to your phone. The OTP is harcoded to 123456 for testing.',
            ),
          );
          setState(() {
            verifId = verificationId;
            isVerifying = false;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // The automatic code retrieval timed out.
        },
      );
    } catch (e) {
      // Handle errors during code verification
      setState(() {
        isVerifying = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackbar().customSnackBar(
          content: 'Error: $e',
        ),
      );
    }
  }

  Future<void> verifyCodeAndSignIn(String verificationId, String otp) async {
    try {
      setState(() {
        isVerifying = true;
      });

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = authResult.user;

      setState(() {
        isVerifying = false;
      });
      CustomSnackbar().customSnackBar(
        content: 'Success login with $user',
      );
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      setState(() {
        isVerifying = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackbar().customSnackBar(
          content: 'Error: $e',
        ),
      );
    }
  }

  // na

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextFormField(
              labelText: 'Phone Number',
              textEditingController: numberController,
              hintText: '+62851123456',
            ),
            CustomElevatedButton(
              title: 'Login',
              onPressed: () {
                CustomDialogBox().showSimpleDialog(
                  context,
                  'For development purposes',
                  'I will hardcode the number to send OTP. Do you want to continue?',
                  () {
                    Navigator.pop(context);
                    sendVerificationCode(
                      context,
                      '+62851123456',
                    );
                  },
                );
              },
            ),
            CustomTextFormField(
              labelText: 'OTP',
              textEditingController: otpController,
              hintText: '123456',
            ),
            CustomElevatedButton(
              title: 'OTP',
              onPressed: () {
                if (verifId.isNotEmpty) {
                  verifyCodeAndSignIn(verifId, '123456');
                }
              },
            ),
            if (isVerifying)
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
