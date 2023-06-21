import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';
import 'mini timesheet widget/mini_timesheet_widget.dart';
import 'timesheet_data.dart';

class FirestoreMiniTimesheetWidget extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  FirestoreMiniTimesheetWidget({super.key});

  Map<String, List<DocumentSnapshot>> groupByUserId(QuerySnapshot snapshot) {
    Map<String, List<DocumentSnapshot>> map = {};

    for (var doc in snapshot.docs) {
      final userId = doc.get('userId');
      if (!map.containsKey(userId)) {
        map[userId] = [];
      }
      map[userId]!.add(doc);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('hour_entries').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          final groupedDocs = groupByUserId(snapshot.data!);

          if (groupedDocs.isEmpty) {
            return const Text("No data available");
          }

          return CarouselSlider.builder(
            itemCount: groupedDocs.entries.length,
            itemBuilder: (BuildContext context, int index, int realIndex) {
              final entry = groupedDocs.entries.elementAt(index);
              final userId = entry.key;
              final userDocs = entry.value;
              return FutureBuilder<String?>(
                  future: _authService.getUserDisplayName(userId),
                  builder:
                      (BuildContext context, AsyncSnapshot<String?> snapshot) {
                    if (snapshot.hasData) {
                      String displayName = snapshot.data ?? '';
                      final timesheetData = userDocs
                          .map((doc) => TimesheetData.fromMap(
                              doc.data() as Map<String, dynamic>))
                          .toList();

                      return SizedBox(
                        height: 200.0,
                        child: MiniTimesheetWidget(
                          displayName: displayName,
                          timesheetData: timesheetData,
                          uid: userId,
                          authService: _authService,
                          displaySendIcon: true,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Text('Failed to load displayName');
                    }
                    return const CircularProgressIndicator();
                  });
            },
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height,
              enlargeCenterPage: true,
              viewportFraction: 0.8,
              aspectRatio: 2.0,
              initialPage: 0,
              autoPlay: false,
            ),
          );
        },
      ),
    );
  }
}
