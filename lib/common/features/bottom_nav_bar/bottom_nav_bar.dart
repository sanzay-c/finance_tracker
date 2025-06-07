import 'package:finance_tracker/add_expense_screen.dart';
import 'package:finance_tracker/common/features/add_transactions/add_transaction.dart';
import 'package:finance_tracker/common/features/chart/chart_screen.dart';
import 'package:finance_tracker/common/features/dashbord/presentation/dashboard_screen.dart';
import 'package:finance_tracker/common/features/profile/presentation/screens/profile_screen.dart';
import 'package:finance_tracker/common/features/wallet/wallet_screen.dart';
import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> _buildScreens() {
      return [
        DashboardScreen(),
        ChartScreen(),
        AddTransaction(),
        WalletScreen(),
        ProfileScreen(),
      ];
    }

    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: Tooltip(
            message: "Home",
            child: const Icon(Icons.home_filled),
          ),
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: Tooltip(
            message: "Chart",  
            child: const Icon(Icons.bar_chart_rounded),
          ),
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: Tooltip(
            message: "Add",  
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: Tooltip(
            message: "Wallet",  
            child: const Icon(Icons.wallet_rounded),
          ),
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: Tooltip(
            message: "Profile",  
            child: const Icon(Icons.person),
          ),
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.grey,
        ),
      ];
    }

    PersistentTabController controller = PersistentTabController(initialIndex: 0);

    return PersistentTabView(
      navBarHeight: 72,
      context,
      screens: _buildScreens(),
      items: _navBarsItems(),
      controller: controller,
      confineToSafeArea: true,
      backgroundColor: getColorByTheme(context: context, colorClass: AppColors.backgroundColor),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardAppears: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: getColorByTheme(context: context, colorClass: AppColors.backgroundColor),
      ),
      navBarStyle: NavBarStyle.style16,
    );
  }
}