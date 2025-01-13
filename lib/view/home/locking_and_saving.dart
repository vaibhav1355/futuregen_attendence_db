import 'package:flutter/material.dart';

class LockAndSaving extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onLock;
  final bool isLocked;

  const LockAndSaving({
    Key? key,
    required this.onSave,
    required this.onLock,
    required this.isLocked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isLocked
              ? _buildLockedView(context)
              : _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          label: 'Save',
          onPressed: onSave,
        ),
        _buildActionButton(
          label: 'Lock',
          onPressed: onLock,
        ),
      ],
    );
  }

  Widget _buildActionButton({required String label, required VoidCallback onPressed}) {
    return MaterialButton(
      onPressed: onPressed,
      color: Colors.black,
      minWidth: 160,
      height: 45,
      padding: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }

  Widget _buildLockedView(BuildContext context) {
    return Container(
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
    );
  }
}
