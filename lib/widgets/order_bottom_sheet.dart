import 'package:flutter/material.dart';
import '../models/menu_item.dart';

class OrderBottomSheet extends StatelessWidget {
  final List<MenuItem> cartItems;
  final Function(int) onRemove;
  final int selectedTable;
  final Function() onSelectTable;

  const OrderBottomSheet({
    super.key,
    required this.cartItems,
    required this.onRemove,
    required this.selectedTable,
    required this.onSelectTable,
  });

  double _calculateTotal() {
    return cartItems.fold(0, (sum, item) => sum + item.price);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Masa: $selectedTable', style: Theme.of(context).textTheme.titleLarge),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: onSelectTable,
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  title: Text(item.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: () => onRemove(index),
                  ),
                  subtitle: Text('₺${item.price.toStringAsFixed(2)}'),
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Toplam:', style: Theme.of(context).textTheme.titleLarge),
                Text('₺${_calculateTotal().toStringAsFixed(2)}', 
                     style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Siparişi Onayla'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }
}