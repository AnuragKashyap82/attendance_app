import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class reportt extends StatelessWidget {
  final List<dynamic> list;
  final String clas;

  reportt({required this.list, required this.clas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PdfPreview(
        build: (format) => generateDocument(format),
      ),
    );
  }

  Future<Uint8List> generateDocument(PdfPageFormat format) async {
    final doc = pw.Document();

    final font1 = await PdfGoogleFonts.openSansRegular();
    final font2 = await PdfGoogleFonts.openSansBold();

    final itemsPerPage = 30; // Number of items per page
    final totalPages = (list.length / itemsPerPage).ceil();

    for (var page = 0; page < totalPages; page++) {
      final startIdx = page * itemsPerPage;
      final endIdx = (page + 1) * itemsPerPage;
      final currentPageItems = list.sublist(startIdx, endIdx < list.length ? endIdx : list.length);

      doc.addPage(
        pw.Page(
          pageTheme: pw.PageTheme(
            pageFormat: format.copyWith(
              marginBottom: 20,
              marginLeft: 20,
              marginRight: 20,
              marginTop: 20,
            ),
            orientation: pw.PageOrientation.portrait,
            theme: pw.ThemeData.withFont(
              base: font1,
              bold: font2,
            ),
          ),
          build: (context) {
            final content = <pw.Widget>[
              pw.Text(
                'Anurag Kashyap',
                style: pw.TextStyle(
                  fontSize: 25,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              // ... other header elements
              pw.SizedBox(height: 20),
              pw.Table(
                defaultColumnWidth: pw.FixedColumnWidth(120.0),
                border: pw.TableBorder.all(
                  style: pw.BorderStyle.solid,
                  width: 1,
                ),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text('Index', style: pw.TextStyle(fontSize: 15)),
                        ],
                      ),
                      pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text('Name', style: pw.TextStyle(fontSize: 15)),
                        ],
                      ),
                    ],
                  ),
                  for (var index = 0; index < currentPageItems.length; index++)
                    pw.TableRow(
                      children: [
                        pw.Column(
                          children: [
                            pw.Text(
                              (startIdx + index + 1).toString(),
                              style: pw.TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        pw.Column(
                          children: [
                            pw.Text(
                              currentPageItems[index].toString(),
                              style: pw.TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ];

            return pw.Column(children: content);
          },
        ),
      );
    }

    return doc.save();
  }


}
