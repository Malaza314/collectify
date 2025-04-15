import 'package:collectify/Widgets/themedata.dart';
import 'package:collectify/Widgets/utils.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  void _launchEmail() async {
    // Replace with your email launch logic
    final Uri emailUri = Uri(scheme: 'mailto', path: 'support@collectify.com');
    // e.g., await launchUrl(emailUri);
  }

  void _launchPhone() async {
    // Replace with your phone launch logic
    final Uri phoneUri = Uri(scheme: 'tel', path: '+27646099136');
    // e.g., await launchUrl(phoneUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        context,
        automaticallyImplyLeading: true,
        titleText: "About Collectify",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 120, // Adjust the size of the avatar as needed
                  backgroundImage: const AssetImage('lib/assets/about_us.jpg'),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'About Collectify',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Collectify is an innovative app designed to simplify loan collections. Our platform streamlines the process and offers a user-friendly experience for managing financial tasks.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'Contact',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              ListTile(
                leading: const Icon(Icons.email, color: Colors.blueAccent),
                title: const Text('support@collectify.com'),
                onTap: _launchEmail,
              ),
              ListTile(
                leading: const Icon(Icons.phone, color: Colors.green),
                title: const Text('+1234567890'),
                onTap: _launchPhone,
              ),
              const Divider(),
              const Text(
                'Our Office',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const ListTile(
                leading: Icon(Icons.location_on, color: Colors.redAccent),
                title: Text(
                  '123 Main Street, Suite 456, Your City, Your Country',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}