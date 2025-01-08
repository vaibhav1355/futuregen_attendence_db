import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/contract_transaction_repository.dart';
import 'lock_status_fetcher.dart';

class LockAndSaving extends StatelessWidget {
  final DateTime selectedDate;
  final Function() onSave;
  final Function() onLock;

  const LockAndSaving({
    required this.selectedDate,
    required this.onSave,
    required this.onLock,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LockStatusFetcher(
      selectedDate: selectedDate,
      builder: (isLocked) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isLocked)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      onPressed: onSave,
                      color: Colors.black,
                      minWidth: 160,
                      height: 45,
                      padding: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    MaterialButton(
                      onPressed: onLock,
                      color: Colors.black,
                      minWidth: 160,
                      height: 45,
                      padding: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: const Text(
                        'Lock',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              if (isLocked)
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Center(
                    child: Text(
                      'Locked',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}



