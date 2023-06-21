import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<TimeOfDay?> showCustomTimePicker(
    BuildContext context, TimeOfDay initialTime) async {
  int selectedHour = initialTime.hour;
  int selectedMinute = initialTime.minute;

  final FixedExtentScrollController hourController =
      FixedExtentScrollController(initialItem: selectedHour);
  final FixedExtentScrollController minuteController =
      FixedExtentScrollController(initialItem: selectedMinute ~/ 15);

  return showCupertinoModalPopup<TimeOfDay>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 450,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 72, 95, 105),
              Color.fromARGB(185, 60, 73, 86)
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: hourController,
                      itemExtent: 70,
                      onSelectedItemChanged: (int index) {
                        selectedHour = index;
                      },
                      children: List<Widget>.generate(25, (int index) {
                        return Center(
                          child: Text(
                            index < 24 ? '$index' : '24 (Midnight)',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 30),
                          ),
                        );
                      }),
                    ),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: minuteController,
                      itemExtent: 70,
                      onSelectedItemChanged: (int index) {
                        selectedMinute = index * 15;
                      },
                      children: List<Widget>.generate(4, (int index) {
                        return Center(
                          child: Text(
                            '${index * 15}'.padLeft(2, '0'),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 30),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: CupertinoButton(
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                onPressed: () {
                  if (selectedHour == 24) {
                    selectedHour =
                        0; // Midnight is represented as 0 in TimeOfDay
                    selectedMinute = 0; // Ensure minute is also 0 for midnight
                  }
                  Navigator.of(context).pop(
                      TimeOfDay(hour: selectedHour, minute: selectedMinute));
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

double calculateHoursWorked(
    TimeOfDay startTime, TimeOfDay endTime, bool lunchTaken) {
  double startHours = startTime.hour + startTime.minute / 60.0;
  double endHours = endTime.hour + endTime.minute / 60.0;

  if (startHours > endHours) {
    // the worker has worked past midnight
    endHours += 24; // add 24 hours to the end time
  }

  double hoursWorked = endHours - startHours;

  if (lunchTaken) {
    hoursWorked -= 0.5;
  }

  return hoursWorked;
}

DateTime dateTimeWithTimeOfDay(DateTime date, TimeOfDay timeOfDay) {
  return DateTime(
    date.year,
    date.month,
    date.day,
    timeOfDay.hour,
    timeOfDay.minute,
  );
}

String formatTimeOfDay(TimeOfDay timeOfDay) {
  final now = DateTime.now();
  final dateTime = dateTimeWithTimeOfDay(now, timeOfDay);
  final format = DateFormat.jm();
  return format.format(dateTime);
}
