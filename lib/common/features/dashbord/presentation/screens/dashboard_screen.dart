import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColorByTheme(context: context, colorClass: AppColors.backgroundColor),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
              shadowColor: Colors.transparent,
        backgroundColor: getColorByTheme(context: context, colorClass: AppColors.backgroundColor),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hello,", style: TextStyle(fontSize: 12)),
                SizedBox(height: 4),
                Text("Tom Cruise", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ],
            ),
            CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              child:  Icon(Icons.search, color: Colors.black),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding:  EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade200, blurRadius: 10, offset:  Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  [
                      Row(
                        children: [
                          Text("Total Balance", style: TextStyle(fontSize: 14)),
                          Icon(Icons.keyboard_arrow_down, size: 18)
                        ],
                      ),
                      Icon(Icons.more_horiz),
                    ],
                  ),
                   SizedBox(height: 10),
                   Text("Rs. 3,257.00", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                   SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  [
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.arrow_upward, size: 16),
                              SizedBox(width: 4),
                              Text("Income", style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text("Rs. 2350.00", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.arrow_downward, size: 16),
                              SizedBox(width: 4),
                              Text("Expenses", style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text("Rs. 950.00", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
             SizedBox(height: 25),
      
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Transactions", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("View all", style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
             SizedBox(height: 10),
      
            Expanded(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Container(
                    margin:  EdgeInsets.only(bottom: 10),
                    padding:  EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade600,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                         SizedBox(width: 10),
                         Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Clothing", style: TextStyle(fontWeight: FontWeight.w600)),
                              SizedBox(height: 2),
                              Text("winter clothing", style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ),
                         Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("- Rs. 20", style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 2),
                            Text("11 Dec", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
