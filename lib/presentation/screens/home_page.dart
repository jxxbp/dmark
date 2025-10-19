import 'package:dmark_test/presentation/provider/theme_provider.dart';
import 'package:dmark_test/presentation/screens/products_page.dart';
import 'package:dmark_test/presentation/screens/stocks_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [const ProductsScreen(), const StocksScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Управление складом'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_4),
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Товары'),
          BottomNavigationBarItem(
            icon: Icon(Icons.warehouse),
            label: 'Остатки',
          ),
        ],
      ),
    );
  }
}
