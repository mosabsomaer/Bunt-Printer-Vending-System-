import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class test2 extends StatelessWidget {
  const test2(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: PdfPreview(
          build: (format) => _generatePdf(format, title),
        ),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            children: [
              // pw.SizedBox(
              //   width: double.infinity,
              //   child: pw.FittedBox(
              //     child: pw.Image(
              //       pw.MemoryImage(
              //         (await rootBundle.load('assets/download.png')).buffer.asUint8List(),
              //       ),
              //     ),
              //   ),
              // ),
            
              pw.Flexible(child: pw.FlutterLogo())
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
