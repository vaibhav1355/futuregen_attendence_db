import 'package:flutter/material.dart';

class DisplayBottomDateAndHour extends StatelessWidget {
  final int totalHours;
  final int leftMinutes;
  final int totalDays;
  final int leftHours;
  final double leftDays;

  DisplayBottomDateAndHour({
    required this.totalHours,
    required this.totalDays,
    required this.leftHours,
    required this.leftDays,
    required this.leftMinutes,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showDetailsBottomSheet(context),
      child: Row(
        children: [
          _buildInfoTile(
            context,
            color: Color(0xff39ba53),
            text: 'D-$leftDays',
          ),
          _buildInfoTile(
            context,
            color: Color(0xffde3232),
            text: _formatHoursAndMinutes(),
          ),
        ],
      ),
    );
  }

  String _formatHoursAndMinutes() {
    return leftMinutes < 10 ? 'H- $leftHours.0$leftMinutes' : 'H- $leftHours.$leftMinutes';
  }

  Widget _buildInfoTile(BuildContext context, {required Color color, required String text}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: 60,
      decoration: BoxDecoration(color: color),
      padding: EdgeInsets.all(12),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  void _showDetailsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Column(
              children: [
                _buildDismissableHeader(context),
                _buildDetailsContent(),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildDismissableHeader(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Row(
        children: [
          _buildInfoTile(
            context,
            color: Color(0xff39ba53),
            text: 'D-$leftDays',
          ),
          _buildInfoTile(
            context,
            color: Color(0xffde3232),
            text: _formatHoursAndMinutes(),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsContent() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDetailRow('Total Days:', '$totalDays'),
          SizedBox(height: 14),
          _buildDetailRow('Left Days:', '$leftDays'),
          SizedBox(height: 16),
          _buildDetailRow('Total Hours:', '$totalHours'),
          SizedBox(height: 14),
          _buildDetailRow('Left Hours:', _formatHoursAndMinutes()),
          SizedBox(height: 14),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
