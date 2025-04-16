import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:collectify/Widgets/loading_overlay.dart';
import 'package:collectify/Widgets/themedata.dart';
import 'package:collectify/Widgets/utils.dart';
import 'package:collectify/init_packages.dart';
import 'package:collectify/pages/customer_details.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';



class Customers extends StatefulWidget {
  const Customers({super.key});

  @override
  State<Customers> createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  // Define controllers for the textfields
    final TextEditingController nameController = TextEditingController();
    final TextEditingController surnameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController idController = TextEditingController();
    // final TextEditingController initialLoanController = TextEditingController();
    // final TextEditingController interestRateController = TextEditingController();
    // final TextEditingController totalToPayController = TextEditingController();
    // final TextEditingController cardNumberController = TextEditingController();
    // final TextEditingController cvvController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    // final TextEditingController expiryDateController = TextEditingController();
    // final TextEditingController amountToPayController = TextEditingController();
    // final TextEditingController scheduledDateController = TextEditingController();
        

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<dynamic> _filterCustomers() {
    if (searchQuery.isEmpty) return appController.allCustomers;
    return appController.allCustomers.where((customer) {
      final customerMap = customer as Map<String, dynamic>;
      final name = (customerMap['name'] ?? '').toString().toLowerCase();
      return name.contains(searchQuery.toLowerCase());
    }).toList();
  }

  // void _updateTotalToPay() {
  // final loanText = initialLoanController.text.trim();
  // final rateText = interestRateController.text.trim();

  // if (loanText.isEmpty || rateText.isEmpty) {
  //   totalToPayController.text = '';
  //   return;
  // }

  // final loan = double.tryParse(loanText);
  // final rate = double.tryParse(rateText);

  // if (loan == null || rate == null) {
  //   totalToPayController.text = '';
  //   return;
  // }

//   final total = loan + (loan * rate / 100);
//   totalToPayController.text = total.toStringAsFixed(2);
// }

// Future<void> _pickScheduledDate(BuildContext context) async {
  // final DateTime? picked = await showDatePicker(
  //   context: context,
  //   initialDate: DateTime.now().add(const Duration(days: 1)),
  //   firstDate: DateTime.now(),
  //   lastDate: DateTime.now().add(const Duration(days: 365)),
  // );

  // if (picked != null) {
  //   scheduledDateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
  // }
// }

