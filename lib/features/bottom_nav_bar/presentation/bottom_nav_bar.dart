import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:finance_tracker/features/dashbord/presentation/screens/dashboard_screen.dart';
import 'package:finance_tracker/features/profile/presentation/screens/profile_screen.dart';
import 'package:finance_tracker/features/transactions/presentation/screens/add_transaction_screen.dart';
import 'package:finance_tracker/features/wallet/presentation/screens/wallet_screen.dart';
import 'package:finance_tracker/features/chart/presentation/screens/chart_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0; 

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(), 
    ChartScreen(), 
    WalletScreen(), 
    ProfileScreen(), 
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the Add Transaction Screen
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) =>  AddTransactionScreen()),
          );
        },
        backgroundColor:  Color(
          0xFF48319D,
        ),
        shape:  CircleBorder(), 
        child:  Icon(Icons.add, color: Colors.white, size: 30),
      ),

      // Position the FloatingActionButton in the center, docked to the BottomAppBar
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // This is our custom bottom navigation bar
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(162, 200, 197, 197),
        // getColorByTheme(context: context, colorClass: AppColors.backgroundColor), 
        shape:CircularNotchedRectangle(), 
        notchMargin: 8.0, 
        child: SizedBox(
          // height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // LEFT ICONS (Home and Chart)
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.home_filled,
                      color:
                          _selectedIndex == 0 ? const Color.fromARGB(255, 0, 0, 0) : const Color.fromARGB(255, 71, 70, 70),
                    ),
                    onPressed: () => _onItemTapped(0),
                  ),
                   SizedBox(width: 30),
                  IconButton(
                    icon: Icon(
                      Icons.bar_chart_rounded,
                      color:
                          _selectedIndex == 1 ? const Color.fromARGB(255, 0, 0, 0) : const Color.fromARGB(255, 71, 70, 70),
                    ),
                    onPressed: () => _onItemTapped(1),
                  ),
                ],
              ),

              // This SizedBox creates the empty space in the middle
               SizedBox(width: 40),

              // RIGHT ICONS (Wallet and Profile)
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.wallet_rounded,
                      color:
                          _selectedIndex == 2 ? const Color.fromARGB(255, 0, 0, 0) : const Color.fromARGB(255, 71, 70, 70),
                    ),
                    onPressed: () => _onItemTapped(2),
                  ),
                   SizedBox(width: 30),
                  IconButton(
                    icon: Icon(
                      Icons.person_outline,
                      color:
                          _selectedIndex == 3 ? const Color.fromARGB(255, 0, 0, 0) : const Color.fromARGB(255, 71, 70, 70),
                    ),
                    onPressed: () => _onItemTapped(3),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
