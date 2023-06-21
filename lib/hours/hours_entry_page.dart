import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../mini timesheet widget/mini_timesheet_utils.dart';
import '../pay_periods_page.dart';
import 'firestore_service.dart';
import 'pay_date_card.dart';

class PayDate {
  DateTime date;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  bool lunchTaken;
  bool submitted;
  final String uid;

  PayDate({
    required this.uid,
    required this.date,
    this.startTime,
    this.endTime,
    this.lunchTaken = false,
    this.submitted = false,
  });

  static fromMap(Map<String, dynamic> data) {}
}

class HoursEntryPage extends StatefulWidget {
  const HoursEntryPage({super.key});

  @override
  _HoursEntryPageState createState() => _HoursEntryPageState();
}

class _HoursEntryPageState extends State<HoursEntryPage> {
  List<ValueNotifier<bool>> _submitNotifiers = [];

  DateTime currentPayPeriodStart = calculateStartDate();
  List<DateTime> payPeriodDates = [];
  List<PayDate> payDates = [];

  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  String? displayName;

  @override
  void initState() {
    super.initState();
    payPeriodDates = generatePayPeriodDates(currentPayPeriodStart);

    payDates =
        payPeriodDates.map((date) => PayDate(uid: userId, date: date)).toList();

    _submitNotifiers = List<ValueNotifier<bool>>.generate(
        payDates.length, (index) => ValueNotifier<bool>(false));

    loadTimes(userId, payDates, () {
      for (int i = 0; i < payDates.length; i++) {
        _submitNotifiers[i].value = payDates[i].submitted;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text("Hours Entry")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: payDates.length,
              itemBuilder: (context, index) {
                return PayDateCard(
                  payDate: payDates[index],
                  userId: userId,
                  saveTime: saveTime,
                  index: index,
                );
              },
            ),
          ),
          const SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PayPeriodsPage(),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Text(
                'Pay Periods',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
