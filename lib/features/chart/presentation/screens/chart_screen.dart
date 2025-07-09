import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  Map<String, double> weeklyIncome = {};
  Map<String, double> weeklyExpense = {};
  Map<String, double> monthlyIncome = {};
  Map<String, double> monthlyExpense = {};
  Map<String, double> yearlyIncome = {};
  Map<String, double> yearlyExpense = {};

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchTransactionData();
  }

  Future<void> fetchTransactionData() async {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 6));
    final firstOfMonth = DateTime(now.year, now.month, 1);
    final firstOfYear = DateTime(now.year, 1, 1);

    final snapshot = await FirebaseFirestore.instance
        .collection('transactions')
        .orderBy('date', descending: true)
        .get();

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final date = DateTime.parse(data['date']);
      final amount = (data['amount'] as num).toDouble();
      final type = data['type'];

      final dayLabel = "${date.day}/${date.month}";
      final monthLabel = "${date.month}/${date.year}";
      final yearLabel = date.year.toString();

      // Weekly
      if (date.isAfter(sevenDaysAgo)) {
        if (type == 'income') {
          weeklyIncome[dayLabel] = (weeklyIncome[dayLabel] ?? 0) + amount;
        } else {
          weeklyExpense[dayLabel] = (weeklyExpense[dayLabel] ?? 0) + amount;
        }
      }

      // Monthly
      if (date.isAfter(firstOfMonth)) {
        if (type == 'income') {
          monthlyIncome[dayLabel] = (monthlyIncome[dayLabel] ?? 0) + amount;
        } else {
          monthlyExpense[dayLabel] = (monthlyExpense[dayLabel] ?? 0) + amount;
        }
      }

      // Yearly
      if (date.isAfter(firstOfYear)) {
        if (type == 'income') {
          yearlyIncome[monthLabel] = (yearlyIncome[monthLabel] ?? 0) + amount;
        } else {
          yearlyExpense[monthLabel] = (yearlyExpense[monthLabel] ?? 0) + amount;
        }
      }
    }

    setState(() {
      loading = false;
    });
  }

  List<BarChartGroupData> buildBarGroups(Map<String, double> incomeMap, Map<String, double> expenseMap) {
    final keys = incomeMap.keys.toSet().union(expenseMap.keys.toSet()).toList()
      ..sort((a, b) => _parseDateLabel(a).compareTo(_parseDateLabel(b)));

    return List.generate(keys.length, (i) {
      final key = keys[i];
      final income = incomeMap[key] ?? 0;
      final expense = expenseMap[key] ?? 0;

      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(toY: income, color: Colors.green, width: 7),
          BarChartRodData(toY: expense, color: Colors.red, width: 7),
        ],
      );
    });
  }

  double _getMaxY(Map<String, double> income, Map<String, double> expense) {
    final allValues = [...income.values, ...expense.values];
    if (allValues.isEmpty) return 100;
    final max = allValues.reduce((a, b) => a > b ? a : b);
    return (max / 100).ceil() * 100 + 100;
  }

  DateTime _parseDateLabel(String label) {
    final parts = label.split('/');
    if (parts.length == 2) {
      return DateTime(2024, int.parse(parts[1]), int.parse(parts[0]));
    } else {
      return DateTime(int.parse(label));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColorByTheme(context: context, colorClass: AppColors.backgroundColor),
      appBar: AppBar(
        backgroundColor: getColorByTheme(context: context, colorClass: AppColors.backgroundColor),
        title: const Text("Chart"),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Weekly"),
            Tab(text: "Monthly"),
            Tab(text: "Yearly"),
          ],
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
            
              controller: _tabController,
              children: [
                buildChart(weeklyIncome, weeklyExpense),
                buildChart(monthlyIncome, monthlyExpense),
                buildChart(yearlyIncome, yearlyExpense),
              ],
            ),
    );
  }

  Widget buildChart(Map<String, double> incomeMap, Map<String, double> expenseMap) {
    final keys = incomeMap.keys.toSet().union(expenseMap.keys.toSet()).toList()
      ..sort((a, b) => _parseDateLabel(a).compareTo(_parseDateLabel(b)));

    final barGroups = buildBarGroups(incomeMap, expenseMap);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceBetween,
          maxY: _getMaxY(incomeMap, expenseMap),
          barGroups: barGroups,
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 100,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= keys.length) return const SizedBox.shrink();
                  final label = keys[index].split('/')[0]; // show day or month
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(label),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
        ),
      ),
    );
  }
}
