import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'editing_pay_date.dart';
import 'hours_entry_page.dart';
import 'utils.dart';

class PayDateCard extends StatefulWidget {
  final PayDate payDate;
  final String userId;
  final Function(PayDate payDate, int index, String userId) saveTime;
  final int index;

  const PayDateCard({
    Key? key,
    required this.payDate,
    required this.userId,
    required this.saveTime,
    required this.index,
  }) : super(key: key);

  @override
  _PayDateCardState createState() => _PayDateCardState();
}

List<PayDate> payDates = [];

class _PayDateCardState extends State<PayDateCard> {
  bool _isEditing = false;
  late TextEditingController _editingController;
  Color _inventoryIconColor = const Color.fromARGB(255, 90, 90, 90);
  String _savedText = "";
  bool _isLoaded = false; // <- keep track if data is loaded

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController();
    checkWorklistEntryExistence();

    final editingPayDate = Provider.of<EditingPayDate>(context, listen: false);
    _editingController.addListener(() {
      if (_editingController.text != _savedText) {
        if (editingPayDate.payDate == widget.payDate) {
          editingPayDate.payDate = null;
        }
      }
    });
  }

  String? _documentId; // <- keep track of the document ID

  Future<void> checkWorklistEntryExistence() async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('worklist_entries')
        .where('date', isEqualTo: Timestamp.fromDate(widget.payDate.date))
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      var document = querySnapshot.docs.first;
      _documentId = document.id; // <- keep track of the document ID
      _savedText = document['entry'];
      _editingController.text = _savedText;
      if (mounted) {
        setState(() {
          _inventoryIconColor = const Color.fromARGB(255, 21, 119, 24);
          _isLoaded = true;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoaded = true;
        });
      }
    }
  }

  Future<void> _saveWorklistEntry() async {
    if (_editingController.text.trim().isNotEmpty) {
      if (_documentId == null) {
        // No existing document for this date, create a new one
        DocumentReference docRef = await FirebaseFirestore.instance
            .collection('worklist_entries')
            .add({
          'entry': _editingController.text.trim(),
          'date': Timestamp.fromDate(widget.payDate.date),
        });
        _documentId = docRef.id; // <- update the document ID
      } else {
        // Existing document for this date, update it
        await FirebaseFirestore.instance
            .collection('worklist_entries')
            .doc(_documentId)
            .update({
          'entry': _editingController.text.trim(),
          'date': Timestamp.fromDate(widget.payDate.date),
        });
      }
      if (mounted) {
        setState(() {
          _inventoryIconColor = const Color.fromARGB(255, 21, 119, 24);
          _savedText = _editingController.text.trim();
        });
      }
    } else {
      // Delete the document if it exists
      if (_documentId != null) {
        await FirebaseFirestore.instance
            .collection('worklist_entries')
            .doc(_documentId)
            .delete();
      }
      if (mounted) {
        setState(() {
          _documentId = null;
          _savedText = "";
        });
      }
    }
    if (mounted) {
      setState(() {
        _isEditing = false;
        _isLoaded = false;
        checkWorklistEntryExistence();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final editingPayDate = Provider.of<EditingPayDate>(context);
    String userId = widget.userId;
    PayDate payDate = widget.payDate;

    TimeOfDay startTime =
        payDate.startTime ?? const TimeOfDay(hour: 0, minute: 0);
    TimeOfDay endTime = payDate.endTime ?? const TimeOfDay(hour: 0, minute: 0);
    bool lunchTaken = payDate.lunchTaken;
    double totalHours = calculateHoursWorked(startTime, endTime, lunchTaken);

    return Card(
      child: GestureDetector(
        onTap: () async {
          if (editingPayDate.payDate != null &&
              editingPayDate.payDate != widget.payDate) {
            return;
          }
          TimeOfDay currentStartTime = TimeOfDay(
              hour: payDate.startTime?.hour ?? 0,
              minute: payDate.startTime?.minute ?? 0);
          TimeOfDay currentEndTime = TimeOfDay(
              hour: payDate.endTime?.hour ?? 0,
              minute: payDate.endTime?.minute ?? 0);

          TimeOfDay? newStartTime =
              await showCustomTimePicker(context, currentStartTime);
          TimeOfDay? newEndTime = await showCustomTimePicker(
              context, newStartTime ?? currentEndTime);

          if (newStartTime != null && newEndTime != null) {
            setState(() {
              if (mounted) {
                payDate.startTime = newStartTime;
                payDate.endTime = newEndTime;
              }
            });

            await widget.saveTime(payDate, widget.index, userId);
          }
        },
        child: _isEditing
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _editingController,
                  onEditingComplete: _saveWorklistEntry,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: _isLoaded
                        ? 'Enter your text here'
                        : 'Loading...', // <- show loading message
                    border: const OutlineInputBorder(),
                  ),
                ),
              )
            : Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat.yMMMMd().format(payDate.date),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: DateTime.now().year ==
                                              payDate.date.year &&
                                          DateTime.now().month ==
                                              payDate.date.month &&
                                          DateTime.now().day == payDate.date.day
                                      ? const Color.fromARGB(255, 8, 8, 171)
                                      : Colors.black,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Builder(
                                    builder: (BuildContext context) {
                                      return const IconButton(
                                        onPressed: null,
                                        icon: Icon(
                                          Icons.camera_alt_outlined,
                                          size: 30.0,
                                          color:
                                              Color.fromARGB(255, 82, 82, 82),
                                        ),
                                        padding: EdgeInsets.all(0),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 1.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Start: ${formatTimeOfDay(startTime)}',
                                  ),
                                  Text(
                                    'End: ${formatTimeOfDay(endTime)}',
                                  ),
                                  const SizedBox(height: 8.0),
                                  const Text(
                                    'Lunch Taken:',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    lunchTaken ? 'Yes' : 'No',
                                  ),
                                  Switch(
                                    value: lunchTaken,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (mounted) {
                                          payDate.lunchTaken = value ?? false;
                                        }
                                      });
                                      widget.saveTime(
                                          payDate, widget.index, userId);
                                    },
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (mounted) {
                                            _savedText = _editingController
                                                .text; // Update the saved text
                                            _isEditing = true;
                                          }
                                        });
                                      },
                                      icon: Icon(
                                        Icons.inventory_rounded,
                                        size: 30.0,
                                        color: _inventoryIconColor,
                                      ),
                                      padding: const EdgeInsets.all(0),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 3),
                                    child: Text(
                                      'Hours Worked:',
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 52),
                                    child: Text(
                                      totalHours.toStringAsFixed(2),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
