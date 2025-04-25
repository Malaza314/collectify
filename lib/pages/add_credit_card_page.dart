import 'package:collectify/Widgets/loading_overlay.dart';
import 'package:collectify/Widgets/themedata.dart';
import 'package:collectify/Widgets/utils.dart';
import 'package:collectify/init_packages.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';

class AddCreditCardPage extends StatefulWidget {
  const AddCreditCardPage({Key? key}) : super(key: key);

  @override
  State<AddCreditCardPage> createState() => _AddCreditCardPageState();
}

class _AddCreditCardPageState extends State<AddCreditCardPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController cardHolderController = TextEditingController();
  final TextEditingController idnumberController = TextEditingController();

  // State variables for dropdowns.
  String? _selectedBank;
  String? _selectedCardType;
  // Use a checkbox for confirmation.
  bool _confirmed = false;

  // Lists for dropdown options.
  final List<String> banks = [
    'Nedbank',
    'Absa',
    'Standard Bank',
    'Capitec',
    'FNB'
  ];
  final List<String> cardTypes = [
    'MasterCard',
    'Visa',
    'American Express'
  ];

  void _submitCardDetails() async {
    if (_formKey.currentState!.validate() && _confirmed) {
      try {
          appController.setIsLoading = true;
          final callable = FirebaseFunctions.instance.httpsCallable('createCreditCard');
          final result = await callable.call(<String, dynamic>{
            'cardNumber': cardNumberController.text.trim(),
            'expiryDate': expiryDateController.text.trim(),
            'cvv': cvvController.text.trim(),
            'cardHolder': cardHolderController.text.trim(),
            'idNumber': idnumberController.text.trim(),
            'bank': _selectedBank,
            'cardType': _selectedCardType,
          });
          appController.setIsLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Card details added successfully!")),
          );
        } catch (error) {
          appController.setIsLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: $error")),
          );
        }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Card details submitted:\nBank: ${_selectedBank ?? ''}\nCard Type: ${_selectedCardType ?? ''}"),
        ),
      );
    } else if (!_confirmed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please confirm your card details before submitting.")),
      );
    }
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    cardHolderController.dispose();
    idnumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Responsive layout values.
    final width = MediaQuery.of(context).size.width;
    final formPadding = width > 600 ? 32.0 : 16.0;

    return LoadingOverlay(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Enter Card Details",
            style: contentTextStyle(
              fontSize: h3,
              fontWeight: FontWeight.bold,
              fontColor: Colors.blue,
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(formPadding),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: EdgeInsets.all(formPadding),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: cardNumberController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Card Number',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Please provide the card number' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: expiryDateController,
                      readOnly: true,
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                        );
                        if (pickedDate != null) {
                          expiryDateController.text = "${pickedDate.month}/${pickedDate.year}";
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Expiry Date (MM/YYYY)',
                        suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Please select expiry date' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: cvvController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'CVV',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Please provide CVV' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: idnumberController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'ID Number',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Please provide your ID number' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: cardHolderController,
                      decoration: const InputDecoration(
                        labelText: 'Cardholder Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Please provide cardholder name' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedBank,
                      hint: const Text('Select Bank'),
                      decoration: const InputDecoration(
                        labelText: 'Bank',
                        border: OutlineInputBorder(),
                      ),
                      items: banks.map((String bank) {
                        return DropdownMenuItem<String>(
                          value: bank,
                          child: Text(bank),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedBank = newValue;
                        });
                      },
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Please select a bank' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedCardType,
                      hint: const Text('Select Card Type'),
                      decoration: const InputDecoration(
                        labelText: 'Card Type',
                        border: OutlineInputBorder(),
                      ),
                      items: cardTypes.map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCardType = newValue;
                        });
                      },
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Please select a card type' : null,
                    ),
                    const SizedBox(height: 24),
                    // Single confirmation checkbox.
                    CheckboxListTile(
                      title: const Text("I confirm that my card details are correct."),
                      controlAffinity: ListTileControlAffinity.leading,
                      value: _confirmed,
                      onChanged: (bool? value) {
                        setState(() {
                          _confirmed = value ?? false;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submitCardDetails,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16), 
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Submit",
                        style: contentTextStyle(
                          fontSize: h3,
                          fontWeight: FontWeight.bold,
                          fontColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}