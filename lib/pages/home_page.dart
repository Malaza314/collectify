// ignore_for_file: use_build_context_synchronously

import 'package:cloud_functions/cloud_functions.dart';
import 'package:collectify/Widgets/loading_overlay.dart';
import 'package:collectify/Widgets/themedata.dart';
import 'package:collectify/Widgets/utils.dart';
import 'package:collectify/init_packages.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Custom Hover Card without borders.
  Widget hoverCard({required String title, required VoidCallback onTap}) {
    // 1.5cm approximately equals 57 pixels (1 inch = 2.54cm, 96px/inch)
    const double cardSize = 70;
    return _HoverCard(
      title: title,
      size: cardSize,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      child: Scaffold(
        appBar: appBar(
          context,
          automaticallyImplyLeading: false,
          titleText: "Home",
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              hoverCard(
                title: "Customers",
                onTap: () => _handleCardTap(
                  context: context,
                  route: '/customers',
                ),
              ),
              hoverCard(
                title: "Add Credit card",
                onTap: () => Navigator.pushNamed(context, '/add_credit_card'),
              ),

              hoverCard(
                title: "Admin Portal",
                onTap: () =>
                //  _handleCardTapadmin(context: context
                //   , route: '/admin_portal'),
                Navigator.pushNamed(context, '/admin_portal'),
              ),

              // hoverCard(
              //   title: "Reports",
              //   onTap: () => Navigator.pushNamed(context, '/reports'),
              // ),
              // hoverCard(
              //   title: "Settings",
              //   onTap: () => Navigator.pushNamed(context, '/settings'),
              // ),
              // hoverCard(
              //   title: "Notifications",
              //   onTap: () => Navigator.pushNamed(context, '/notifications'),
              // ),
              // hoverCard(
              //   title: "Profile",
              //   onTap: () => Navigator.pushNamed(context, '/profile'),
              // ),
              // hoverCard(
              //   title: "Help",
              //   onTap: () => Navigator.pushNamed(context, '/help'),
              // ),
              // hoverCard(
              //   title: "Help",
              //   onTap: () => Navigator.pushNamed(context, '/help'),
              // ),
              // hoverCard(
              //   title: "Help",
              //   onTap: () => Navigator.pushNamed(context, '/help'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HoverCard extends StatefulWidget {
  final String title;
  final double size;
  final VoidCallback onTap;
  const _HoverCard({
    required this.title,
    required this.size,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool isHovering = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() { isHovering = true; }),
      onExit: (_) => setState(() { isHovering = false; }),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: isHovering ? Colors.grey.shade300 : blue,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isHovering ? 0.3 : 0.15),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: contentTextStyle(
                fontSize: h4,
                fontWeight: FontWeight.bold,
                fontColor: Colors.blueGrey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _handleCardTap({
  required BuildContext context,
  required String route,
}) async {
  try {
    appController.setIsLoading = true;
    // Call the cloud function "fetchCustomers"
    final callable = functions.httpsCallable('fetchCustomers');
    final results = await callable.call({});
    debugPrint("FetchCustomers response: ${results.data}");
    // Pass the fetched data as arguments to the customers page
    appController.setAllCustomers(value: results.data["customers"]);
    Navigator.pushNamed(context, route);
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $error")),
    );
  } finally {
    appController.setIsLoading = false;
  }
}

// Future<void> _handleCardTapadmin({
//   required BuildContext context,
//   required String route,
// }) async {
//   try {
//     appController.setIsLoading = true;
//     // Call the cloud function "fetchUserData"
//     final callable = functions.httpsCallable('fetchUserData');
//     final results = await callable.call({});
//     debugPrint("fetchUserData response: ${results.data}");
//     // Pass the fetched data as arguments to the customers page
//     appController.setAllUsers(value: results.data["users"]);
//     Navigator.pushNamed(context, route);
//   } catch (error) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Error: $error")),
//     );
//   } finally {
//     appController.setIsLoading = false;
//   }
// }