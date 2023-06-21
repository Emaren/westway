import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'auth_service.dart';
import 'mini timesheet widget/mini_timesheet_widget.dart';
import 'timesheet_data.dart';

class ReviewTimesheetPage extends StatelessWidget {
  final String? displayName;
  final AuthService authService;

  const ReviewTimesheetPage(
      {super.key,
      this.displayName,
      required this.authService,
      required timesheetData,
      required uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Review Timesheet Page'),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('timesheets')
                .where('supervisorName', isNotEqualTo: null)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text(
                    'Something went wrong: ${snapshot.error.toString()}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SpinKitSpinningLines(
                  color: Color.fromARGB(255, 27, 2, 191),
                  size: 50.0,
                );
              }

              if (snapshot.connectionState == ConnectionState.active) {}

              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;

                    List<TimesheetData> timesheetData = [];
                    if (data['timesheetData'] != null) {
                      timesheetData = (data['timesheetData'] as List)
                          .map((item) => TimesheetData.fromMap(item))
                          .toList();
                    }

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MiniTimesheetWidget(
                            displayName: data['displayName'] ?? 'Unknown User',
                            timesheetData: timesheetData,
                            uid: data['uid'] ?? '',
                            authService: authService,
                            displaySendIcon: false,
                            displayDeleteIcon: true,
                          ),
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                      ],
                    );
                  });
            }));
  }
}
