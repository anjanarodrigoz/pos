import 'package:get_storage/get_storage.dart';
import 'package:printing/printing.dart';

class PrinterManager {
  static PrinterManager? _instance;
  final GetStorage _storage = GetStorage();
  final String _printerKey = 'selected_printer';
  List<Printer> printerList = [];
  Printer? printer;

  PrinterManager._();

  factory PrinterManager() => _instance ??= PrinterManager._();

  // Discover available printers
  Future<void> discoverPrinters() async {
    final List<Printer> printers = await Printing.listPrinters();
    printerList = printers;
  }

  // Save selected printer to GetStorage
  void saveSelectedPrinter(Printer printer) {
    _storage.write(_printerKey, printer.toMap());
  }

  // Get the saved printer from GetStorage
  Printer? getSavedPrinter() {
    final printerJson = _storage.read<Map<String, dynamic>>(_printerKey);
    if (printerJson != null) {
      return Printer.fromMap(printerJson);
    }
    return null;
  }

  Future<bool> checkSavedPrinterAvailability(Printer? savedPrinter) async {
    if (savedPrinter != null) {
      try {
        for (Printer printer in printerList) {
          if (savedPrinter.name == printer.name &&
              savedPrinter.model == printer.model) {
            return printer.isAvailable;
          }
        }
        return false;
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }
}
