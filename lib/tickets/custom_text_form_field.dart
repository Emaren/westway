// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

// class CustomTextFormField extends StatefulWidget {
//   final String labelText;
//   final String docId;
//   final String uid;

//   const CustomTextFormField(
//       {Key? key,
//       required this.labelText,
//       required this.docId,
//       required this.uid})
//       : super(key: key);

//   @override
//   _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
// }

// class _CustomTextFormFieldState extends State<CustomTextFormField>
//     with AutomaticKeepAliveClientMixin<CustomTextFormField> {
//   final TextEditingController _controller = TextEditingController();
//   late Future<void> _initFuture;

//   @override
//   void initState() {
//     super.initState();
//     _initFuture = initField();
//   }

//   Future<void> initField() async {
//     final documentSnapshot = await FirebaseFirestore.instance
//         .collection('tickets')
//         .doc(widget.docId)
//         .get();
//     if (documentSnapshot.exists) {
//       print('Document ${widget.docId} exists.');
//       var data = documentSnapshot.data();
//       if (data != null && data.containsKey(widget.labelText)) {
//         print('Document ${widget.docId} contains key ${widget.labelText}.');
//         _controller.text = data[widget.labelText].toString();
//       } else {
//         print(
//             'Document ${widget.docId} does not contain key ${widget.labelText}. Setting to empty string.');
//         _controller.text = '';
//       }
//     } else {
//       print(
//           'Document ${widget.docId} does not exist. Setting to empty string.');
//       _controller.text = '';
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   void didUpdateWidget(covariant CustomTextFormField oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.docId != oldWidget.docId) {
//       _controller.clear();
//       _initFuture = initField();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return FutureBuilder(
//         future: _initFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const SpinKitHourGlass(
//               color: Color.fromARGB(255, 6, 8, 152),
//             );
//           } else {
//             return TextFormField(
//                 controller: _controller,
//                 decoration: InputDecoration(
//                   labelText: widget.labelText,
//                 ),
//                 onChanged: (val) {
//                   if (widget.labelText.isNotEmpty) {
//                     print(
//                         'Updating ${widget.labelText} to $val in document ${widget.docId}.');
//                     FirebaseFirestore.instance
//                         .collection('tickets')
//                         .doc(widget.docId)
//                         .set({widget.labelText: val}, SetOptions(merge: true));
//                   }
//                 });
//           }
//         });
//   }

//   @override
//   bool get wantKeepAlive => true;
// }
