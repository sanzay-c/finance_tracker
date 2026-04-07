import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/features/transactions/domain/entities/transaction_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfReportService {
  static Future<void> generateMonthlyReport(DateTime selectedMonth) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // 1. Fetch Transactions
    final startOfMonth = DateTime(selectedMonth.year, selectedMonth.month, 1);
    final endOfMonth = DateTime(selectedMonth.year, selectedMonth.month + 1, 0, 23, 59, 59);

    final snapshot = await FirebaseFirestore.instance
        .collection('transactions')
        .where('uid', isEqualTo: user.uid)
        .where('date', isGreaterThanOrEqualTo: startOfMonth.toIso8601String())
        .where('date', isLessThanOrEqualTo: endOfMonth.toIso8601String())
        .orderBy('date', descending: true)
        .get();

    final transactions = snapshot.docs
        .map((doc) => TransactionEntity.fromMap(doc.data()))
        .toList();

    // 2. Calculate Stats
    double totalIncome = 0;
    double totalExpense = 0;
    Map<String, double> categorySpending = {};

    for (var txn in transactions) {
      if (txn.type == 'income') {
        totalIncome += txn.amount;
      } else {
        totalExpense += txn.amount;
        if (txn.category != null) {
          categorySpending[txn.category!] = (categorySpending[txn.category!] ?? 0) + txn.amount;
        }
      }
    }

    // 3. Create PDF
    final pdf = pw.Document();
    final monthName = DateFormat('MMMM yyyy').format(selectedMonth);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Header
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Monthly Financial Report',
                        style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 4),
                    pw.Text(monthName, style: const pw.TextStyle(fontSize: 16, color: PdfColors.grey700)),
                  ],
                ),
                pw.Text('Finance Tracker',
                    style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.purple700)),
              ],
            ),
            pw.Divider(thickness: 2, color: PdfColors.purple700),
            pw.SizedBox(height: 20),

            // Summary Cards
            pw.Row(
              children: [
                _buildSummaryBox('Total Income', 'Rs. ${totalIncome.toStringAsFixed(2)}', PdfColors.green700),
                pw.SizedBox(width: 16),
                _buildSummaryBox('Total Expense', 'Rs. ${totalExpense.toStringAsFixed(2)}', PdfColors.red700),
                pw.SizedBox(width: 16),
                _buildSummaryBox('Net Balance', 'Rs. ${(totalIncome - totalExpense).toStringAsFixed(2)}', 
                    (totalIncome - totalExpense) >= 0 ? PdfColors.blue700 : PdfColors.red700),
              ],
            ),
            pw.SizedBox(height: 30),

            // Chart Section (Simulated Bar Chart using PDF drawing)
            if (categorySpending.isNotEmpty) ...[
              pw.Text('Spending by Category', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 12),
              pw.Container(
                height: 150,
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: categorySpending.entries.map((entry) {
                    final percentage = entry.value / totalExpense;
                    return pw.Expanded(
                      child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Container(
                            height: 100 * percentage,
                            decoration: const pw.BoxDecoration(color: PdfColors.purple300),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(entry.key, style: const pw.TextStyle(fontSize: 8)),
                          pw.Text('Rs. ${entry.value.toInt()}', style: const pw.TextStyle(fontSize: 7)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              pw.SizedBox(height: 30),
            ],

            // Transactions Table
            pw.Text('Transaction Details', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 12),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                  children: [
                    _buildTableCell('Date', isHeader: true),
                    _buildTableCell('Type', isHeader: true),
                    _buildTableCell('Category', isHeader: true),
                    _buildTableCell('Amount', isHeader: true),
                  ],
                ),
                ...transactions.map((txn) => pw.TableRow(
                  children: [
                    _buildTableCell(DateFormat('dd/MM/yyyy').format(txn.date)),
                    _buildTableCell(txn.type.toUpperCase(), 
                        color: txn.type == 'income' ? PdfColors.green700 : PdfColors.red700),
                    _buildTableCell(txn.category ?? 'N/A'),
                    _buildTableCell('Rs. ${txn.amount.toStringAsFixed(2)}'),
                  ],
                )),
              ],
            ),
          ];
        },
      ),
    );

    // 4. Preview / Save
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Report_$monthName.pdf',
    );
  }

  static pw.Widget _buildSummaryBox(String title, String value, PdfColor color) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey300),
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(title, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
            pw.SizedBox(height: 4),
            pw.Text(value, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  static pw.Widget _buildTableCell(String text, {bool isHeader = false, PdfColor? color}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: color ?? PdfColors.black,
        ),
      ),
    );
  }
}
