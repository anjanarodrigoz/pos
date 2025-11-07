import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos/Pages/initial_setup_page.dart';
import 'package:pos/Pages/login_page.dart';
import 'package:pos/database/cart_db_service.dart';
import 'package:pos/database/pos_database.dart';
import 'package:pos/repositories/customer_repository.dart';
import 'package:pos/repositories/item_repository.dart';
import 'package:pos/repositories/invoice_repository.dart';
import 'package:pos/repositories/supplier_repository.dart';
import 'package:pos/repositories/payment_repository.dart';
import 'package:pos/repositories/quotation_repository.dart';
import 'package:pos/repositories/credit_note_repository.dart';
import 'package:pos/services/auth_service.dart';
import 'package:pos/services/encryption_service.dart';
import 'package:pos/services/logger_service.dart';
import 'package:pos/services/secure_storage_service.dart';
import 'package:pos/utils/val.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger
  AppLogger.info('Initializing POS System...');

  // Initialize secure storage service FIRST (for passwords and credentials)
  try {
    final secureStorage = SecureStorageService();
    await secureStorage.initialize();
    AppLogger.info('Secure storage initialized');
  } catch (e) {
    AppLogger.error('Failed to initialize secure storage', e);
  }

  // Initialize encryption service (required for secure data storage)
  try {
    await EncryptionService.initialize();
    AppLogger.info('Encryption service initialized');
  } catch (e) {
    AppLogger.error('Failed to initialize encryption service', e);
  }

  // Initialize GetStorage databases
  await GetStorage.init();
  await GetStorage.init(DBVal.customers);
  await GetStorage.init(DBVal.items);
  await GetStorage.init(DBVal.invoice);
  await GetStorage.init(DBVal.cart);
  await GetStorage.init(DBVal.comments);
  await GetStorage.init(DBVal.supplyer);
  await GetStorage.init(DBVal.extraCharges);
  await GetStorage.init(DBVal.supplyerInvoice);
  await GetStorage.init(DBVal.quatation);
  await GetStorage.init(DBVal.creditNote);
  await GetStorage.init(DBVal.store);
  AppLogger.info('Storage initialized');

  // Reset cart
  final storage = CartDB();
  await storage.resetCart();

  // Initialize Drift database and repositories
  try {
    final database = POSDatabase();
    Get.put(database);
    AppLogger.info('Drift database initialized');

    // Register repositories with GetX
    Get.put(CustomerRepository(database));
    Get.put(ItemRepository(database));
    Get.put(InvoiceRepository(database));
    Get.put(SupplierRepository(database));
    Get.put(PaymentRepository(database));
    Get.put(QuotationRepository(database));
    Get.put(CreditNoteRepository(database));
    AppLogger.info('Repositories registered with GetX');
  } catch (e, stack) {
    AppLogger.error('Failed to initialize database and repositories', e, stack);
  }

  // Initialize window manager
  await windowManager.ensureInitialized();

  AppLogger.info('POS System initialized successfully');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget? _homePage;

  @override
  void initState() {
    super.initState();
    _checkPasswordSetup();
  }

  Future<void> _checkPasswordSetup() async {
    // Check if password has been set
    final hasPassword = await AuthService.hasPassword();

    setState(() {
      if (hasPassword) {
        _homePage = LoginPage();
        AppLogger.info('Password exists, showing login page');
      } else {
        _homePage = const InitialSetupPage();
        AppLogger.info('No password set, showing initial setup page');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        textTheme: const TextTheme(
            // your desired white color
            ),
      ),
      debugShowCheckedModeBanner: false,
      home: _homePage ??
          const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
    );
  }
}
