part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final double totalBalance;
  final double totalIncome;
  final double totalExpense;
  
  

  DashboardLoaded({
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpense,
  });
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}

