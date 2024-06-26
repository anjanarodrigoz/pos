import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos/Pages/login_page.dart';
import 'package:pos/database/cart_db_service.dart';
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
  await GetStorage.init(DBVal.supplyerInvoice);
  await GetStorage.init(DBVal.quatation);
  await GetStorage.init(DBVal.creditNote);
  await GetStorage.init(DBVal.store);

  final storage = CartDB();

  await storage.resetCart();

  await windowManager.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        theme: ThemeData(
          textTheme: const TextTheme(
              // your desired white color
              ),
        ),
        debugShowCheckedModeBanner: false,
        home: LoginPage());
  }
}
