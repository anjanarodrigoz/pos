import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class PrintPDF {
  PrintPDF(var doc) {
    print(doc);
  }

  static print(doc) async {
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }
}
