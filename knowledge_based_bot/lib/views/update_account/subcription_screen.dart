import 'package:flutter/material.dart';

class SubscriptionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng ký'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
            features: [
              'feature 1',
              'feature 2',
              'feature 3',
            ],
            proFeatures: [
              'feature 1',
              'feature 2',
              'feature 3',
            ],
            otherBenefits: [
              'benefit 1',
              'benefit 2',
              'benefit 3',
            ],
            price: 'Bắt đầu từ 999.000 đ',
          ),
          SubscriptionPlan(
            title: 'Pro Max',
            features: [
              'feature 1',
              'feature 2',
              'feature 3',
            ],
            proFeatures: [
              'feature 1',
              'feature 2',
              'feature 3',
            ],
            otherBenefits: [
              'benefit 1',
              'benefit 2',
              'benefit 3',
            ],
            price: 'Bắt đầu từ 1.999.000 đ',
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

  SubscriptionPlan({
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
              padding: EdgeInsets.all(8),
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
                  Spacer(),
                  Icon(Icons.star, color: Colors.purple[900]),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nhiều Truy vấn',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ...features.map((feature) => ListTile(
                        leading: Icon(Icons.check, color: Colors.green),
                        title: Text(feature),
                      )),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Truy cập tất cả các tính năng Pro',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ...proFeatures.map((feature) => ListTile(
                        leading: Icon(Icons.check, color: Colors.green),
                        title: Text(feature),
                      )),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Các Lợi ích Khác',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ...otherBenefits.map((benefit) => ListTile(
                        leading: Icon(Icons.check, color: Colors.green),
                        title: Text(benefit),
                      )),
                ],
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle subscribe button press
                },
                child: Text(price),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors
                      .purple, // Thay thế `primary` bằng `backgroundColor`
                  foregroundColor: Colors
                      .white, // Thay thế `onPrimary` bằng `foregroundColor`
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
