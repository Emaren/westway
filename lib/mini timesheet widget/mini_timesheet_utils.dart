import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../auth_service.dart';
import '../timesheet_data.dart';
import 'package:collection/collection.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

DateTime calculateStartDate() {
  DateTime now = DateTime.now();
  DateTime firstPayPeriodStart = DateTime(now.year, now.month, 9);
  DateTime secondPayPeriodStart = DateTime(now.year, now.month, 24);

  if (now.isBefore(firstPayPeriodStart)) {
    return DateTime(now.year, now.month - 1, 24);
  } else if (now.isBefore(secondPayPeriodStart)) {
    return firstPayPeriodStart;
  } else {
    return secondPayPeriodStart;
  }
}

List<DateTime> generatePayPeriodDates(DateTime startDate) {
  List<DateTime> dates = [];

  DateTime endDate;
  if (startDate.day == 9) {
    endDate = DateTime(startDate.year, startDate.month, 23);
  } else {
    endDate = startDate.month == 12
        ? DateTime(startDate.year + 1, 1, 8)
        : DateTime(startDate.year, startDate.month + 1, 8);
  }

  DateTime date = startDate;
  while (date.isBefore(endDate) || date.isAtSameMomentAs(endDate)) {
    dates.add(date);
    date = date.add(const Duration(days: 1));
  }

  return dates;
}

void initializeTimesheet(
    String uid, Function(bool, String) onComplete, Function function) async {
  QuerySnapshot querySnapshot = await _firestore
      .collection('timesheets')
      .where('uid', isEqualTo: uid)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    DocumentSnapshot timesheetDoc = querySnapshot.docs.first;
    bool isSaved = true;
    String docId = timesheetDoc.id;
    onComplete(isSaved, docId);
  }
}

Future<String?> initializeSupervisorName(
    AuthService authService, Function(String?) onNameInitialized) async {
  String? name = await authService.getUserDisplayName('');

  onNameInitialized(name);
  return name;
}

List<TableRow> createTableRows(
  List<TimesheetData> timesheetData,
  List<DateTime> payPeriodDates,
) {
  List<TableRow> tableRows = [];
  List<String> headers = [
    'Pay Period',
    'Date (2023)',
    'Start Time',
    'End Time',
    'Total Hrs',
  ];

  DateTime today = DateTime.now();

  DateTime startDate = calculateStartDate();
  List<DateTime> payPeriodDates = generatePayPeriodDates(startDate);

  tableRows.add(TableRow(
    children: headers
        .map((header) => ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 80,
                maxWidth: 100,
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: AutoSizeText(
                  header,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ),
            ))
        .toList(),
  ));

  double totalHours = 0;

  for (int i = 0; i < payPeriodDates.length; i++) {
    DateTime date = payPeriodDates[i];
    TimesheetData? data = timesheetData.firstWhereOrNull(
        (data) => DateTime.parse(data.dateYMD).isAtSameMomentAs(date));

    double hoursWorked = 0;
    if (data != null) {
      double startHours = data.startHour + data.startMinute / 60.0;
      double endHours = data.endHour + data.endMinute / 60.0;

      if (startHours > endHours) {
        // the worker has worked past midnight
        endHours += 24; // add 24 hours to the end time
      }

      hoursWorked = endHours - startHours - (data.lunchTaken ? 0.5 : 0);
      totalHours += hoursWorked;
    }

    bool isToday = date.day == today.day &&
        date.month == today.month &&
        date.year == today.year;

    tableRows.add(TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: AutoSizeText(
              date.day.toString(),
              style: TextStyle(
                color: isToday ? const Color.fromARGB(255, 15, 0, 179) : null,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: AutoSizeText(
              data != null
                  ? data.dateYMD.substring(8).replaceAll(RegExp('^0+'), '')
                  : '-',
              minFontSize: 2,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: Text(
            data != null
                ? '${data.startHour}:${data.startMinute.toString().padLeft(2, '0')}'
                : '-',
          )),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: Text(
            data != null
                ? '${data.endHour}:${data.endMinute.toString().padLeft(2, '0')}'
                : '-',
          )),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text(hoursWorked.toStringAsFixed(2))),
        ),
      ],
    ));
  }

  tableRows.add(TableRow(
    children: [
      const SizedBox(height: 24),
      const SizedBox(height: 24),
      const SizedBox(height: 24),
      const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            'Total:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            totalHours.toStringAsFixed(2),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ],
  ));

  return tableRows;
}
