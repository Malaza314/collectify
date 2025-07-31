import 'package:collectify/Widgets/themedata.dart';
import 'package:collectify/Widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(scheme: 'mailto', path: 'support@collectify.com');
    if (!await launchUrl(emailUri)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not launch email client")),
      );
    }
  }

  Future<void> _launchPhone() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '+27646099136');
    if (!await launchUrl(phoneUri)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not launch phone dialer")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        context,
        automaticallyImplyLeading: true,
        titleText: "About Collectify",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // About header and description block
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.only(bottom: 24),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About Collectify',
                      style: contentTextStyle(
                        fontSize: 26,
                        fontColor: const Color(0xFF3949AB),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Collectify is an innovative app designed to simplify loan collections. '
                      'Our platform streamlines the process, making it user-friendly and efficient '
                      'for managing financial tasks. By leveraging modern technology, Collectify strives '
                      'to provide secure, fast, and reliable services to its users.',
                      style: TextStyle(fontSize: 16, height: 1.5),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
            // Contact Information Section
            Text(
              'Contact Information',
              style: contentTextStyle(
                fontSize: 20,
                fontColor: const Color(0xFF3949AB),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Email row
                    Row(
                      children: [
                        Icon(Icons.email, color: Colors.blueAccent),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'support@collectify.com',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _launchEmail,
                          child: const Text('Email'),
                        ),
                      ],
                    ),
                    const Divider(),
                    // Phone row
                    Row(
                      children: [
                        Icon(Icons.phone, color: Colors.green),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            '+27646099136',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _launchPhone,
                          child: const Text('Call'),
                        ),
                      ],
                    ),
                    const Divider(),
                    // Office address row (static text)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on, color: Colors.redAccent),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            '52 Sloane Street, The Campus, Bryanston, South Africa',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Mission Statement Section (Optional)
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Our Mission',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3949AB),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'To revolutionize loan collections by delivering an automated, easy-to-use, '
                      'and secure platform that adapts to the needs of its users.',
                      style: TextStyle(fontSize: 16, height: 1.5),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}