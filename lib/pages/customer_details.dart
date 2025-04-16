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
  // Text editing controllers for adding a new loan
  final TextEditingController initialLoanController = TextEditingController();
  final TextEditingController interestRateController = TextEditingController();
  final TextEditingController totalToPayController = TextEditingController();
  final TextEditingController amountToPayController = TextEditingController();
  final TextEditingController scheduledDateController = TextEditingController();

  // Used to force refresh of FutureBuilder when a new loan is added.
  DateTime lastLoanUpdate = DateTime.now();

  // Function to update totalToPay based on initialLoan and interestRate.
  void _updateTotalToPay() {
    final loanText = initialLoanController.text.trim();
    final rateText = interestRateController.text.trim();

    if (loanText.isEmpty || rateText.isEmpty) {
      totalToPayController.text = '';
      return;
    }
    final loan = double.tryParse(loanText);
    final rate = double.tryParse(rateText);
    if (loan == null || rate == null) {
      totalToPayController.text = '';
      return;
    }
    final total = loan + (loan * rate / 100);
    totalToPayController.text = total.toStringAsFixed(2);
  }

  // Function to pick a scheduled date using a date picker.
  Future<void> _pickScheduledDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      scheduledDateController.text = picked.toLocal().toString().split(' ')[0];
    }
  }

  // Calls a cloud function to fetch loan transactions for this customer.
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

  // Calls a cloud function to create a new loan transaction.
  Future<void> _createLoanTransaction() async {
    final String customerId = widget.customerData['id'] ?? '';
    final String ucn = widget.customerData['unique_customer_number'] ?? '';
    final String initialLoan = initialLoanController.text.trim();
    final String interestRate = interestRateController.text.trim();
    final String totalToPay = totalToPayController.text.trim();
    final String amountToPay = amountToPayController.text.trim();
    final String scheduledDate = scheduledDateController.text.trim();

    try {
      appController.setIsLoading = true;
      final callable = FirebaseFunctions.instance.httpsCallable('createLoan');
      await callable.call(<String, dynamic>{
        'customer_id': customerId,
        'unique_customer_number': ucn,
        'initial_loan': initialLoan,
        'interest_rate': interestRate,
        'total_to_pay': totalToPay,
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

  // Shows a dialog to add a new loan.
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
                  controller: initialLoanController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Initial Loan Amount',
                  ),
                ),
                TextField(
                  controller: interestRateController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Interest Rate (%)',
                  ),
                  onChanged: (_) {
                    _updateTotalToPay();
                  },
                ),
                TextField(
                  controller: totalToPayController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Total to Pay (R)',
                  ),
                ),
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
                // Clear controllers and close dialog on cancel.
                initialLoanController.clear();
                interestRateController.clear();
                totalToPayController.clear();
                amountToPayController.clear();
                scheduledDateController.clear();
                Navigator.pop(context);
              },
              child: const Text("Cancel", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () async {
                try {
                  appController.setIsLoading = true;

                  await _createLoanTransaction();
                  // Clear controllers.
                  initialLoanController.clear();
                  interestRateController.clear();
                  totalToPayController.clear();
                  amountToPayController.clear();
                  scheduledDateController.clear();
                  Navigator.pop(context);
                  // Refresh the transaction list.
                  setState(() {
                    lastLoanUpdate = DateTime.now();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Loan added successfully!")),
                  );
                  appController.setIsLoading = false;
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
    // Dispose controllers to prevent memory leaks.
    initialLoanController.dispose();
    interestRateController.dispose();
    totalToPayController.dispose();
    amountToPayController.dispose();
    scheduledDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String name = widget.customerData['name'] ?? 'Unnamed Customer';
    final String surname = widget.customerData['surname'] ?? '';
    final String phone = widget.customerData['phone'] ?? '';

    return Scaffold(
      appBar: appBar(
        context,
        automaticallyImplyLeading: true,
        titleText: "Customer Details",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // Use a Column with Expanded to display both customer details and the list of loan transactions.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow("Name", name),
            _buildInfoRow("Surname", surname),
            _buildInfoRow("Phone", phone),
            const SizedBox(height: 24),
            const Text(
              "Loan Transactions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // FutureBuilder to fetch transactions via cloud function.
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                // Adding the lastLoanUpdate variable in the future call to trigger a refresh.
                future: _fetchLoanTransactions(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final transactions = snapshot.data!;
                  if (transactions.isEmpty) {
                    return const Center(child: Text("No upcoming payments"));
                  }
                  return ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction =
                          transactions[index] as Map<String, dynamic>;
                      final amount =
                          transaction['total_to_pay'] ?? 'No amount provided';
                      final date =
                          transaction['scheduled_date'] ?? 'No date provided';
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 2,
                        child: ListTile(
                          title: Text("Amount: \R${amount}"),
                          subtitle: Text("Date: $date"),
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
      // Floating Action Button to add a new loan
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddLoanDialog,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
        tooltip: 'Add New Loan',
      ),
    );
  }

  // Helper method for displaying a label-value pair.
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
