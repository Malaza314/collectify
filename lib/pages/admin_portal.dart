import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:collectify/Widgets/loading_overlay.dart';
import 'package:collectify/Widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminPortalPage extends StatefulWidget {
  const AdminPortalPage({Key? key}) : super(key: key);

  @override
  State<AdminPortalPage> createState() => _AdminPortalPageState();
}

class _AdminPortalPageState extends State<AdminPortalPage> {
  String _searchQuery = "";

  Future<List<dynamic>> _fetchUserData() async {
    try {
      final callable = FirebaseFunctions.instance.httpsCallable('fetchUserData');
      final results = await callable.call();
      if (results.data != null && results.data['users'] is List<dynamic>) {
        return results.data['users'] as List<dynamic>;
      }
      return [];
    } catch (error) {
      throw Exception("Error fetching user data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      child: Scaffold(
        appBar: appBar(
          context,
          automaticallyImplyLeading: true,
          titleText: "Admin Portal",
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
              // icon color: Colors.white,
              color: Colors.white,
              onPressed: () {
                setState(() {}); // Refresh the page
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Search bar on top:
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),
            // Expanded FutureBuilder for list
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _fetchUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  final customers = snapshot.data!;
                  if (customers.isEmpty) {
                    return const Center(child: Text("No customer data found"));
                  }
                  // Filter customers based on _searchQuery on all fields
                  final filteredCustomers = customers.where((customer) {
                    final Map<String, dynamic> cust = customer;
                    final combined = "${cust['username'] ?? ''} ${cust['surname'] ?? ''} ${cust['email'] ?? ''} ${cust['phone_number'] ?? ''}".toLowerCase();
                    return combined.contains(_searchQuery);
                  }).toList();
                  if (filteredCustomers.isEmpty) {
                    return const Center(child: Text("No matching customer data found"));
                  }
                  return ListView.builder(
                    itemCount: filteredCustomers.length,
                    itemBuilder: (context, index) {
                      final customer = filteredCustomers[index] as Map<String, dynamic>;
                      final name = customer['username'] ?? 'No Name';
                      final surname = customer['surname'] ?? '';
                      final email = customer['email'] ?? '';
                      final phone = customer['phone_number'] ?? '';
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        elevation: 2,
                        child: ListTile(
                          title: Text(
                            "$name $surname",
                            style: contentTextStyle(
                                fontSize: h4,
                                fontWeight: FontWeight.bold,
                                fontColor: Colors.black),
                          ),
                          subtitle: Text(
                            "Email: $email\nPhone: $phone",
                            style: contentTextStyle(
                                fontSize: h4,
                                fontWeight: FontWeight.normal,
                                fontColor: Colors.grey),
                          ),
                          onTap: () {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.info,
                              animType: AnimType.scale,
                              title: "$name $surname",
                              body: Column(
                                children: [
                                  Text(
                                    "Let's Approve $name",
                                    style: contentTextStyle(
                                      fontSize: h4,
                                      fontWeight: FontWeight.bold,
                                      fontColor: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // ListTile for Lending License File
                                  ListTile(
                                    title: const Text(
                                      'Lending License',
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: Text(
                                      customer['Lending_license_file'] != null &&
                                              customer['Lending_license_file'].toString().isNotEmpty
                                          ? 'Available'
                                          : 'N/A',
                                    ),
                                    trailing: customer['Lending_license_file'] != null &&
                                            customer['Lending_license_file'].toString().isNotEmpty
                                        ? const Icon(Icons.open_in_new)
                                        : null,
                                    onTap: () async {
                                      final link = customer['Lending_license_file'];
                                      if (link != null && link.toString().isNotEmpty) {
                                        final Uri uri = Uri.parse(link.toString());
                                        if (await canLaunchUrl(uri)) {
                                          await launchUrl(uri);
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('No valid link available')),
                                          );
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('No valid link available')),
                                        );
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  // ListTile for ID File
                                  ListTile(
                                    title: const Text(
                                      'ID File',
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: Text(
                                      customer['id_file'] != null && customer['id_file'].toString().isNotEmpty
                                          ? 'Available'
                                          : 'N/A',
                                    ),
                                    trailing: customer['id_file'] != null && customer['id_file'].toString().isNotEmpty
                                        ? const Icon(Icons.open_in_new)
                                        : null,
                                    onTap: () async {
                                      final link = customer['id_file'];
                                      if (link != null && link.toString().isNotEmpty) {
                                        final Uri uri = Uri.parse(link.toString());
                                        if (await canLaunchUrl(uri)) {
                                          await launchUrl(uri);
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('No valid link available')),
                                          );
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('No valid link available')),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                              btnCancelOnPress: () {},
                              btnOkOnPress: () async {
                                try {
                                  final callable = FirebaseFunctions.instance.httpsCallable('approveNewUser');
                                  await callable.call(<String, dynamic>{
                                    'unique_customer_number': customer['unique_customer_number'],
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("User approved successfully!")),
                                  );
                                } catch (error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Approval failed: $error")),
                                  );
                                }
                              },
                            ).show();
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}