  @override
  Widget build(BuildContext context) {
    

    return LoadingOverlay(
      child: Scaffold(
        appBar: appBar(
          context,
          titleText: "Customers",
          automaticallyImplyLeading: true,
        ),
        body: Column(
          children: [
            // Header Container with Search Bar, Add button, and Total Count
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Search Bar on the left
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search Customers...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Center "Add New Customer" Container (as clickable)
                  InkWell(
                    onTap: () {
                      showAwesomeDialog(
                        context: context, 
                        body: Column(
                          children: [
                            TextField(
                              controller: nameController,
                              decoration: const InputDecoration(labelText: 'Name(s)'),
                            ),
                            TextField(
                              controller: surnameController,
                              decoration: const InputDecoration(labelText: 'Surname'),
                            ),
                            TextField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(labelText: 'Phone Number'),
                            ),
                            TextField(
                              controller: idController,
                              decoration: const InputDecoration(labelText: 'ID'),
                            ),
                            // TextField(
                            //   controller: initialLoanController,
                            //   keyboardType: TextInputType.number,
                            //   decoration: const InputDecoration(labelText: 'Initial Loan Amount'),
                            // ),
                            // TextField(
                            //   controller: interestRateController,
                            //   keyboardType: TextInputType.number,
                            //   decoration: const InputDecoration(labelText: 'Interest Rate (%)'),
                            //   onChanged: (_) {
                            //     _updateTotalToPay();
                            //   },
                            // ),
                            // TextField(
                            //   controller: totalToPayController,
                            //   readOnly: true,
                            //   decoration: const InputDecoration(labelText: 'Total to Pay (R)'),
                            // ),
                            // const SizedBox(height: 16),

                            // Card Details
                            // TextField(
                            //   controller: cardNumberController,
                            //   keyboardType: TextInputType.number,
                            //   decoration: const InputDecoration(labelText: 'Card Number'),
                            // ),
                            // TextField(
                            //   controller: cvvController,
                            //   keyboardType: TextInputType.number,
                            //   decoration: const InputDecoration(labelText: 'CVV'),
                            // ),
                            TextField(
                              controller: emailController,
                              decoration: const InputDecoration(labelText: 'email'),
                            ),
                            // TextField(
                            //   controller: expiryDateController,
                            //   decoration: const InputDecoration(labelText: 'Expiry Date (MM/YY)'),
                            // ),
                            // TextField(
                            //   controller: amountToPayController,
                            //   keyboardType: TextInputType.number,
                            //   decoration: const InputDecoration(labelText: 'Amount to Pay (R)'),
                            // ),
                            // TextField(
                            //   controller: scheduledDateController,
                            //   readOnly: true,
                            //   onTap: () => _pickScheduledDate(context),
                            //   decoration: const InputDecoration(
                            //     labelText: 'Scheduled Date (for payment)',
                            //     suffixIcon: Icon(Icons.calendar_today),
                            //   ),
                            // ),

                            // const SizedBox(height: 16),
                            
                            
                          ],
                        ),

                        // cancel button red in color

                        btnCancelOnPress: () {},
                        btnCancelColor: Colors.red,
                        btnOkOnPress: () async {
                          try {
                            appController.setIsLoading = true;
                            final String name = nameController.text.trim();
                            final String surname = surnameController.text.trim();
                            final String phone = phoneController.text.trim();
                            final String idValue = idController.text.trim();
                            // final String initialLoan = initialLoanController.text.trim();
                            // final String interestRate = interestRateController.text.trim();
                            // final String totalToPay = totalToPayController.text.trim();
                            // final String cardNumber = cardNumberController.text.trim();
                            // final String cvv = cvvController.text.trim();
                            final String email = emailController.text.trim();
                            // final String expiryDate = expiryDateController.text.trim();
                            // final String amountToPay = amountToPayController.text.trim();
                            // final String scheduledDate = scheduledDateController.text.trim();


                            // Call the cloud function "createCustomer"
                            final callable =
                                FirebaseFunctions.instance.httpsCallable('createCustomer');
                            final results = await callable.call(<String, dynamic>{
                              'name': name,
                              'surname': surname,
                              'phone': phone,
                              'id': idValue,
                              // 'initialLoan': initialLoan,
                              // 'interestRate': interestRate,
                              // 'totalToPay': totalToPay,
                              // 'cardNumber': cardNumber,
                              // 'cvv': cvv,
                              'email': email,
                              // 'expiryDate': expiryDate,
                              // 'amountToPay': amountToPay,
                              // 'scheduledDate': scheduledDate,
                            });
                            debugPrint("CreateCustomer response: ${results.data}");
                            appController.setAllCustomers(value: results.data['customers'] as List<dynamic>);
                            // Clear all ther text fields after successful addition
                            nameController.clear();
                            surnameController.clear();
                            phoneController.clear();
                            idController.clear();
                            // initialLoanController.clear();
                            // interestRateController.clear();
                            // totalToPayController.clear();
                            // cardNumberController.clear();
                            // cvvController.clear();
                            emailController.clear();
                            // expiryDateController.clear();
                            // amountToPayController.clear();
                            // scheduledDateController.clear();
                            // Show success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Customer added successfully!")),
                            );

                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error: $error")),
                            );
                          } finally {
                            appController.setIsLoading = false;
                            
                          }
                          
                          },
                          btnOkColor: Colors.green, animType: AnimType.scale, dialogType: DialogType.success, title: 'Customer Added',
                      );
                        
                      
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Add New Customer",
                        style: contentTextStyle(
                          fontSize: h3,
                          fontWeight: FontWeight.bold,
                          fontColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Total Count on the right
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Total: ${appController.allCustomers.length}",
                      style: contentTextStyle(
                        fontSize: h3,
                        fontWeight: FontWeight.bold,
                        fontColor: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            // Customer List OR display a big Add Customer button if no customers exist.
            Obx(() => Expanded(
              child: appController.allCustomers.isEmpty
                  ? Center(
                      child: Container(
                        child: Text(
                          "Enter New Customer",
                          style: contentTextStyle(
                            fontSize: h3,
                            fontWeight: FontWeight.bold,
                            fontColor: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _filterCustomers().length,
                      itemBuilder: (context, index) {
                        final customer =
                            _filterCustomers()[index] as Map<String, dynamic>;
                        final name = customer['name'] ?? 'Unnamed Customer';
                        final email = customer['email'] ?? '';
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          elevation: 4,
                          child: ListTile(
                            title: Text(
                              name,
                              style: contentTextStyle(
                                fontSize: h3,
                                fontWeight: FontWeight.bold,
                                fontColor: Colors.blueGrey,
                              ),
                            ),
                            subtitle:
                                email.isNotEmpty ? Text(email) : null,
                            onTap: () async {
  try {
    // Show a loading indicator
    appController.setIsLoading = true;
    
    // Extract the customer's id (or ucn) from the customer map.
    final String customerId = customer['id'] ?? '';
    
    // Call the cloud function 'fetchCustomerInfo'
    final callable = FirebaseFunctions.instance.httpsCallable('fetchCustomerInfo');
    final results = await callable.call(<String, dynamic>{
      'id': customerId,
    });
    
    // Retrieve the returned customer data
    final Map<String, dynamic> customerData = results.data as Map<String, dynamic>;
    
    // Hide the loading indicator
    appController.setIsLoading = false;
    
    // Navigate to the CustomerDetailsPage, passing the data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerDetailsPage(customerData: customerData),
      ),
    );
  } catch (error) {
    // Hide loading indicator and show an error message on failure
    appController.setIsLoading = false;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $error")),
    );
  }
},

                          ),
                        );
                      },
                    ),
            )),
          ],
        ),
      ),
    );
  }


}

Widget _buildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            "$label:",
            style: contentTextStyle(
              fontSize: h4,
              fontWeight: FontWeight.bold,
              fontColor: Colors.blueGrey,
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            value,
            style: contentTextStyle(
              fontSize: h4,
              fontWeight: FontWeight.normal,
              fontColor: Colors.black87,
            ),
          ),
        ),
      ],
    ),
  );
}