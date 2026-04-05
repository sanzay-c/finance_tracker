import 'package:cached_network_image/cached_network_image.dart';
import 'package:finance_tracker/features/wallet/presentation/bloc/add_wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finance_tracker/features/wallet/presentation/screens/add_wallet_screen.dart';
import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    print('🔄 Fetching wallets...');
    context.read<AddWalletBloc>().add(FetchWalletsEvent());
  }

  Future<void> _navigateToAddWallet() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddWalletScreen()),
    );
    if (result == true) {
      _fetchWallets();
    }
  }

  @override
  Widget build(BuildContext context) {
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
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchWallets),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<AddWalletBloc, AddWalletState>(
          listener: (context, state) {
            if (state is AddWalletError) {
              print('❌ Error: ${state.errorMessage}');
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
            }
          },
          builder: (context, state) {
            print('🏗️ Building with state: ${state.runtimeType}');

            if (state is AddWalletLoading) {
              print('⏳ Loading...');
              return const Center(child: CircularProgressIndicator());
            }

            if (state is! GetWalletsLoaded) {
              print('📭 No wallets loaded yet');
              return const Center(child: Text('No wallets found'));
            }

            final wallets = state.wallets;
            print('💰 Loaded ${wallets.length} wallets:');
            for (var wallet in wallets) {
              print('  - ${wallet.name}: Rs.${wallet.amount}');
            }

            final totalBalance = wallets.fold<double>(
              0,
              (sum, wallet) => sum + wallet.amount,
            );
            print('💵 Total balance: Rs.$totalBalance');

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                20.verticalSpace,
                Text(
                  'Rs.${totalBalance.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 80.sp,
                    fontWeight: FontWeight.bold,
                    color: getColorByTheme(
                      context: context,
                      colorClass: AppColors.textColor,
                    ),
                  ),
                ),
                4.verticalSpace,
                Text(
                  'Total Balance',
                  style: TextStyle(color: Colors.grey, fontSize: 40.sp),
                ),
                30.verticalSpace,
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: getColorByTheme(
                            context: context,
                            colorClass: AppColors.textColor,
                          ),
                        ),
                        left: BorderSide.none,
                        right: BorderSide.none,
                        bottom: BorderSide.none,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),

                    padding: const EdgeInsets.all(16),
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
                                fontSize: 32.sp,
                                color: getColorByTheme(
                                  context: context,
                                  colorClass: AppColors.textColor,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: _navigateToAddWallet,
                              child: CircleAvatar(
                                radius: 24.r,
                                backgroundColor: Colors.grey,
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        20.verticalSpace,
                        Expanded(
                          child:
                              wallets.isEmpty
                                  ? const Center(
                                    child: Text(
                                      'No wallets added yet',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  )
                                  : ListView.separated(
                                    itemCount: wallets.length,
                                    separatorBuilder:
                                        (_, __) => const SizedBox(height: 16),
                                    itemBuilder: (context, index) {
                                      final wallet = wallets[index];
                                      return Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              10.r,
                                            ),
                                            // ignore: unnecessary_null_comparison
                                            child: wallet.imageUrl != null &&
                                                    // ignore: unnecessary_non_null_assertion
                                                    wallet.imageUrl!.isNotEmpty
                                                ? CachedNetworkImage(
                                                    // ignore: unnecessary_non_null_assertion
                                                    imageUrl: wallet.imageUrl!,
                                                    height: 110.h,
                                                    width: 130.w,
                                                    fit: BoxFit.cover,
                                                    placeholder: (context, url) => Container(
                                                      height: 110.h,
                                                      width: 130.w,
                                                      color: Colors.grey.shade200,
                                                      child: const Center(
                                                        child: CircularProgressIndicator(strokeWidth: 2),
                                                      ),
                                                    ),
                                                    errorWidget: (context, url, error) => Container(
                                                      height: 110.h,
                                                      width: 130.w,
                                                      color: Colors.grey.shade300,
                                                      child: const Icon(
                                                        Icons.broken_image,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    height: 110.h,
                                                    width: 130.w,
                                                    color: Colors.grey.shade300,
                                                    child: const Icon(
                                                      Icons.wallet_outlined,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                          ),
                                          12.horizontalSpace,
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  wallet.name,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: getColorByTheme(
                                                      context: context,
                                                      colorClass:
                                                          AppColors.textColor,
                                                    ),
                                                  ),
                                                ),
                                                4.verticalSpace,
                                                Text(
                                                  'Rs.${wallet.amount.toStringAsFixed(2)}',
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Icon(
                                            Icons.arrow_forward_ios,
                                            size: 18,
                                          ),
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
            );
          },
        ),
      ),
    );
  }
}
