import 'package:finance_tracker/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({super.key});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  final List<Map<String, String>> receipts = [
    {
      'title': 'Shopping',
      'date': '19/08/2023',
      'description': 'Description (Optional)',
    },
    {
      'title': 'Bills and Utility',
      'date': '01/08/2023',
      'description': 'Roti Kapda Aur Makan',
    },
    {
      'title': 'Education',
      'date': '19/08/2023',
      'description': 'Description (Optional)',
    },
    {
      'title': 'Bills and Utility',
      'date': '05/08/2023',
      'description': 'Roti Kapda Aur Makan',
    },
    {
      'title': 'Bills and Utility',
      'date': '01/08/2023',
      'description': 'Roti Kapda Aur Makan',
    },
    {
      'title': 'Education',
      'date': '19/08/2023',
      'description': 'Description (Optional)',
    },
    {
      'title': 'Bills and Utility',
      'date': '05/08/2023',
      'description': 'Roti Kapda Aur Makan',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.arrow_back),
                  Text(
                    'Receipt',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Icon(Icons.settings),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Color(0xFFF0F0F0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // List of receipts
            Expanded(
              child: ListView.builder(
                itemCount: receipts.length,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                itemBuilder: (context, index) {
                  final receipt = receipts[index];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.purple.shade100),
                          ),
                          child: Icon(
                            Icons.radio_button_checked,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                receipt['title']!,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                receipt['date']!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                receipt['description']!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBottomButton(
                    'Edit',
                    AppColors.btnTextColor.lightModeColor,
                  ),
                  _buildBottomButton(
                    'Delete',
                    AppColors.btnTextColor.lightModeColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton(String label, Color color) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 6),
        height: 45,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonColor.darkModeColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(label),
        ),
      ),
    );
  }
}
