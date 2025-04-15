import 'package:collectify/Widgets/loading_overlay.dart';
import 'package:collectify/Widgets/obscuring_textfield.dart';
import 'package:collectify/Widgets/utils.dart';
import 'package:collectify/init_packages.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/services.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // Controllers for the signup form
  final TextEditingController _usernameController   = TextEditingController();
  final TextEditingController _surnameController    = TextEditingController();
  final TextEditingController _idNumberController   = TextEditingController();
  final TextEditingController _emailController      = TextEditingController();
  final TextEditingController _passwordController   = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController(); // Added phone number controller

  // Dummy file upload variables
  String? _idFileName;
  String? _LendingLicenseFileName;

  @override
  void dispose() {
    _usernameController.dispose();
    _surnameController.dispose();
    _idNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneNumberController.dispose(); // Dispose phone number controller
    super.dispose();
  }

  void _signup() async {
    // Retrieve form values
    final String username        = _usernameController.text.trim();
    final String surname         = _surnameController.text.trim();
    final String idNumber        = _idNumberController.text.trim();
    final String phoneNumber     = _phoneNumberController.text.trim(); // Retrieve phone number
    final String email           = _emailController.text.trim();
    final String password        = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    // Basic validation
    if (username.isEmpty ||
        surname.isEmpty ||
        idNumber.isEmpty ||
        phoneNumber.isEmpty || // Validate phone number
        email.isEmpty ||
        _idFileName == null ||
        _LendingLicenseFileName == null ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    try {
      appController.setIsLoading = true; // Show loading overlay
      // Call the cloud function "createUser"
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('createUser');
      final results = await callable.call(<String, dynamic>{
        'username': username,
        'surname': surname,
        'idNumber': idNumber,
        'phoneNumber': phoneNumber, // Include phone number
        'email': email,
        'password': password,
        'idFile': appController.uploadIdBase64,
        'LendingLicenseFile': appController.uploadLendingLicenseBase64,
      });
      debugPrint("Cloud Function response: ${results.data}");

      appController.setIsLoading = false; // Hide loading overlay
      Navigator.pushNamed(context, '/login');
    } catch (error) {
      appController.setIsLoading = false; // Hide loading overlay
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup failed: $error")),
      );
    }
  }

  // Functions for file uploads using file_picker for documents and image_picker for selfie
  Future<void> _pickIdDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
    );
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      setState(() {
      _idFileName = file.name;
    });
      // Convert the file to base64 string
      appController.setUploadIdBase64(value: file.bytes.toString());
    
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Certified Copy of ID (PDF) selected")),
      );
    }
  }

  Future<void> _pickLendingLicenseDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
    );
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      setState(() {
      _LendingLicenseFileName = file.name;
    });
      // Convert the file to base64 string
      appController.setUploadLendingLicenseBase64(value: file.bytes.toString());
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Certified Copy of LendingLicense (PDF) selected")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Increased height for larger textfields
    const double fieldHeight = 70;
    return LoadingOverlay(
      child: Scaffold(
        appBar: appBar(
          context,
          automaticallyImplyLeading: true,
          titleText: "Sign Up",
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              spacer1(),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  "Please note that documents submitted are legit and recently certified as they will be used in verifying",
                  textAlign: TextAlign.center,
                  style: contentTextStyle(
                    fontSize: h3,
                    fontColor: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: fieldHeight,
                child: ObscuringTextField(
                  textEditingController: _usernameController,
                  labelText: 'Username',
                  textInputType: TextInputType.text,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: fieldHeight,
                child: ObscuringTextField(
                  textEditingController: _surnameController,
                  labelText: 'Surname',
                  textInputType: TextInputType.text,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: fieldHeight,
                child: ObscuringTextField(
                  textEditingController: _idNumberController,
                  labelText: 'ID Number',
                  textInputType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: fieldHeight,
                child: ObscuringTextField(
                  textEditingController: _phoneNumberController,
                  labelText: 'Phone Number',
                  textInputType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: fieldHeight,
                child: ObscuringTextField(
                  textEditingController: _emailController,
                  labelText: 'Email',
                  textInputType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: 24),
              // File upload fields using updated button styles
              ElevatedButton(
                onPressed: _pickIdDocument,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(1000, 50), // Fixed width of 200; adjust as desired
                ),
                child: Text(
                  _idFileName == null ? "Upload Cerfied Copy of ID (PDF)" : "ID: $_idFileName",
                  style: contentTextStyle(
                    fontSize: h4,
                    fontColor: const Color(0xFF00008B), // Dark blue color
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickLendingLicenseDocument,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(1000, 50), // Fixed width of 200; adjust as desired
                ),
                child: Text(
                  _LendingLicenseFileName == null ? "Upload Certified Copy of Lending License (PDF)" : "Lending License: $_LendingLicenseFileName",
                  style: contentTextStyle(
                    fontSize: h4,
                    fontColor: const Color(0xFF00008B), // Dark blue color
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ), 
              const SizedBox(height: 16),
              
              const SizedBox(height: 24),
              SizedBox(
                height: fieldHeight,
                child: Obx(() => ObscuringTextField(
                      textEditingController: _passwordController,
                      labelText: 'Password',
                      obscureText: appController.obscureSignUpPassword,
                      toggleObscureText: () => appController.setObscureSignUpPassword(),
                      textInputType: TextInputType.visiblePassword,
                    )),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: fieldHeight,
                child: Obx(() => ObscuringTextField(
                      textEditingController: _confirmPasswordController,
                      labelText: 'Confirm Password',
                      obscureText: appController.obscureConfirmSignUpPassword,
                      toggleObscureText: () => appController.setObscureConfirmSignUpPassword(),
                      textInputType: TextInputType.visiblePassword,
                    )),
              ),
              const SizedBox(height: 24),
              customElevatedButton(onPressed: () => _signup(), text: "Sign Up"),
              spacer1(), // Extra spacing at the bottom for scrollability
            ],
          ),
        ),
      ),
    );
  }
}