import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart' as pw;
import 'timesheet_data.dart';

Future<pw.Document> generatePDF(List<TimesheetData> timesheetData,
    String? displayName, String supervisorName) async {
  timesheetData.sort((a, b) => a.dateYMD.compareTo(b.dateYMD));

  final pdf = pw.Document();

  final headers = [
    'Pay Period',
    'Date (2023)',
    'Start Time',
    'End Time',
    'Total Hrs',
  ];

  final timesheetTable = pw.Table(
    border: pw.TableBorder.all(width: 1, color: pw.PdfColors.black),
    children: [
      pw.TableRow(
        decoration: const pw.BoxDecoration(
          border: pw.Border(
            bottom: pw.BorderSide(
              color: pw.PdfColors.black,
              width: 1,
            ),
          ),
        ),
        children: headers.map((header) {
          return pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 5.0),
            child: pw.Container(
              alignment: pw.Alignment.center,
              child: pw.Text(header,
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
          );
        }).toList(),
      ),
      ...timesheetData.map((item) {
        double hoursWorked = (item.endHour + item.endMinute / 60.0) -
            (item.startHour + item.startMinute / 60.0) -
            (item.lunchTaken ? 0.5 : 0);
        print(
            'Data for date ${item.dateYMD}: startHour=${item.startHour}, startMinute=${item.startMinute}, endHour=${item.endHour}, endMinute=${item.endMinute}, lunchTaken=${item.lunchTaken}, hoursWorked=$hoursWorked');

        int payPeriod = DateTime.parse(item.dateYMD).day ~/ 14 + 1;
        String startTime =
            "${item.startHour.toString().padLeft(2, '0')}:${item.startMinute.toString().padLeft(2, '0')}";
        String endTime =
            "${item.endHour.toString().padLeft(2, '0')}:${item.endMinute.toString().padLeft(2, '0')}";
        return pw.TableRow(
          children: [
            pw.Container(
              alignment: pw.Alignment.center,
              child: pw.Text(item.dateYMD),
            ),
            pw.Container(
              alignment: pw.Alignment.center,
              child: pw.Text(DateTime.parse(item.dateYMD).day.toString()),
            ),
            pw.Container(
              alignment: pw.Alignment.center,
              child: pw.Text(startTime),
            ),
            pw.Container(
              alignment: pw.Alignment.center,
              child: pw.Text(endTime),
            ),
            pw.Container(
              alignment: pw.Alignment.center,
              child: pw.Text(hoursWorked.toStringAsFixed(2)),
            ),
          ],
        );
      }).toList(),
    ],
  );

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(children: [
            pw.Text('Employee Name: ',
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.Text('$displayName',
                style: pw.TextStyle(
                    fontSize: 20,
                    // decoration: pw.TextDecoration.underline,
                    fontWeight: pw.FontWeight.bold)),
          ]),
          pw.SizedBox(height: 20),
          timesheetTable,
          pw.SizedBox(height: 20),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Text('Supervisor Approval: ',
                  style: pw.TextStyle(
                      fontSize: 20,
                      // decoration: pw.TextDecoration.underline,
                      fontWeight: pw.FontWeight.bold)),
              pw.Text(supervisorName,
                  style: pw.TextStyle(
                      fontSize: 20,
                      // decoration: pw.TextDecoration.underline,
                      fontWeight: pw.FontWeight.bold)),
            ],
          ),
        ],
      ),
    ),
  );

  return pdf;
}
