import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../auth_service.dart';
import '../pdf_generator.dart';
import '../timesheet_data.dart';
import 'mini_timesheet_utils.dart';

class MiniTimesheetWidget extends StatefulWidget {
  final List<TimesheetData> timesheetData;
  final AuthService authService;

  final String? displayName;
  final String uid;
  final bool displaySendIcon;

  final bool displayDeleteIcon;

  const MiniTimesheetWidget({
    super.key,
    required this.timesheetData,
    this.displayName,
    required this.uid,
    required this.authService,
    required this.displaySendIcon,
    this.displayDeleteIcon = false,
  });

  @override
  _MiniTimesheetWidgetState createState() => _MiniTimesheetWidgetState();
}

class _MiniTimesheetWidgetState extends State<MiniTimesheetWidget> {
  final _firestore = FirebaseFirestore.instance;
  bool isSaved = false;
  String? docId;
  String? supervisorName;
  String? currentUserDisplayName;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _checkTimesheetExistence();
    _getCurrentUserDisplayName();
  }

  Future<void> _getCurrentUserDisplayName() async {
    currentUserDisplayName =
        await widget.authService.getCurrentUserDisplayNameFromFirestore();

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _checkTimesheetExistence() async {
    QuerySnapshot snapshot = await _firestore
        .collection('timesheets')
        .where('uid', isEqualTo: widget.uid)
        .get();

    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot timesheetDoc = snapshot.docs.first;

      setState(() {
        isSaved = true;
        docId = timesheetDoc.id;
        supervisorName =
            (timesheetDoc.data() as Map<String, dynamic>)['supervisorName'];
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentPayPeriodStart = calculateStartDate();
    DateTime currentPayPeriodEnd;

    // Check whether the pay period start is before the 24th or not.
    if (currentPayPeriodStart.day < 24) {
      currentPayPeriodEnd = currentPayPeriodStart.add(const Duration(days: 14));
    } else {
      currentPayPeriodEnd = currentPayPeriodStart.add(const Duration(days: 15));
    }

    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 5),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 160,
                  ),
                  child: Image.asset('assets/westway.png',
                      alignment: Alignment.centerLeft),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        56, 10, MediaQuery.of(context).size.width * 0.05, 1),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          AutoSizeText(
                            'TIME CARD',
                            style: TextStyle(
                              fontSize: 16,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 2
                                ..color =
                                    const Color.fromARGB(255, 171, 27, 17),
                            ),
                          ),
                          const AutoSizeText(
                            'TIME CARD',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Align(
              alignment: Alignment.topRight,
              child: Text(
                '${currentPayPeriodStart.month}/${currentPayPeriodStart.day} - ${currentPayPeriodEnd.month}/${currentPayPeriodEnd.day}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                const AutoSizeText(
                  'Employee Name: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  minFontSize: 10,
                  maxLines: 1,
                ),
                AutoSizeText(
                  widget.displayName ?? '________',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationThickness: 2.0,
                  ),
                  minFontSize: 10,
                  maxLines: 1,
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 5),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Table(
          border: TableBorder.all(color: Colors.black),
          defaultColumnWidth: const FlexColumnWidth(1),
          children: createTableRows(widget.timesheetData,
              generatePayPeriodDates(currentPayPeriodStart)),
        ),
      ),
      Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const AutoSizeText('Supervisor Approval: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          minFontSize: 10,
                          maxLines: 1),
                      AutoSizeText(
                        (isSaved ? supervisorName : currentUserDisplayName) ??
                            'Loading...',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationThickness: 2.0,
                        ),
                        minFontSize: 10,
                        maxLines: 1,
                      ),
                    ],
                  ),
                  if (widget.displaySendIcon)
                    StreamBuilder<DocumentSnapshot>(
                        stream: _firestore
                            .collection('timesheets')
                            .doc(docId)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasData && snapshot.data!.exists) {
                            isSaved = true;
                            supervisorName = (snapshot.data!.data()
                                as Map<String, dynamic>)['supervisorName'];
                          } else {
                            isSaved = false;
                          }
                          return SizedBox(
                              height: 60.0,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 18.0),
                                child: GestureDetector(
                                    onTap: () async {
                                      if (isSaved) {
                                        if (docId != null) {
                                          try {
                                            await _firestore
                                                .collection('timesheets')
                                                .doc(docId)
                                                .delete();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        'Timesheet deleted!')));
                                            setState(() {
                                              isSaved = false;
                                              supervisorName =
                                                  currentUserDisplayName;
                                            });
                                          } catch (e) {
                                            print(e);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        'Failed to delete timesheet.')));
                                          }
                                        }
                                      } else {
                                        try {
                                          supervisorName =
                                              currentUserDisplayName;
                                          var docRef = await _firestore
                                              .collection('timesheets')
                                              .add({
                                            'uid': widget.uid,
                                            'displayName': widget.displayName,
                                            'timesheetData': widget
                                                .timesheetData
                                                .map((data) => data.toJson())
                                                .toList(),
                                            'timestamp':
                                                FieldValue.serverTimestamp(),
                                            'supervisorName': supervisorName,
                                          });

                                          var newDoc = await docRef.get();
                                          setState(() {
                                            isSaved = true;
                                            docId = newDoc.id;
                                            supervisorName =
                                                newDoc['supervisorName'];
                                          });

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Timesheet submitted! ${DateTime.now()}')));
                                        } catch (e) {
                                          print(e);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Failed to submit timesheet.')),
                                          );
                                        }
                                      }
                                    },
                                    child: Icon(
                                      isSaved ? Icons.check : Icons.send,
                                      color: isSaved
                                          ? const Color.fromARGB(255, 0, 128, 0)
                                          : const Color.fromARGB(
                                              255, 33, 8, 192),
                                    )),
                              ));
                        }),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                if (widget.displayDeleteIcon)
                  IconButton(
                    icon: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 192, 1, 1),
                            Color.fromARGB(255, 88, 0, 0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          tileMode: TileMode.clamp,
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.srcIn,
                      child: const Icon(Icons.cancel, size: 30.0),
                    ),
                    onPressed: () async {
                      if (docId != null) {
                        try {
                          await _firestore
                              .collection('timesheets')
                              .doc(docId)
                              .delete();
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Timesheet deleted!')));
                              setState(() {
                                isSaved = false;
                                supervisorName = currentUserDisplayName;
                              });
                            }
                          });
                        } catch (e) {
                          print(e);
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Failed to delete timesheet.')));
                            }
                          });
                        }
                      }
                    },
                  ),
                if (widget.displayDeleteIcon)
                  IconButton(
                    icon: const Icon(Icons.print,
                        color: Color.fromARGB(255, 82, 82, 82)),
                    iconSize: 30.0,
                    onPressed: () async {
                      final pdf = await generatePDF(widget.timesheetData,
                          widget.displayName, supervisorName ?? 'Unknown User');
                      await Printing.layoutPdf(
                          onLayout: (PdfPageFormat format) async => pdf.save());
                    },
                  ),
                if (widget.displayDeleteIcon)
                  IconButton(
                    icon: const Icon(Icons.email,
                        color: Color.fromARGB(255, 82, 82, 82)),
                    iconSize: 30.0,
                    onPressed: () async {
                      final pdf = await generatePDF(widget.timesheetData,
                          widget.displayName, supervisorName ?? 'Unknown User');
                      await Printing.sharePdf(
                          bytes: await pdf.save(),
                          filename:
                              '${widget.displayName ?? 'Unknown User'}-timesheet.pdf');
                    },
                  )
              ])
            ],
          ))
    ]));
  }
}
