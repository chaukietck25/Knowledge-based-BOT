import 'package:flutter/material.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
            Navigator.pop(context);
          },
        ),
      ),
      body: PageView(
        children: [
          SubscriptionPlan(
            title: 'Pro+',
            features: const [
              'feature 1',
              'feature 2',
              'feature 3',
            ],
            proFeatures: const [
              'feature 1',
              'feature 2',
              'feature 3',
            ],
            otherBenefits: const [
              'benefit 1',
              'benefit 2',
              'benefit 3',
            ],
            price: 'Price from 999.000 đ',
          ),
          SubscriptionPlan(
            title: 'Pro Max',
            features: const [
              'feature 1',
              'feature 2',
              'feature 3',
            ],
            proFeatures: const [
              'feature 1',
              'feature 2',
              'feature 3',
            ],
            otherBenefits: const [
              'benefit 1',
              'benefit 2',
              'benefit 3',
            ],
            price: 'Price from từ 1.999.000 đ',
          ),
        ],
      ),
    );
  }
}

class SubscriptionPlan extends StatelessWidget {
  final String title;
  final List<String> features;
  final List<String> proFeatures;
  final List<String> otherBenefits;
  final String price;

  const SubscriptionPlan({super.key, 
    required this.title,
    required this.features,
    required this.proFeatures,
    required this.otherBenefits,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.purple[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.purple[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.star, color: Colors.purple[900]),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nhiều Truy vấn',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ...features.map((feature) => ListTile(
                        leading: const Icon(Icons.check, color: Colors.green),
                        title: Text(feature),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Truy cập tất cả các tính năng Pro',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ...proFeatures.map((feature) => ListTile(
                        leading: const Icon(Icons.check, color: Colors.green),
                        title: Text(feature),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Các Lợi ích Khác',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ...otherBenefits.map((benefit) => ListTile(
                        leading: const Icon(Icons.check, color: Colors.green),
                        title: Text(benefit),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle subscribe button press
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors
                      .purple, // Thay thế `primary` bằng `backgroundColor`
                  foregroundColor: Colors
                      .white, // Thay thế `onPrimary` bằng `foregroundColor`
                ),
                child: Text(price),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
