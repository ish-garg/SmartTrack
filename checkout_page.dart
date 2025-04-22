import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'thank_you_page.dart';

class CheckoutPage extends StatefulWidget {
  final String orderName;

  const CheckoutPage({super.key, required this.orderName});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  String? firstName, lastName, email, password, address, note;
  final String backendUrl = 'http://192.168.223.58:58105/register_user';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Enter your details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _buildTextField(label: "First Name", onSaved: (val) => firstName = val, validatorMsg: "Please enter first name"),
              const SizedBox(height: 15),
              _buildTextField(label: "Last Name", onSaved: (val) => lastName = val, validatorMsg: "Please enter last name"),
              const SizedBox(height: 15),
              _buildTextField(label: "Email", onSaved: (val) => email = val, validatorMsg: "Enter a valid email", inputType: TextInputType.emailAddress),
              const SizedBox(height: 15),
              _buildTextField(label: "Password", onSaved: (val) => password = val, validatorMsg: "Please enter password", isObscure: true),
              const SizedBox(height: 15),
              _buildTextField(label: "Where do you live?", onSaved: (val) => address = val, validatorMsg: "Please enter your address"),
              const SizedBox(height: 15),
              _buildTextField(label: "Notes (optional)", onSaved: (val) => note = val, maxLines: 3),
              const SizedBox(height: 30),
              Center(
                child: SizedBox(
                  width: 160,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Submit", style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required Function(String?) onSaved,
    String? validatorMsg,
    bool isObscure = false,
    int maxLines = 1,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextFormField(
      onSaved: onSaved,
      obscureText: isObscure,
      maxLines: maxLines,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: validatorMsg != null
          ? (value) => value == null || value.isEmpty ? validatorMsg : null
          : null,
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "first_name": firstName,
          "last_name": lastName,
          "email": email,
          "password": password,
          "order_name": widget.orderName,
          "address": address,
        }),
      );

      final result = jsonDecode(response.body);

      if (result['status'] == 'exists') {
        _showDialog("Already Registered", "You have already registered with this email.");
      } else if (result['status'] == 'success') {
        final orderId = result['order_id'].toString();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ThankYouPage(orderId: orderId)),
        );
      } else {
        _showDialog("Error", result['message'] ?? "Something went wrong.");
      }
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
      ),
    );
  }
}
