import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});
//HP LaserJet M101-M106
//assets/logoblack.pdf

Future<Uint8List> _generatePdf() async {
  final ByteData assetData = await rootBundle.load('assets/logoblack.pdf');
  

  final pdfImage = pw.MemoryImage(assetData.buffer.asUint8List());
const format = PdfPageFormat.a4;
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      
      pageFormat: format,
      build: (context) {
        return pw.Center(
          child: pw.Image(pdfImage),
        );
      },
    ),
  );

  return pdf.save();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pnt PDF'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Printing.layoutPdf(onLayout: (format) => _generatePdf());
          },
          child: const Text('Print'),
        ),
      ),
    );
  }
}
