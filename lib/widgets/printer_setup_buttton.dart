
import 'package:flutter/material.dart';
import 'package:pos/widgets/pos_button.dart';
import 'package:printing/printing.dart';
import '../api/printer_manager.dart';

class PrintSetupButton extends StatefulWidget {
  final Function(Printer?) onPrinterSelected;

  const PrintSetupButton({super.key, required this.onPrinterSelected});

  @override
  _PrintSetupButtonState createState() => _PrintSetupButtonState();
}

class _PrintSetupButtonState extends State<PrintSetupButton> {
  PrinterManager printerManager = PrinterManager();
  Printer? printer;
  bool isPrinterAvailable = false;

  @override
  void initState() {
    super.initState();
    checkPrinterAvailability();
  }

  @override
  Widget build(BuildContext context) {
    return PosButton(
      color: isPrinterAvailable ? Colors.green : Colors.amber.shade600,
      widget: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text('Setup Printer'),
        if (printer?.name != null)
          Text(
            printer!.name,
            style: const TextStyle(fontSize: 8.0),
          ),
      ]),
      onPressed: () async {
        await showPrinters();
        widget.onPrinterSelected(printer);
      },
    );
  }

  Future<void> checkPrinterAvailability() async {
    if (printerManager.printer != null) {
      printer = printerManager.printer;
      isPrinterAvailable = true;
    } else {
      await printerManager.discoverPrinters();
      printer = printerManager.getSavedPrinter();
      isPrinterAvailable =
          await printerManager.checkSavedPrinterAvailability(printer);
      if (isPrinterAvailable) {
        printerManager.printer = printer;
      }
    }
    setState(() {});
  }

  Future<void> showPrinters() async {
    printer = await Printing.pickPrinter(context: context);
    if (printer != null) {
      printerManager.saveSelectedPrinter(printer!);
      printerManager.printer = printer;
      isPrinterAvailable = true;
      widget.onPrinterSelected(printer);
      setState(() {});
    }
  }
}
