import 'package:finance_tracker/common/features/wallet/presentation/bloc/bloc/add_wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finance_tracker/common/features/wallet/domain/entities/wallet_entity.dart';
import 'package:finance_tracker/common/features/wallet/presentation/screens/add_wallet_screen.dart';
import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  List<WalletEntity> wallets = [];

  @override
  void initState() {
    super.initState();
    context.read<AddWalletBloc>().add(FetchWalletsEvent());
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
      ),
      body: SafeArea(
        child: BlocConsumer<AddWalletBloc, AddWalletState>(
          listener: (context, state) {
            if (state is AddWalletError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
            }
          },
          builder: (context, state) {
            if (state is GetWalletsLoaded) {
              wallets = state.wallets;
            } else if (state is AddWalletLoading) {
              return Center(child: CircularProgressIndicator());
            }

            // final totalBalance = wallets.fold<double>(
            //   0,
            //   (sum, wallet) => sum + (wallet.amount ?? 0),
            // );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                20.verticalSpace,
                Text(
                  // 'Rs.${totalBalance.toStringAsFixed(2)}',
                  "Rs.1500",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                4.verticalSpace,
                Text('Total Balance', style: TextStyle(color: Colors.grey)),
                30.verticalSpace,
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddWalletScreen(),
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                radius: 18.r,
                                backgroundColor: Colors.grey,
                                child: Icon(Icons.add, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        20.verticalSpace,
                        Expanded(
                          child: ListView.separated(
                            itemCount: wallets.length,
                            separatorBuilder: (_, __) => SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final wallet = wallets[index];
                              return Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child:
                                        wallet.imageUrl != null &&
                                                wallet.imageUrl!.isNotEmpty
                                            ? Image.network(
                                              wallet.imageUrl!,
                                              height: 50.h,
                                              width: 50.w,
                                              fit: BoxFit.cover,
                                              loadingBuilder: (
                                                context,
                                                child,
                                                loadingProgress,
                                              ) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return Container(
                                                  height: 50.h,
                                                  width: 50.w,
                                                  color: Colors.grey.shade200,
                                                  child: Center(
                                                    child: CircularProgressIndicator(
                                                      value:
                                                          loadingProgress
                                                                      .expectedTotalBytes !=
                                                                  null
                                                              ? loadingProgress
                                                                      .cumulativeBytesLoaded /
                                                                  loadingProgress
                                                                      .expectedTotalBytes!
                                                              : null,
                                                    ),
                                                  ),
                                                );
                                              },
                                              errorBuilder: (
                                                context,
                                                error,
                                                stackTrace,
                                              ) {
                                                return Container(
                                                  height: 50.h,
                                                  width: 50.w,
                                                  color: Colors.grey.shade300,
                                                  child: Icon(
                                                    Icons.broken_image,
                                                    color: Colors.grey,
                                                  ),
                                                );
                                              },
                                            )
                                            : Container(
                                              height: 50.h,
                                              width: 50.w,
                                              color: Colors.grey.shade300,
                                            ),
                                  ),
                                  12.verticalSpace,
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
                                          ),
                                        ),
                                        4.verticalSpace,
                                        Text(
                                          // 'Rs.${(wallet.amount ?? 0).toStringAsFixed(2)}',
                                          'Rs. 1000',
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
            );
          },
        ),
      ),
    );
  }
}
