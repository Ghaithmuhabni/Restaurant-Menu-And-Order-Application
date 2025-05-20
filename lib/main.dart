import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'data/menu_data.dart';
import 'models/menu_item.dart';
import 'models/order.dart';
import 'widgets/menu_grid.dart';
import 'widgets/order_bottom_sheet.dart';
import 'orders_page.dart';

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
        tabBarTheme: TabBarTheme(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.orange[700],
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          labelPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
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
  List<MenuItem> _cartItems = [];
  List<Order> _activeOrders = [];
  List<int> _occupiedTables = [];
  int _selectedTable = 1;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  void _addToCart(MenuItem item) {
    setState(() {
      _cartItems = [..._cartItems, item];
      _refreshBottomSheet();
    });
  }

  void _removeFromCart(int index) {
    setState(() {
      _cartItems = List.from(_cartItems)..removeAt(index);
      _refreshBottomSheet();
    });
  }

  void _refreshBottomSheet() {
    if (_scaffoldKey.currentState != null) {
      _scaffoldKey.currentState!.showBottomSheet(
        (context) => OrderBottomSheet(
          cartItems: _cartItems,
          onRemove: _removeFromCart,
          selectedTable: _selectedTable,
          onSelectTable: _selectTable,
          isTableOccupied: _occupiedTables.contains(_selectedTable),
          onConfirmOrder: _confirmOrder,
        ),
      );
    }
  }

  Future<void> _selectTable() async {
    final availableTables = List.generate(10, (i) => i + 1)
        .where((table) => !_occupiedTables.contains(table))
        .toList();

    if (availableTables.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All tables are currently occupied')),
      );
      return;
    }

    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bir masa seçin'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return DropdownButtonFormField<int>(
              value: _occupiedTables.contains(_selectedTable)
                  ? null
                  : _selectedTable,
              items: availableTables
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          'Masa $e',
                          style: TextStyle(
                            color: _occupiedTables.contains(e)
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  Navigator.pop(context, value);
                }
              },
              decoration: const InputDecoration(
                hintText: 'Select a table',
                border: OutlineInputBorder(),
              ),
            );
          },
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedTable = result;
        _refreshBottomSheet();
      });
    }
  }

  void _confirmOrder() {
    if (_cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sepete bos bir şey eklemediniz')),
      );
      return;
    }

    if (_occupiedTables.contains(_selectedTable)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This table is already occupied')),
      );
      return;
    }

    final newOrder = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      tableNumber: _selectedTable,
      items: List.from(_cartItems),
      orderTime: DateTime.now(),
      totalPrice: _cartItems.fold(0, (sum, item) => sum + item.price),
    );

    setState(() {
      _activeOrders.add(newOrder);
      _occupiedTables.add(_selectedTable);
      _cartItems.clear();
      _selectedTable = _findAvailableTable();
    });

    Navigator.pop(_scaffoldKey.currentContext!);
  }

  void _completeOrder(int tableNumber) {
    setState(() {
      _activeOrders.removeWhere((order) => order.tableNumber == tableNumber);
      _occupiedTables.remove(tableNumber);
    });
  }

  int _findAvailableTable() {
    for (int i = 1; i <= 10; i++) {
      if (!_occupiedTables.contains(i)) return i;
    }
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Restaurant Menu',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: categories
                  .map((category) => Tab(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            category,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrdersPage(
                    orders: _activeOrders,
                    onOrderComplete: _completeOrder,
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: badges.Badge(
              position: badges.BadgePosition.topEnd(top: -5, end: -8),
              badgeContent: Text(
                _cartItems.length.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart, size: 28),
                onPressed: () {
                  if (_cartItems.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sepetiniz boş')),
                    );
                    return;
                  }
                  _scaffoldKey.currentState!.showBottomSheet(
                    (context) => OrderBottomSheet(
                      cartItems: _cartItems,
                      onRemove: _removeFromCart,
                      selectedTable: _selectedTable,
                      onSelectTable: _selectTable,
                      isTableOccupied: _occupiedTables.contains(_selectedTable),
                      onConfirmOrder: _confirmOrder,
                    ),
                  );
                },
              ),
            ),
          ),
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
