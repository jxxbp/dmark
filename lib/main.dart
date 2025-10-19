import 'package:dmark_test/data/model/product_model.dart';
import 'package:dmark_test/data/model/stock_model.dart';
import 'package:dmark_test/presentation/provider/product_provider.dart';
import 'package:dmark_test/presentation/provider/stock_provider.dart';
import 'package:dmark_test/presentation/provider/theme_provider.dart';
import 'package:dmark_test/presentation/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox<Product>('products');
  await Hive.openBox<Stock>('stocks');
  await Hive.openBox('settings');
  runApp(const Dmark());
}

class Dmark extends StatelessWidget {
  const Dmark({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => StockProvider()),
      ],
      child: MaterialApp(
        title: 'Dmark',
        themeMode: Provider.of<ThemeProvider>(context).themeMode,
        home: const HomeScreen(),
      ),
    );
  }
}
