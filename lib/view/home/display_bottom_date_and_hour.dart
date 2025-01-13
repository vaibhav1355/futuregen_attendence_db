import 'package:flutter/material.dart';

class DisplayBottomDateAndHour extends StatelessWidget {
  final int totalHours;
  final int leftMinutes;
  final int totalDays;
  final int leftHours;
  final double leftDays;

  const DisplayBottomDateAndHour({
    Key? key,
    required this.totalHours,
    required this.totalDays,
    required this.leftHours,
    required this.leftDays,
    required this.leftMinutes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showDetailsBottomSheet(context),
      child: Row(
        children: [
          _buildSummaryBox(
            color: Color(0xff39ba53),
            label: 'D-$leftDays',
            context: context,
          ),
          _buildSummaryBox(
            color: Color(0xffde3232),
            label: leftMinutes < 10
                ? 'H-$leftHours.0$leftMinutes'
                : 'H-$leftHours.$leftMinutes',
            context: context,
          ),
        ],
      ),
    );
  }

  void _showDetailsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildRow('Total Days:', '$totalDays'),
              const SizedBox(height: 14),
              _buildRow('Left Days:', '$leftDays'),
              const SizedBox(height: 16),
              _buildRow('Total Hours:', '$totalHours'),
              const SizedBox(height: 14),
              _buildRow(
                'Left Hours:',
                leftMinutes < 10
                    ? '$leftHours.0$leftMinutes'
                    : '$leftHours.$leftMinutes',
              ),
              const SizedBox(height: 14),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryBox({required Color color, required String label , required BuildContext context}) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.5,
      height: 60,
      decoration: BoxDecoration(color: color),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

}
