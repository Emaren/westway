// import 'package:flutter/material.dart';
// import 'asset.dart';
// import 'asset_details.dart';

// class AssetCard extends StatelessWidget {
//   final Asset asset;

//   const AssetCard({Key? key, required this.asset}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => AssetDetails(asset: asset),
//           ),
//         );
//       },
//       child: LayoutBuilder(builder: (context, constraints) {
//         final titleFontSize = constraints.maxWidth * 0.05;
//         final ageFontSize = constraints.maxWidth * 0.04;
//         return Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               AspectRatio(
//                 aspectRatio: .9,
//                 child: ClipRRect(
//                   borderRadius: const BorderRadius.vertical(
//                     top: Radius.circular(10),
//                   ),
//                   child: Image.asset(
//                     asset.imageUrl ??
//                         'assets/westway.png', // replace with the path of your default image
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(8, 0.1, 8, 6),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       asset.category,
//                       style: TextStyle(
//                           fontSize: titleFontSize, fontWeight: FontWeight.bold),
//                       textAlign: TextAlign.center,
//                       maxLines: 2,
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       '${asset.age}',
//                       textAlign: TextAlign.center,
//                       style:
//                           TextStyle(fontSize: ageFontSize, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }
