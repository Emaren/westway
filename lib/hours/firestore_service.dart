import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'hours_entry_page.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> saveTime(PayDate payDate, int index, String userId) async {
  String docId = '${userId}_$index';

  try {
    await _firestore.collection('hour_entries').doc(docId).set({
      'userId': userId,
      'index': index,
      'date': payDate.date.toIso8601String(),
      'unixTimestamp': payDate.date.millisecondsSinceEpoch,
      'dateYMD':
          '${payDate.date.year}-${payDate.date.month.toString().padLeft(2, '0')}-${payDate.date.day.toString().padLeft(2, '0')}',
      'startHour': payDate.startTime?.hour,
      'startMinute': payDate.startTime?.minute,
      'endHour': payDate.endTime?.hour,
      'endMinute': payDate.endTime?.minute,
      'lunchTaken': payDate.lunchTaken,
      'submitted': payDate.submitted,
    });
  } catch (e) {}
}

Future<void> loadTimes(String userId, List<PayDate> payDates,
    VoidCallback onPayDatesUpdated) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
      .collection('hour_entries')
      .where('userId', isEqualTo: userId)
      .get();

  for (QueryDocumentSnapshot<Map<String, dynamic>> doc in querySnapshot.docs) {
    Map<String, dynamic> data = doc.data();
    int index = data['index'] ?? 0;

    if (index >= 0 && index < payDates.length) {
      String? dateString = data['date'];
      int? unixTimestamp = data['unixTimestamp'];
      String? dateYMD = data['dateYMD'];
      int? startHour = int.tryParse(data['startHour']?.toString() ?? '0') ?? 0;
      int? startMinute =
          int.tryParse(data['startMinute']?.toString() ?? '0') ?? 0;
      int? endHour = int.tryParse(data['endHour']?.toString() ?? '0') ?? 0;
      int? endMinute = int.tryParse(data['endMinute']?.toString() ?? '0') ?? 0;

      bool lunchTaken = data['lunchTaken'] ?? false;
      bool submitted = data['submitted'] ?? false;

      if (dateString != null) {
        payDates[index].date = DateTime.parse(dateString);
      } else if (unixTimestamp != null) {
        payDates[index].date =
            DateTime.fromMillisecondsSinceEpoch(unixTimestamp);
      } else if (dateYMD != null) {
        payDates[index].date = DateTime.parse(dateYMD);
      }
      payDates[index].startTime =
          TimeOfDay(hour: startHour, minute: startMinute);
      payDates[index].endTime = TimeOfDay(hour: endHour, minute: endMinute);
      payDates[index].lunchTaken = lunchTaken;
      payDates[index].submitted = submitted;

      onPayDatesUpdated();
    }
  }
}
