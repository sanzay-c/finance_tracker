import 'package:finance_tracker/features/wallet/presentation/bloc/add_wallet_bloc.dart';
import 'package:finance_tracker/features/wallet/presentation/widgets/wallet_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finance_tracker/features/wallet/presentation/screens/add_wallet_screen.dart';
import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const _primaryColor = Color(0xFF48319D);

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    super.initState();
    _fetchWallets();
  }

  void _fetchWallets() {
    context.read<AddWalletBloc>().add(FetchWalletsEvent());
  }

  Future<void> _navigateToAddWallet() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddWalletScreen()),
    );
    if (result == true) _fetchWallets();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = getColorByTheme(
      context: context,
      colorClass: AppColors.backgroundColor,
    );
    final textColor = getColorByTheme(
      context: context,
      colorClass: AppColors.textColor,
    );
    final isDark = bgColor.computeLuminance() < 0.5;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'My Wallets',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: textColor,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded,
                color: textColor.withValues(alpha: 0.4)),
            onPressed: _fetchWallets,
          ),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<AddWalletBloc, AddWalletState>(
          listener: (context, state) {
            if (state is AddWalletError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Text(state.errorMessage),
                    ],
                  ),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.red.shade700,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.all(16),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is AddWalletLoading) {
              return const Center(
                  child: CircularProgressIndicator(color: _primaryColor));
            }

            if (state is! GetWalletsLoaded) {
              return Center(
                child: Text('No wallets found',
                    style: TextStyle(color: textColor.withValues(alpha: 0.4))),
              );
            }

            final wallets = state.wallets;
            final totalBalance =
                wallets.fold<double>(0, (sum, w) => sum + w.amount);

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                  child: Column(
                    children: [
                      Text(
                        'Rs.${totalBalance.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 80.sp,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          letterSpacing: -0.5,
                        ),
                      ),
                      4.verticalSpace,
                      Text(
                        'Total Balance',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 40.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.03)
                          : Colors.black.withValues(alpha: 0.02),
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24)),
                      border: Border(
                        top: BorderSide(
                            color: textColor.withValues(alpha: 0.08), width: 1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 16, 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'My Wallets',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32.sp,
                                  color: textColor,
                                ),
                              ),
                              GestureDetector(
                                onTap: _navigateToAddWallet,
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: _primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.add,
                                      color: Colors.white, size: 20),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          child: wallets.isEmpty
                              ? Center(
                                  child: Text(
                                    'No wallets added yet',
                                    style: TextStyle(
                                        color: textColor.withValues(alpha: 0.4)),
                                  ),
                                ) 
                              : ListView.builder(
                                  padding: const EdgeInsets.fromLTRB(
                                      16, 0, 16, 100),
                                  itemCount: wallets.length,
                                  itemBuilder: (context, index) {
                                    return WalletTile(
                                      wallet: wallets[index],
                                      textColor: textColor,
                                      isDark: isDark,
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}