import 'package:finance_tracker/common/features/add_transactions/presentation/blocs/bloc/transaction_bloc.dart';
import 'package:finance_tracker/common/features/add_transactions/presentation/blocs/bloc/transaction_event.dart';
import 'package:finance_tracker/common/features/add_transactions/presentation/screens/add_transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTransactionScreen extends StatelessWidget {
  const AddTransactionScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TransactionBloc()..add(LoadWalletsEvent()),
      child: AddTransactionForm(),
    );
  }
}
