import 'package:flutter/material.dart';

import 'reversed_timeline_tile.dart';
import 'timeline_tile.dart';

class RoadmapPage extends StatelessWidget {
  final List<Widget> timelineTiles = [
    const TextTimelineTile(
      key: ValueKey('totalHours'),
      title: 'Develop an industry-leading,\nfull-featured app for Westway.',
    ),
    TextTimelineTilea(
      key: const ValueKey('totalHours'),
      titleWidget: RichText(
        text: const TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: 'Week 2 - 4 March 2023\nApp Research & Development\n',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: '68 hours',
              style: TextStyle(
                  color: Color.fromARGB(255, 131, 131, 131), fontSize: 12),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    ),
    const TimelineTile(
      icon: Icon(Icons.person_add, color: Colors.white),
      title: 'Week 1 April 2023 - User Authentication',
      subtitle: 'Develop user sign up, log in, and password recovery features',
      key: ValueKey("User Authentication"),
      details: '',
      hoursSpent: 74,
    ),
    const TimelineTile(
      icon: Icon(Icons.person, color: Colors.white),
      title: 'Week 2 April 2023 - User Roles',
      subtitle:
          'Develop user role creation and editing features of the user role feature',
      key: ValueKey("User Roles"),
      details: '',
      hoursSpent: 85,
    ),
    const TimelineTile(
      icon: Icon(Icons.chat, color: Colors.white),
      title: 'Week 3 April 2023 - Chat',
      subtitle:
          'Develop WestwayChat and image and video upload for the chat feature...',
      key: ValueKey("Chat"),
      details: '',
      hoursSpent: 83,
    ),
    const TimelineTile(
      icon: Icon(Icons.access_time, color: Colors.white),
      title: 'Week 4 April 2023 - Hours',
      subtitle:
          'Develop features to track hours for the development of the hours tracking feature...',
      key: ValueKey("Hours"),
      details: '',
      hoursSpent: 76,
    ),
    const TimelineTile(
      icon: Icon(Icons.access_time, color: Colors.white),
      title: 'Week 1 May 2023 - Hours',
      subtitle:
          'Develop features to track hours for the development of the hours tracking feature...',
      key: ValueKey("Hours2"),
      details: '',
      hoursSpent: 77,
    ),
    const TimelineTile(
      icon: Icon(Icons.access_time, color: Colors.white),
      title: 'Week 2 May 2023 - Hours',
      subtitle:
          'Develop features to track hours for the development of the hours tracking feature...',
      key: ValueKey("Hours3"),
      details: '',
      hoursSpent: 85,
    ),
    const TimelineTile(
      icon: Icon(Icons.access_time, color: Colors.white),
      title: 'Week 3 May 2023 - Hours',
      subtitle:
          'Continued development of the hours tracking feature while continuing development on the Tickets feature and Assets feature...',
      key: ValueKey("Hours4"),
      details: '',
      hoursSpent: 75,
    ),
    const TimelineTile(
      icon: Icon(Icons.shopping_cart, color: Colors.white),
      title: 'Week 4 May 2023 - Store & Cart',
      subtitle:
          'Develop store with shopping cart functionality and work with Apple to get listed app status on the App Store...',
      key: ValueKey("Store"),
      details: '',
      hoursSpent: 70,
    ),
    const TimelineTile(
      icon: Icon(Icons.shopping_cart, color: Colors.white),
      title: 'Week 1 June 2023 - Store & Cart',
      subtitle:
          'Develop store with shopping cart functionality and work with Apple to get listed app status on the App Store...',
      key: ValueKey("Store2"),
      details: '',
      hoursSpent: 71,
    ),
    const TimelineTile(
      icon: Icon(Icons.inventory, color: Colors.white),
      title: 'Week 2 June 2023 - Asset Entry',
      subtitle:
          'Develop asset entry functionality for the asset entry feature...',
      key: ValueKey("Asset Entry"),
      details: '',
      hoursSpent: 82,
    ),
    const TimelineTile(
      icon: Icon(Icons.chat, color: Colors.white),
      title: 'Week 3 June 2023 - Private Chat',
      subtitle:
          'Develop private chat functionality for the private chat feature...',
      key: ValueKey("Private Chat"),
      details: '',
      hoursSpent: 21,
    ),
    TextTimelineTileb(
      key: const ValueKey('totalHours'),
      titleWidget: RichText(
        text: const TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: 'Total Hours: 915',
              // text: 'Total Hours: 878',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 21),
            ),
            TextSpan(
              text: '',
              style: TextStyle(color: Color.fromARGB(255, 131, 131, 131)),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    ),
    const TimelineTile(
      icon: Icon(Icons.article, color: Colors.white),
      title: 'Week 4 June 2023 - Tickets',
      subtitle:
          'Develop ticketing system features for the development of the ticketing system...',
      key: ValueKey("Tickets"),
      details: '',
    ),
    const TimelineTile(
      icon: Icon(Icons.notifications, color: Colors.white),
      title: 'Week 1 July 2023 - Notifications & Alerts',
      subtitle:
          'Develop real-time notifications and alerts system features for the development of the notifications & alerts system...',
      key: ValueKey("Notifications"),
      details: '',
    ),
    const TimelineTile(
      icon: Icon(Icons.fact_check, color: Colors.white),
      title: 'Week 2 July 2023 - Worklist & Documentation',
      subtitle:
          'Develop worklist functionality and comprehensive app documentation features for the development of the worklist & documentation...',
      key: ValueKey("Worklist & Documentation"),
      details: '',
    ),
    const TimelineTile(
      icon: Icon(Icons.directions_car, color: Colors.white),
      title: 'Week 3 July 2023 - Journey Management and Job List',
      subtitle:
          'Develop journey management and job list functionality for the development of the journey management & job list...',
      key: ValueKey("Journey Management and Job List"),
      details: '',
    ),
    const TimelineTile(
      icon: Icon(Icons.work, color: Colors.white),
      title: 'Week 4 July 2023 - Hiring Package',
      subtitle:
          'Develop and finalize the hiring package features for the development of the hiring package for new employees ...',
      key: ValueKey("Hiring Package"),
      details: '',
    ),
    const TimelineTile(
      icon: Icon(Icons.smartphone, color: Colors.white),
      title: 'Week 1 August 2023 - Westway Video Chat',
      subtitle:
          'Develop video chat features and functionality for the development of the Westway Video Chat feature...',
      key: ValueKey("Satellite Tracking"),
      details: '',
    ),
    const TimelineTile(
      icon: Icon(Icons.satellite_alt, color: Colors.white),
      title: 'Week 2 August 2023 - Satellite Tracking',
      subtitle:
          'Develop satellite tracking features and functionality for the development of the satellite tracking feature...',
      key: ValueKey("Satellite Tracking"),
      details: '',
    ),
    const TimelineTile(
      icon: Icon(Icons.show_chart, color: Colors.white),
      title: 'Week 3 August 2023 - Data Analysis',
      subtitle:
          'Develop data analysis and visualization features for the development of the data analysis & visualization tools...',
      key: ValueKey("Data Analysis"),
      details: '',
    ),
    const TimelineTile(
      icon: Icon(Icons.chat_bubble, color: Colors.white),
      title: 'Week 4 August 2023 - WestwayChatGPT4',
      subtitle:
          'Develop WestwayChatGPT4 functionality for the development of the WestwayChatGPT4...',
      key: ValueKey("WestwayChatGPT4"),
      details: '',
      // hoursSpent: ,
    ),
    const TimelineTile(
      icon: Icon(Icons.bug_report, color: Colors.white),
      title: 'Week 1 September 2023 - Final Testing and Launch',
      subtitle:
          'Detailed plan for final testing and debugging, preparation for launch.',
      key: ValueKey("Final Testing and Launch"),
      details: '',
    ),
    const TimelineTile(
      icon: Icon(Icons.workspace_premium_outlined, color: Colors.white),
      title:
          "Week 2 September 2023 - Westway EDR, Video Surveillance, & Data Encryption Software ",
      subtitle: 'Continue building industry leading software for Westway...',
      key: ValueKey("Final Testing and Launch"),
      details: '',
    ),
  ];

  RoadmapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Westway App Development Roadmap'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 0, 150, 8),
                Color.fromARGB(255, 1, 51, 0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: timelineTiles.length,
        itemBuilder: (context, index) {
          if (timelineTiles[index] is TimelineTile) {
            return index % 2 == 0
                ? timelineTiles[index]
                : ReversedTimelineTile(
                    timelineTile: timelineTiles[index] as TimelineTile);
          } else {
            return timelineTiles[index];
          }
        },
      ),
    );
  }
}
