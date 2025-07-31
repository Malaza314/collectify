import 'package:collectify/Widgets/themedata.dart';
import 'package:collectify/Widgets/utils.dart';
import 'package:collectify/controllers/auth_controller.dart';
import 'package:collectify/pages/add_credit_card_page.dart';
import 'package:collectify/pages/admin_portal.dart';
import 'package:collectify/pages/customer_details.dart';
import 'package:collectify/pages/customers.dart';
import 'package:collectify/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collectify/controllers/app_controller.dart';
import 'package:collectify/pages/LoginPage.dart';
import 'package:collectify/pages/Sign_Up.dart';
import 'package:collectify/pages/about.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:universal_html/html.dart' as html;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Sign out before unload on web.
  html.window.onBeforeUnload.listen((_) {
    FirebaseAuth.instance.signOut();
  });

  Get.put(AuthController());
  Get.put(AppController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Collectify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blueGrey,
      ),
      routes: {
        '/': (context) => const WelcomePage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/about': (context) => const AboutPage(),
        '/HomePage': (context) => const HomePage(),
        '/customers': (context) => const Customers(),
        '/add_credit_card': (context) => const AddCreditCardPage(),
        '/admin_portal': (context) => const AdminPortalPage(),
      },
      initialRoute: '/',
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Updated drawer with a modern design.
      drawer: Drawer(
        backgroundColor: Colors.white.withOpacity(0.95),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF3949AB), Color(0xFF1A237E)],
                ),
              ),
              child: Center(
                child: Text(
                  'Collectify Menu',
                  style: contentTextStyle(
                    fontSize: 26,
                    fontColor: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.home,
              title: 'Home',
              routeName: '/',
            ),
            _buildDrawerItem(
              context,
              icon: Icons.login,
              title: 'Login',
              routeName: '/login',
            ),
            _buildDrawerItem(
              context,
              icon: Icons.app_registration,
              title: 'Sign Up',
              routeName: '/signup',
            ),
            _buildDrawerItem(
              context,
              icon: Icons.info_outline,
              title: 'About',
              routeName: '/about',
            ),
          ],
        ),
      ),
      
      appBar: AppBar(
        title: const Text('Collectify'),
        titleTextStyle: contentTextStyle(
          fontSize: 24,
          fontColor: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF3949AB),
        elevation: 0,
      ),
      // Use a full-screen Stack with a background image and dark overlay.
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'background.jpg', // Ensure this image exists and is declared in pubspec.yaml.
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Card(
                color: Colors.white.withOpacity(0.9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 10,
                margin: const EdgeInsets.symmetric(vertical: 48),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Modern welcome title.
                      Text(
                        "Welcome to Collectify",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: const Color(0xFF3949AB),
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 20),
                      // Subtitle with a brief description.
                      Text(
                        "Revolutionize your loan collections with effortless automation.\n\n"
                        "Secure · Fast · Reliable",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.black87,
                              height: 1.5,
                            ),
                      ),
                      const SizedBox(height: 40),
                      // Modern styled Login button.
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(250, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF3949AB),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          elevation: 5,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: const Text('Login'),
                      ),
                      const SizedBox(height: 16),
                      // Modern styled Sign Up button.
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(250, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF3949AB),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          elevation: 5,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for drawer items.
  ListTile _buildDrawerItem(BuildContext context,
      {required IconData icon, required String title, required String routeName}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF3949AB)),
      title: Text(title, style: const TextStyle(fontSize: 18)),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, routeName);
      },
    );
  }
}