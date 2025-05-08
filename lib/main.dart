import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'data/menu_data.dart';
import 'models/menu_item.dart';
import 'widgets/menu_grid.dart';
import 'widgets/order_bottom_sheet.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<MenuItem> _cartItems = [];
  int _selectedTable = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  void _addToCart(MenuItem item) {
    setState(() {
      _cartItems.add(item);
    });
  }

  void _removeFromCart(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  void _selectTable() async {
    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Masa Seçin'),
        content: DropdownButtonFormField<int>(
          value: _selectedTable,
          items: List.generate(10, (index) => index + 1)
              .map((e) => DropdownMenuItem(value: e, child: Text('Masa $e')))
              .toList(),
          onChanged: (value) => Navigator.pop(context, value),
        ),
      ),
    );

    if (result != null) {
      setState(() => _selectedTable = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Menü'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: categories.map((category) => Tab(text: category)).toList(),
        ),
        actions: [
          IconButton(
            icon: badges.Badge(
              badgeStyle: badges.BadgeStyle(
                badgeColor: Colors.red, // İsteğe bağlı stil
              ),
              badgeContent: Text(
                // Artık çalışacak
                _cartItems.length.toString(),
                style: TextStyle(color: Colors.white),
              ),
              child: const Icon(Icons.shopping_cart),
            ),
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (context) => OrderBottomSheet(
                cartItems: _cartItems,
                onRemove: _removeFromCart,
                selectedTable: _selectedTable,
                onSelectTable: _selectTable,
              ),
            ),
          )
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: categories.map((category) {
          final categoryItems =
              menuItems.where((item) => item.category == category).toList();
          return MenuGrid(
            items: categoryItems,
            onAddToCart: _addToCart,
          );
        }).toList(),
      ),
    );
  }
}
