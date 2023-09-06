import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos/Pages/main_window.dart';
import 'package:pos/database/Cart_db_service.dart';
import 'package:pos/utils/val.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await GetStorage.init(DBVal.customers);
  await GetStorage.init(DBVal.items);
  await GetStorage.init(DBVal.invoice);
  await GetStorage.init(DBVal.cart);
  await GetStorage.init(DBVal.comments);
  await GetStorage.init(DBVal.supplyer);
  await GetStorage.init(DBVal.extraCharges);

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
