import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'auth_service.dart';
import 'mini timesheet widget/mini_timesheet_widget.dart';

class TimesheetWidget extends StatelessWidget {
  final String? displayName;
  final String uid;
  final AuthService authService;

  const TimesheetWidget({
    super.key,
    this.displayName,
    required this.uid,
    required this.authService,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('hour_entries')
          .where('userId', isEqualTo: uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong: ${snapshot.error.toString()}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SpinKitFadingGrid(
            color: Color.fromARGB(255, 27, 2, 191),
            size: 50.0,
          );
        }

        List<TimesheetData> timesheetData = snapshot.data!.docs.map((doc) {
          if (doc.data() is Map<String, dynamic>) {
            return TimesheetData.fromMap(doc.data() as Map<String, dynamic>);
          } else {
            return TimesheetData(
              dateYMD: 'nu',
              startHour: 0,
              endHour: 0,
              startMinute: 0,
              endMinute: 0,
              lunchTaken: false,
            );
          }
        }).toList();

        return MiniTimesheetWidget(
          displayName: displayName ?? 'Unknown User',
          timesheetData: timesheetData,
          uid: uid,
          authService: authService,
          displaySendIcon: true,
        );
      },
    );
  }
}

class TimesheetData {
  final String dateYMD;
  final int startHour;
  final int endHour;
  final int startMinute;
  final int endMinute;
  final bool lunchTaken;

  TimesheetData({
    required this.lunchTaken,
    required this.dateYMD,
    required this.startHour,
    required this.endHour,
    required this.startMinute,
    required this.endMinute,
  });

  factory TimesheetData.fromMap(Map<String, dynamic> map) {
    return TimesheetData(
      startHour: map['startHour'] ?? 0,
      startMinute: map['startMinute'] ?? 0,
      endHour: map['endHour'] ?? 0,
      endMinute: map['endMinute'] ?? 0,
      dateYMD: map['dateYMD'] ?? '',
      lunchTaken: map['lunchTaken'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dateYMD': dateYMD,
      'startHour': startHour,
      'endHour': endHour,
      'startMinute': startMinute,
      'endMinute': endMinute,
      'lunchTaken': lunchTaken,
    };
  }
}
