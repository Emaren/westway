import 'package:flutter/material.dart';
import 'asset.dart';
import 'asset_details.dart';

class DatabaseAssetCard extends StatelessWidget {
  final Asset asset;

  const DatabaseAssetCard({Key? key, required this.asset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AssetDetails(asset: asset),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: asset.imageUrl != null
                      ? Image.network(
                          asset.imageUrl!,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/westway.png',
                          fit: BoxFit.fill,
                        ),
                ),
                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          asset.unitNumber,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          asset.category,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          asset.type,
                          style: const TextStyle(color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          asset.currentLocation,
                          style: const TextStyle(color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        // Text(
                        //   '${asset.age} years',
                        //   style: const TextStyle(color: Colors.grey),
                        //   overflow: TextOverflow.ellipsis,
                        //   maxLines: 1,
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
