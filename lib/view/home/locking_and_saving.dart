// lock_and_saving.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LockAndSaving extends StatelessWidget {
  final Map<String, dynamic> selectedDateData;
  final Function() onSave;
  final Function() onLock;

  const LockAndSaving({
    required this.selectedDateData,
    required this.onSave,
    required this.onLock,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isLocked = selectedDateData['isLocked'] ?? false;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
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
                  padding: EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
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
                  child: Text(
                    'Lock',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          if (isLocked)
            Container(
              width: MediaQuery.sizeOf(context).width * 0.8,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
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
  }
}
