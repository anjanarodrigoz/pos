import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos/Pages/main_window.dart';
import 'package:pos/database/Cart_db_service.dart';
import 'package:pos/database/customer_db_service.dart';
import 'package:pos/database/invoice_db_service.dart';
import 'package:pos/database/item_db_service.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await GetStorage.init('Customers');
  await GetStorage.init('Items');
  await GetStorage.init('Invoices');
  await GetStorage.init('Cart');
  await windowManager.ensureInitialized();

  final storage = CartDB();

  await storage.resetCart();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainWindow(),
    );
  }
}
