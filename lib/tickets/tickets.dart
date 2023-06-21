import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:uuid/uuid.dart';

import 'all_tickets_page.dart';

class CustomTextFormField extends StatefulWidget {
  final String labelText;
  final String docId;
  final String uid;

  const CustomTextFormField(
      {Key? key,
      required this.labelText,
      required this.docId,
      required this.uid})
      : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField>
    with AutomaticKeepAliveClientMixin<CustomTextFormField> {
  final TextEditingController _controller = TextEditingController();
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = initField();
  }

  Future<void> initField() async {
    final documentSnapshot = await FirebaseFirestore.instance
        .collection('tickets')
        .doc(widget.docId)
        .get();
    if (documentSnapshot.exists) {
      print('Document ${widget.docId} exists.');
      var data = documentSnapshot.data();
      if (data != null && data.containsKey(widget.labelText)) {
        print('Document ${widget.docId} contains key ${widget.labelText}.');
        _controller.text = data[widget.labelText].toString();
      } else {
        print(
            'Document ${widget.docId} does not contain key ${widget.labelText}. Setting to empty string.');
        _controller.text = '';
      }
    } else {
      print(
          'Document ${widget.docId} does not exist. Setting to empty string.');
      _controller.text = '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CustomTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.docId != oldWidget.docId) {
      _controller.clear();
      _initFuture = initField();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SpinKitHourGlass(
              color: Color.fromARGB(255, 6, 8, 152),
            );
          } else {
            return TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: widget.labelText,
                ),
                onChanged: (val) {
                  if (widget.labelText.isNotEmpty) {
                    print(
                        'Updating ${widget.labelText} to $val in document ${widget.docId}.');
                    FirebaseFirestore.instance
                        .collection('tickets')
                        .doc(widget.docId)
                        .set({widget.labelText: val}, SetOptions(merge: true));
                  }
                });
          }
        });
  }

  @override
  bool get wantKeepAlive => true;
}

class Tickets extends StatefulWidget {
  final String uid;
  const Tickets({Key? key, required this.uid}) : super(key: key);

  @override
  TicketsState createState() => TicketsState();
}

class TicketsState extends State<Tickets> {
  final _formKey = GlobalKey<FormState>();
  String docId = const Uuid().v1();

  void generateNewTicket() async {
    DocumentSnapshot currentDoc =
        await FirebaseFirestore.instance.collection('tickets').doc(docId).get();

    if (currentDoc.exists) {
      var data = currentDoc.data() as Map<String, dynamic>?;
      if (data != null &&
          data.values
              .any((value) => value != null && value.toString().isNotEmpty)) {
        setState(() {
          docId = const Uuid().v1();
        });
        FirebaseFirestore.instance.collection('tickets').doc(docId).set({});
      }
    } else {
      setState(() {
        docId = const Uuid().v1();
      });
      FirebaseFirestore.instance.collection('tickets').doc(docId).set({});
    }
  }

  List<Widget> _buildColumns(List<String> fields, String docId) {
    return fields.map((field) {
      return CustomTextFormField(
        key: ValueKey("$docId-$field"),
        labelText: field,
        docId: docId,
        uid: widget.uid,
      );
    }).toList();
  }

  Widget _customTableCell(int rowIndex, int columnIndex,
      [String labelText = '', bool isCentered = false]) {
    if (labelText.isEmpty) {
      labelText = 'cell${rowIndex}x$columnIndex';
    }
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: isCentered
            ? Center(
                child: Text(labelText,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)))
            : CustomTextFormField(
                key: ValueKey("$docId-$labelText"),
                labelText: labelText,
                docId: docId,
                uid: widget.uid,
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var layouts = [
      {
        'image': 'assets/westway.png',
        'fields': ['Field Tech', 'Date'],
      },
      {
        'fields': [
          'Company',
          'Address',
          'Postal Code',
          'City',
          'Contact',
          'Phone'
        ],
        'additional_fields': [
          'Well Name',
          'LSD',
          'Rig',
          'Foreman',
          'Phone #',
          'AFE #'
        ],
      },
    ];

    var tableRows = List<TableRow>.generate(
      16,
      (i) => i == 0
          ? TableRow(children: [
              for (var header in [
                'IN/OUT',
                'Assets',
                'Units',
                'Unit Price',
                'Extended'
              ])
                _customTableCell(i, 0, header, true),
            ])
          : i < 11
              ? TableRow(
                  children:
                      List.generate(5, (index) => _customTableCell(i, index)),
                )
              : i == 11
                  ? TableRow(
                      children: [
                        _customTableCell(i, 0),
                        _customTableCell(
                            i, 1, 'Subtotal for Service Call', true),
                        _customTableCell(i, 2),
                        _customTableCell(i, 3),
                        _customTableCell(i, 4),
                      ],
                    )
                  : i <= 14
                      ? TableRow(
                          children: [
                            _customTableCell(i, 0),
                            _customTableCell(i, 1),
                            _customTableCell(
                                i,
                                2,
                                i == 12
                                    ? 'Mileage in Kms'
                                    : i == 13
                                        ? 'PST/HST'
                                        : 'GST',
                                true),
                            _customTableCell(
                                i,
                                3,
                                i == 13
                                    ? '%'
                                    : i == 14
                                        ? '5%'
                                        : '',
                                true),
                            _customTableCell(i, 4),
                          ],
                        )
                      : i == 15
                          ? TableRow(
                              children: [
                                _customTableCell(i, 0),
                                _customTableCell(i, 1),
                                _customTableCell(i, 2),
                                _customTableCell(i, 3,
                                    'Total (including GST/PST/HST)', true),
                                _customTableCell(i, 4),
                              ],
                            )
                          : TableRow(
                              children: List.generate(
                                  5, (index) => _customTableCell(i, index))),
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var layout in layouts)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if ((layout['image'] as String?) != null)
                              Expanded(
                                flex: 1,
                                child: Image.asset(
                                  layout['image'] as String,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            if ((layout['image'] as String?) != null)
                              const SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: _buildColumns(
                                    layout['fields'] as List<String>, docId),
                              ),
                            ),
                            if ((layout['additional_fields']
                                    as List<String>?) !=
                                null) ...[
                              const SizedBox(width: 5),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: _buildColumns(
                                      layout['additional_fields']
                                          as List<String>,
                                      docId),
                                ),
                              ),
                            ],
                          ],
                        ),
                      const SizedBox(height: 10),
                      Table(
                        border: TableBorder.all(color: Colors.black),
                        columnWidths: {
                          for (var i = 0; i < 5; i++)
                            i: const FlexColumnWidth(1),
                        },
                        children: tableRows,
                      ),
                      const SizedBox(height: 20),
                      const Divider(
                        height: 1,
                        thickness: 1,
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AllTicketsPage()),
                            );
                          },
                          child: const Text("All Tickets"),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: generateNewTicket,
        child: const Icon(Icons.add),
      ),
    );
  }
}
