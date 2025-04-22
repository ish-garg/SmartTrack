import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderDetailsPage extends StatefulWidget {
  final String userEmail;

  const OrderDetailsPage({super.key, required this.userEmail});

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final TextEditingController _smartTrackIdController = TextEditingController();
  Map<String, dynamic>? singleOrder;
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _fetchOrderDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      singleOrder = null;
    });

    String smartTrackId = _smartTrackIdController.text.trim();

    if (smartTrackId.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Please enter a SmartTrack ID';
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://192.168.223.58:58105/get_order_details'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'smarttrack_id': smartTrackId}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        setState(() {
          singleOrder = responseData['order_details'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = responseData['message'] ?? 'Order not found.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to connect to the server. Please try again later.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        title: const Text(
          "Order Tracking",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 91, 19, 159), Color(0xFF9535CD)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 10,
        shadowColor: const Color.fromARGB(255, 122, 92, 175).withOpacity(1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSearchSection(),
              const SizedBox(height: 30),
              _buildContentSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _smartTrackIdController,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            labelText: "Enter Tracking ID",
            labelStyle: const TextStyle(color: Colors.white70),
            hintText: "e.g., 123456789",
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
            prefixIcon: const Icon(Icons.search, color: Colors.white70),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear, color: Colors.white70),
              onPressed: () {
                _smartTrackIdController.clear();
                setState(() {
                  singleOrder = null;
                  _errorMessage = '';
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _fetchOrderDetails,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: const Color(0xFF7F39FB), // Deep Purple-ish
                  elevation: 6,
                  shadowColor: Colors.deepPurpleAccent.withOpacity(0.4),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                icon: const Icon(Icons.track_changes, color: Colors.white),
                label: const Text(
                  "Track Package",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContentSection() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _isLoading
          ? _buildLoadingIndicator()
          : _errorMessage.isNotEmpty
          ? _buildErrorCard()
          : singleOrder != null
          ? _buildOrderDetailsCard(singleOrder!)
          : _buildPlaceholder(),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
          ),
          const SizedBox(height: 20),
          Text(
            "Tracking your package...",
            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      children: [
        Image.asset('lib/package_search.png', height: 180),
        const SizedBox(height: 20),
        Text(
          "Enter your tracking ID to view package details",
          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14, fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildErrorCard() {
    return Center(
      child: Card(
        color: Colors.red.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.redAccent),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.redAccent),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderDetailsCard(Map<String, dynamic> order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          
          _buildDetailItem(Icons.calendar_today, "Order Date", order['order_date']),
          _buildDetailItem(Icons.local_shipping, "Estimated Delivery", order['expected_delivery']),
          _buildDetailItem(Icons.assignment_turned_in, "Status", order['delivery_status']),
          _buildDetailItem(Icons.inventory, "Items", order['orders']),
          _buildDetailItem(Icons.person, "Recipient", order['name']),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String title, dynamic value) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
      subtitle: Text("$value", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}
