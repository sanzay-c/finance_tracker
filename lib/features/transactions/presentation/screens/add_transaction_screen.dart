import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/features/transactions/data/datasources/transaction_remote_datasource.dart';
import 'package:finance_tracker/features/transactions/data/repo_impl/transaction_repo_impl.dart';
import 'package:finance_tracker/features/transactions/domain/usecases/add_transaction_usecase.dart';
import 'package:finance_tracker/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:finance_tracker/features/transactions/presentation/widget/add_transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTransactionScreen extends StatelessWidget {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;
    final remoteDataSource = TransactionRemoteDataSourceImpl(firestore);
    final repository = TransactionRepositoryImpl(remoteDataSource);
    final useCase = AddTransactionUseCase(repository);
    return BlocProvider(
      create: (_) => TransactionBloc(useCase),
      child: const AddTransactionForm(),
    );
  }
}
