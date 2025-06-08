import 'package:finance_tracker/common/features/wallet/presentation/screens/add_wallet_screen.dart';
import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final List<Map<String, dynamic>> wallets = [
    {'name': 'Wallet 1', 'amount': 1000.00},
    {'name': 'Wallet 2', 'amount': 500.00},
  ];

  @override
  Widget build(BuildContext context) {
    final totalBalance = wallets.fold<double>(
      0,
      (sum, wallet) => sum + (wallet['amount'] as double),
    );

    return Scaffold(
      backgroundColor: getColorByTheme(
        context: context,
        colorClass: AppColors.backgroundColor,
      ),
      appBar: AppBar(
        backgroundColor: getColorByTheme(
          context: context,
          colorClass: AppColors.backgroundColor,
        ),
        title: Text('My Wallets'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'Rs.${totalBalance.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text('Total Balance', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 30),

            // Wallet card
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),

                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'My Wallets',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AddWalletScreen()));
                          },
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Wallet list
                    Expanded(
                      child: ListView.separated(
                        itemCount: wallets.length,
                        separatorBuilder: (_, __) => SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final wallet = wallets[index];
                          return Row(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      wallet['name'] as String,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Rs.${(wallet['amount'] as double).toStringAsFixed(2)}',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios, size: 18),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
