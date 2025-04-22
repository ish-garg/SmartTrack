import 'package:flutter/material.dart';
import 'checkout_page.dart'; // ✅ Import this
// import 'product_detail.dart'; // ❌ Comment out if not using detail page

class LuxuryProductShowcasePage extends StatelessWidget {
  const LuxuryProductShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> products = [
      {
        'name': 'TISSOT T-RACE MOTOGP QUARTZ CHRONOGRAPH (2025)',
        'price': '₹62,000.00',
        'image': 'lib/tisso4.png',
        'type': 'Automatic',
        'tag': 'New'
      },
      {
        'name': 'Jordan Retro Off White/Military Blue',
        'price': '₹30,500.00',
        'image': 'lib/shoes.jpg',
        'type': '5 left',
        'tag': '26 models'
      },
      {
        'name': 'Alluring Diamond Pendant',
        'price': '₹1,38,532',
        'image': 'lib/jewel.png',
        'type': 'Luxury',
        'tag': 'Limited'
      },
      {
        'name': "Men's Passport Holder in Black",
        'price': '₹40,500',
        'image': 'lib/passport.png',
        'type': 'Branded',
        'tag': 'New'
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset('lib/brand-logo.png', height: 30),
            const SizedBox(width: 10),
            const Text(
              "LUXURY",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: const [
          Icon(Icons.favorite_border, color: Colors.black),
          SizedBox(width: 20),
          Icon(Icons.location_on_outlined, color: Colors.black),
          SizedBox(width: 20),
          Icon(Icons.person_outline, color: Colors.black),
          SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CheckoutPage(orderName: product['name']!), // ✅ Pass order name
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 1.3,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.asset(
                          product['image']!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['name']!,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product['price']!,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(product['type']!, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                              const SizedBox(width: 10),
                              Text('+ ${product['tag']}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
