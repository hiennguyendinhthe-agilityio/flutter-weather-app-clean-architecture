class AccountModel {
  final String id;
  final String accountNumber;
  final double balance;
  final double income;
  final double expenses;
  final double savingsRate;

  const AccountModel({
    required this.id,
    required this.accountNumber,
    required this.balance,
    required this.income,
    required this.expenses,
    required this.savingsRate,
  });

  double get netFlow => income - expenses;
  bool get isPositive => netFlow >= 0;

  static AccountModel mock() => const AccountModel(
    id: 'acc_001',
    accountNumber: '**** **** **** 4582',
    balance: 24_850.75,
    income: 8_500.00,
    expenses: 3_240.50,
    savingsRate: 0.618,
  );
}
