import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LockAndSaving extends StatefulWidget {
  final Function() onSave;
  final Function() onLock;
  final bool isLocked ;

  const LockAndSaving({
    required this.onSave,
    required this.onLock,
    required this.isLocked,
    Key? key,
  }) : super(key: key);

  @override
  _LockAndSavingState createState() => _LockAndSavingState();
}

class _LockAndSavingState extends State<LockAndSaving> {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!widget.isLocked)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  onPressed: widget.onSave,
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
                  onPressed: widget.onLock,
                  color: Colors.black,
                  minWidth: 160,
                  height: 45,
                  padding: EdgeInsets.all(12),
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
          if (widget.isLocked)
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
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
