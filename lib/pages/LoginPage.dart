import 'package:cloud_functions/cloud_functions.dart';
import 'package:collectify/Widgets/loading_overlay.dart';
import 'package:collectify/Widgets/obscuring_textfield.dart';
import 'package:collectify/Widgets/themedata.dart';
import 'package:collectify/Widgets/utils.dart';
import 'package:collectify/init_packages.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController    = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }
    
    try {
      // Set loading true
      appController.setIsLoading = true;
      await authController.signIn(email: email, password: password);
      // Call the cloud function "login" with email and password.
      final callable = functions.httpsCallable('login');
      final results = await callable.call({});
      
      debugPrint("Cloud Function login response: ${results.data}");
      final success = results.data['success'];
      final message = results.data['message'];
       // Set loading false after success and navigate to the next page
      appController.setIsLoading = false;
      // Navigate to the next page (update '/next' to your desired route)
      if (!success) {
        showScaffoldMessenger(
          context: context, 
          message: message,
          isError: true
        );

        return;
      }
      
      Navigator.pushNamed(context, '/HomePage');
    } catch (error) {
       // Set loading false in case of error and show error message
      appController.setIsLoading = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      child: Scaffold(
        appBar: appBar(
          context,
          automaticallyImplyLeading: true,
          titleText: "Login",
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              spacer1(),
              ObscuringTextField(
                textEditingController: _emailController,
                labelText: 'Email',
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              Obx(() => ObscuringTextField(
                textEditingController: _passwordController,
                labelText: 'Password',
                obscureText: appController.obscureLoginPassword,
                toggleObscureText: () => appController.setobscureLoginPassword(),
                textInputType: TextInputType.visiblePassword,
              )),
              const SizedBox(height: 24),
              customElevatedButton(onPressed: () => _login(), text: "Login"),
            ],
          ),
        ),
      ),
    );
  }
}