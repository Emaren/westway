import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/controllers/simple_hidden_drawer_controller.dart';

import 'asset_entry_page.dart';
import 'database_scroll.dart';

class Assets extends StatefulWidget {
  final DocumentReference<Map<String, dynamic>>? userDocRef;
  final String title;

  const Assets({super.key, required this.userDocRef, required this.title});

  @override
  _AssetsState createState() => _AssetsState();
}

class _AssetsState extends State<Assets> {
  final List<Map<String, dynamic>> _assets = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.wifi),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.gas_meter_outlined),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.speaker),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.security),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_rounded),
                        onPressed: () {
                          Navigator.push(
                            context,
                            // MaterialPageRoute(builder: (context) => DatabaseScroll()),
                            MaterialPageRoute(
                                builder: (context) => const AssetEntryPage()),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.phone_android),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.speaker_phone),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.satellite_alt),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.cell_tower),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.desktop_windows),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DatabaseScroll(),
          // child: ListView.builder(
          //   itemCount: _assets.length,
          //   itemBuilder: (context, index) {
          //     final asset = _assets[index];

          // return Card(
          //   elevation: 4,
          //   margin: const EdgeInsets.symmetric(vertical: 8),
          //   child: ListTile(
          //     leading: CircleAvatar(
          //       child: Text(asset['name'][0]),
          //     ),
          //     title: Text(asset['name']),
          //     subtitle: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Text('Location: ${asset['location']}'),
          //         Text('Repair Status: ${asset['repairStatus']}'),
          //         Text('Age: ${asset['age']}'),
          //       ],
          //     ),
          //     trailing: IconButton(
          //       icon: const Icon(Icons.map),
          //       onPressed: () {},
          //     ),
          //   ),
          // );
          // },
          // ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              SimpleHiddenDrawerController? controller =
                  SimpleHiddenDrawerController.of(context);
              controller.toggle();

              SimpleHiddenDrawerController.of(context).toggle();
            },
            child: const Icon(Icons.menu)));
  }
}
