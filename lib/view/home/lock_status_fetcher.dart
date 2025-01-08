import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/contract_transaction_repository.dart';

class LockStatusFetcher extends StatelessWidget {
  final DateTime selectedDate;
  final Widget Function(bool isLocked) builder;

  const LockStatusFetcher({
    required this.selectedDate,
    required this.builder,
    Key? key,
  }) : super(key: key);

  Future<bool> _fetchLockStatus() async {
    final repository = ContractTransactionRepository();
    final transactionDate = DateFormat('dd-MM-yyyy').format(selectedDate);
    return await repository.fetchLockStatus(transactionDate);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _fetchLockStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          return builder(snapshot.data!);
        } else {
          return const Center(
            child: Text('No data available.'),
          );
        }
      },
    );
  }
}
