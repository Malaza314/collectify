import 'package:collectify/Widgets/loading_overlay.dart';
import 'package:collectify/Widgets/themedata.dart';
import 'package:collectify/Widgets/utils.dart';
import 'package:collectify/init_packages.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';

class CustomerDetailsPage extends StatefulWidget {
  final Map<String, dynamic> customerData;

  const CustomerDetailsPage({Key? key, required this.customerData})
    : super(key: key);

  @override
  State<CustomerDetailsPage> createState() => _CustomerDetailsPageState();
}

class _CustomerDetailsPageState extends State<CustomerDetailsPage> {
  final TextEditingController amountToPayController = TextEditingController();
  final TextEditingController scheduledDateController = TextEditingController();

  DateTime lastLoanUpdate = DateTime.now();

  String _loanSearchQuery = '';

  Future<void> _pickScheduledDate(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        final DateTime scheduledDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        scheduledDateController.text = scheduledDateTime.toLocal().toString();
      }
    }
  }

  Future<List<dynamic>> _fetchLoanTransactions() async {
    final String ucn = widget.customerData['unique_customer_number'] ?? '';
    print("Fetching transactions for UCN: $ucn");
    print("*********");
    try {
      final callable = FirebaseFunctions.instance.httpsCallable(
        'fetchLoanTransactions',
      );
      final results = await callable.call(<String, dynamic>{'ucn': ucn});
      print("before");
      print(results.data);
      print("after");
      if (results.data != null &&
          results.data['transactions'] is List<dynamic>) {
        return results.data['transactions'] as List<dynamic>;
      }
      return [];
    } catch (error) {
      print("Error fetching transactions: $error");
      return [];
    }
  }

  Future<void> _createLoanTransaction() async {
    final String customerId = widget.customerData['id'] ?? '';
    final String ucn = widget.customerData['unique_customer_number'] ?? '';
    final String amountToPay = amountToPayController.text.trim();
    final String scheduledDate = scheduledDateController.text.trim();

    try {
      appController.setIsLoading = true;
      final callable = FirebaseFunctions.instance.httpsCallable('createLoan');
      await callable.call(<String, dynamic>{
        'customer_id': customerId,
        'unique_customer_number': ucn,
        'amount_to_pay': amountToPay,
        'scheduled_date': scheduledDate,
      });
      appController.setIsLoading = false;
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error setting loading state: $error")),
      );
    }
  }

  Future<void> _sendCreditCardEmail(String customerEmail) async {
    try {
      appController.setIsLoading = true;
      final callable = FirebaseFunctions.instance.httpsCallable('sendCreditCardEmail');
      final results = await callable.call(<String, dynamic>{
        'email': customerEmail,
      });
      appController.setIsLoading = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email sent successfully!")),
      );
    } catch (error) {
      appController.setIsLoading = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error sending email: $error")),
      );
    }
  }

  void _showAddLoanDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Loan"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: amountToPayController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Amount to Pay (R)',
                  ),
                ),
                TextField(
                  controller: scheduledDateController,
                  readOnly: true,
                  onTap: () => _pickScheduledDate(context),
                  decoration: const InputDecoration(
                    labelText: 'Scheduled Date (for payment)',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                amountToPayController.clear();
                scheduledDateController.clear();
                Navigator.pop(context);
              },
              child: const Text("Cancel", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () async {
                appController.setIsLoading = true;
                try {
                  await _createLoanTransaction();
                  amountToPayController.clear();
                  scheduledDateController.clear();
                  appController.setIsLoading = false;
                  Navigator.pop(context);
                  setState(() {
                    lastLoanUpdate = DateTime.now();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Loan added successfully!")),
                  );
                } catch (error) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Error: $error")));
                }
              },
              child: const Text(
                "Add Loan",
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    amountToPayController.dispose();
    scheduledDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String name = widget.customerData['name'] ?? 'Unnamed Customer';
    final String surname = widget.customerData['surname'] ?? '';
    final String phone = widget.customerData['phone'] ?? '';
    final String email = widget.customerData['email'] ?? '';

    return LoadingOverlay(
      child: Scaffold(
        appBar: appBar(
          context,
          automaticallyImplyLeading: true,
          titleText: "Customer Details",
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow("Name", name),
              _buildInfoRow("Surname", surname),
              _buildInfoRow("Phone", phone),
              Row(
                children: [
                  Expanded(child: _buildInfoRow("Email", email)),
                  IconButton(
                    icon: const Icon(Icons.email, color: Colors.blue),
                    tooltip: "Add Credit Card  Using Email",
                    onPressed: () async {
                      await _sendCreditCardEmail(email);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                "Loan Transactions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Search transactions...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _loanSearchQuery = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: _fetchLoanTransactions(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final transactions = snapshot.data!;
                    final filteredTransactions = _loanSearchQuery.isEmpty
                        ? transactions
                        : transactions.where((transaction) {
                            final status = (transaction['status'] ?? '').toString().toLowerCase();
                            final amount = (transaction['amount_to_pay'] ?? '').toString().toLowerCase();
                            final date = (transaction['scheduled_date'] ?? '').toString().toLowerCase();
                            final query = _loanSearchQuery.toLowerCase();
                            return status.contains(query) || amount.contains(query) || date.contains(query);
                          }).toList();
      
                    if (filteredTransactions.isEmpty) {
                      return const Center(child: Text("No matching transactions found"));
                    }
      
                    return ListView.builder(
                      itemCount: filteredTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = filteredTransactions[index] as Map<String, dynamic>;
                        final amount = transaction['amount_to_pay'] ?? 'No amount provided';
                        final date = transaction['scheduled_date'] ?? 'No date provided';
                        final status = (transaction['status'] ?? 'Pending').toString().toLowerCase();
      
                        Widget? trailingIcon;
                        if (status == 'paid') {
                          trailingIcon = const Icon(Icons.check_circle, color: Colors.green);
                        } else if (status == 'failed') {
                          trailingIcon = const Icon(Icons.cancel, color: Colors.red);
                        } else {
                          trailingIcon = null;
                        }
      
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 2,
                          child: ListTile(
                            title: Text("Amount: R${amount.toString()}"),
                            subtitle: Text("Date: $date\nStatus: ${transaction['status'] ?? 'Pending'}"),
                            trailing: trailingIcon,
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
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddLoanDialog,
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
          tooltip: 'Add New Loan',
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$label:",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(value, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
