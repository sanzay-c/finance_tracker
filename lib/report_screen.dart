import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/features/expense/data/repositories/expense_repository_impl.dart';
import 'package:finance_tracker/features/expense/domain/entities/transaction_entity.dart';
import 'package:finance_tracker/features/expense/domain/repositories/expense_repository.dart';
import 'package:finance_tracker/features/expense/domain/usecases/delete_expense_usecase.dart';
import 'package:finance_tracker/features/expense/domain/usecases/update_expense_usecase.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({super.key});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: 'Rs ');

  // Filter types should match Firestore 'type' field values (lowercase)
  String selectedType = 'all'; // 'all', 'income', or 'expense'

  ExpenseRepository? repository;
  DeleteExpenseUseCase? deleteUseCase;
  UpdateExpenseUseCase? updateUseCase;

  String filterLabel(Map<String, String> filterOptions) {
    return filterOptions[selectedType] ?? selectedType;
  }

  @override
  void initState() {
    super.initState();
    repository = ExpenseRepositoryImpl(FirebaseFirestore.instance);
    deleteUseCase = DeleteExpenseUseCase(repository!);
    updateUseCase = UpdateExpenseUseCase(repository!);
  }

  void _deleteTransaction(String id) async {
    if (deleteUseCase == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('DeleteUseCase not initialized')),
      );
      return;
    }
    try {
      await deleteUseCase!.execute(id);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Transaction deleted')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to delete: $e')));
    }
  }

  void _showUpdateDialog(TransactionEntity transaction) {
    String capitalize(String s) =>
        s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();

    final _totalController = TextEditingController(
      text: transaction.total.toString(),
    );
    final _descController = TextEditingController(
      text: transaction.description ?? '',
    );
    final _categoryController = TextEditingController(
      text: transaction.category ?? '',
    );

    String currentType = transaction.type;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                AppLocalizations.of(context)!.updateTransaction,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: currentType,
                      items:
                          ['income', 'expense'].map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(
                                type == 'income'
                                    ? AppLocalizations.of(context)!.income
                                    : AppLocalizations.of(context)!.expense,
                              ),
                            );
                          }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            currentType = val;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.type,
                      ),
                    ),
                    TextFormField(
                      controller: _categoryController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.category,
                      ),
                    ),
                    TextFormField(
                      controller: _descController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.description,
                      ),
                    ),
                    TextFormField(
                      controller: _totalController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.amount,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (updateUseCase == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(
                              context,
                            )!.updateUseCaseNotInitialized,
                          ),
                        ),
                      );
                      return;
                    }

                    final updatedTransaction = TransactionEntity(
                      id: transaction.id,
                      type: currentType.toLowerCase(),
                      date: transaction.date,
                      category: _categoryController.text,
                      description: _descController.text,
                      total:
                          double.tryParse(_totalController.text) ??
                          transaction.total,
                      userName: transaction.userName,
                      userEmail: transaction.userEmail,
                    );

                    try {
                      await updateUseCase!.execute(
                        transaction.id!,
                        updatedTransaction,
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.transactionUpdated,
                          ),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(
                              context,
                            )!.failedToUpdate(e.toString()),
                          ),
                        ),
                      );
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.update),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final filterOptions = {
      'all': AppLocalizations.of(context)!.all,
      'income': AppLocalizations.of(context)!.income,
      'expense': AppLocalizations.of(context)!.expense,
    };

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.transactionReceipts,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Filter Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    filterOptions.entries.map((entry) {
                      final key = entry.key;
                      final label = entry.value;
                      final isSelected = selectedType == key;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedType = key;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? theme.colorScheme.primary.withOpacity(0.2)
                                    : (isDark
                                        ? Colors.grey[800]
                                        : Colors.grey[200]),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color:
                                  isSelected
                                      ? theme.colorScheme.primary
                                      : (isDark
                                          ? Colors.grey[700]!
                                          : Colors.grey[300]!),
                            ),
                          ),
                          child: Text(
                            label,
                            style: TextStyle(
                              color:
                                  isSelected
                                      ? theme.colorScheme.primary
                                      : theme.textTheme.bodyLarge?.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),

            const SizedBox(height: 10),

            // Firestore Stream
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('transactions')
                        .snapshots(),

                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        AppLocalizations.of(context)!.somethingWentWrong,
                        style: theme.textTheme.bodyLarge,
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: theme.colorScheme.primary,
                      ),
                    );
                  }

                  final allDocs = snapshot.data!.docs;
                  final filteredDocs =
                      allDocs.where((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final type =
                            data['type']?.toString().toLowerCase().trim() ?? '';
                        return selectedType == 'all' || type == selectedType;
                      }).toList();

                  if (filteredDocs.isEmpty) {
                    return Center(
                      child: Text(
                        AppLocalizations.of(
                          context,
                        )!.noReceiptsFound(filterLabel(filterOptions)),
                        style: theme.textTheme.bodyLarge,
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredDocs.length,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    itemBuilder: (context, index) {
                      final doc = filteredDocs[index];
                      final data = doc.data() as Map<String, dynamic>;
                      final transaction = TransactionEntity.fromJson(
                        data,
                        doc.id,
                      );

                      final isIncome =
                          (data['type']?.toString().toLowerCase().trim() ??
                              '') ==
                          'income';

                      return Card(
                        color:
                            isIncome
                                ? Colors.green.shade50
                                : Colors.red.shade50,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(
                            transaction.category ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  isIncome
                                      ? Colors.green[900]
                                      : Colors.red[900],
                            ),
                          ),
                          subtitle: Text(
                            transaction.description ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                currencyFormat.format(transaction.total),
                                style: TextStyle(
                                  color: isIncome ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat.yMd().format(transaction.date),
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                          onLongPress: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return SafeArea(
                                  child: Wrap(
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.edit),

                                        onTap: () {
                                          Navigator.pop(context);
                                          _showUpdateDialog(transaction);
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.delete),

                                        onTap: () {
                                          Navigator.pop(context);
                                          _deleteTransaction(doc.id);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
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
