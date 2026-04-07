import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:finance_tracker/core/utils/date_parser.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('transactions')
        .where('uid', isEqualTo: uid)
        .orderBy('date', descending: true)
        .get();

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final date = DateParser.parse(data['date']);
      final amount = (data['amount'] as num).toDouble();
      final type = data['type'];

      final dayLabel = "${date.day}/${date.month}";
      final monthLabel = "${date.month}/${date.year}";
      // final yearLabel = date.year.toString();

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

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  List<LineChartBarData> buildLineData(Map<String, double> incomeMap, Map<String, double> expenseMap, List<String> keys) {
    return [
      LineChartBarData(
        isCurved: true,
        color: Colors.green,
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: true, color: Colors.green.withValues(alpha: 0.1)),
        spots: List.generate(keys.length, (i) {
          final income = incomeMap[keys[i]] ?? 0;
          return FlSpot(i.toDouble(), income);
        }),
      ),
      LineChartBarData(
        isCurved: true,
        color: Colors.red,
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: true, color: Colors.red.withValues(alpha: 0.1)),
        spots: List.generate(keys.length, (i) {
          final expense = expenseMap[keys[i]] ?? 0;
          return FlSpot(i.toDouble(), expense);
        }),
      ),
    ];
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
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

    if (keys.isEmpty) {
      return const Center(child: Text("No data for this period"));
    }

    final lineData = buildLineData(incomeMap, expenseMap, keys);

    return Padding(
      padding: const EdgeInsets.only(top: 12, right: 24, left: 16, bottom: 60),
      child: LineChart(
        LineChartData(
          lineBarsData: lineData,
          maxY: _getMaxY(incomeMap, expenseMap),
          minY: 0,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withValues(alpha: 0.1), strokeWidth: 1),
            getDrawingVerticalLine: (value) => FlLine(color: Colors.grey.withValues(alpha: 0.1), strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              axisNameWidget: const Text(
                'Amount (Rs.)',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              axisNameSize: 22,
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 44,
                getTitlesWidget: (value, meta) {
                  if (value == 0) return const SizedBox.shrink();
                  String text = value.toInt().toString();
                  if (value >= 1000) {
                    text = '${(value / 1000).toStringAsFixed(1)}k';
                  }
                  return Text(
                    text,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              axisNameWidget: const Text(
                'Period',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              axisNameSize: 22,
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= keys.length) return const SizedBox.shrink();
                  String label = keys[index].split('/')[0];
                  
                  // For Yearly view, convert month number to abbreviation
                  if (_tabController.index == 2) {
                    final month = int.tryParse(label) ?? 0;
                    if (month > 0 && month <= 12) {
                      label = _monthAbbreviation(month);
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) => Colors.blueGrey.withValues(alpha: 0.8),
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((LineBarSpot touchedSpot) {
                  final textStyle = TextStyle(
                    color: touchedSpot.bar.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  );
                  return LineTooltipItem(
                    'Rs. ${touchedSpot.y.toStringAsFixed(2)}',
                    textStyle,
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
  String _monthAbbreviation(int month) {
    const months = [
      "", "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
    ];
    return months[month];
  }
}
