import 'package:flutter/material.dart';
import 'package:futurgen_attendance/models/contract_transaction_repository.dart';

class JournalScreen extends StatefulWidget {
  final int index;
  final String category;
  final String initialJournalText;
  final Function(String) onJournalUpdate;
  final bool isPastContract;
  final bool isLocked;

  const JournalScreen({
    required this.index,
    required this.category,
    required this.initialJournalText,
    required this.onJournalUpdate,
    required this.isPastContract,
    required this.isLocked,
    Key? key,
  }) : super(key: key);

  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  late TextEditingController _journalController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _journalController = TextEditingController(text: widget.initialJournalText);
    _focusNode = FocusNode();
  }

  Future<void> _saveJournalText() async {
    final updatedText = _journalController.text;
    widget.onJournalUpdate(updatedText);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _journalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Journal - ${widget.category}"),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding:  EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              TextField(
                controller: _journalController,
                focusNode: _focusNode,
                enabled: !widget.isPastContract && !widget.isLocked,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Enter your journal entry here...",
                  border: InputBorder.none,
                ),
                maxLines: null, // Allow multiple lines for long input
                onChanged: (text) {
                  // Trigger update when text changes
                  _saveJournalText();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
