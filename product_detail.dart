import 'package:flutter/material.dart';
import 'checkout_page.dart';

class ProductDetailPage extends StatelessWidget {
  final String name;
  final String price;
  final String image;
  final String type;
  final String tag;

  const ProductDetailPage({
    super.key,
    required this.name,
    required this.price,
    required this.image,
    required this.type,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Icon(Icons.favorite_border, color: Colors.black),
          SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Image.asset(image, height: 220, fit: BoxFit.contain),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          price,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        Row(
                          children: const [
                            Icon(Icons.star, color: Colors.amber, size: 18),
                            SizedBox(width: 4),
                            Text("4.5", style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Product Description",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getRandomDescription(name),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Style Tags
                    Row(
                      children: [
                        Chip(
                          label: Text(type),
                          backgroundColor: Colors.deepPurple.shade50,
                          labelStyle: const TextStyle(color: Colors.deepPurple),
                        ),
                        const SizedBox(width: 8),
                        Chip(
                          label: Text(tag),
                          backgroundColor: Colors.grey.shade200,
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // ✅ Updated Buy Now Button
                    Center(
                      child: SizedBox(
                        width: 180,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CheckoutPage(orderName: name),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.shopping_cart_checkout, color: Colors.white),
                          label: const Text(
                            "Buy Now",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getRandomDescription(String productName) {
    if (productName.contains("TISSOT")) {
      return "Experience the pinnacle of Swiss craftsmanship with the Tissot T-Race series — a tribute to precision, speed, and luxury.";
    } else if (productName.contains("Jordan")) {
      return "Elevate your street style with Jordan Retro — engineered for performance, embraced by culture.";
    } else if (productName.contains("Diamond")) {
      return "Crafted for brilliance, this alluring diamond pendant makes every moment shine with elegance.";
    } else if (productName.contains("Passport")) {
      return "Travel in style with our premium black leather passport holder — minimalist design meets functionality.";
    }
    return "A stunning product that blends design, durability, and detail in perfect harmony.";
  }
}
