import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'asset.dart';
import 'database_asset_card.dart';

class AssetsDisplayPage extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;

  AssetsDisplayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assets Display'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _firestore.collection('assets').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: SpinKitCubeGrid(
              color: Color.fromARGB(255, 27, 2, 191),
              size: 150.0,
            ));
          }
          final assetsDocs = snapshot.data!.docs;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 1,
              childAspectRatio: 0.5,
            ),
            itemCount: assetsDocs.length,
            itemBuilder: (context, index) {
              var doc = assetsDocs[index];
              var data = doc.data();
              Asset asset = Asset.fromMap(data, doc.id);
              return DatabaseAssetCard(asset: asset);
            },
          );
        },
      ),
    );
  }
}
