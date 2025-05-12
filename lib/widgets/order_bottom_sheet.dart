import 'package:flutter/material.dart';
import '../models/menu_item.dart';

class OrderBottomSheet extends StatelessWidget {
  final List<MenuItem> cartItems;
  final Function(int) onRemove;
  final int selectedTable;
  final Future<void> Function() onSelectTable;
  final bool isTableOccupied;
  final VoidCallback onConfirmOrder;

  const OrderBottomSheet({
    super.key,
    required this.cartItems,
    required this.onRemove,
    required this.selectedTable,
    required this.onSelectTable,
    required this.isTableOccupied,
    required this.onConfirmOrder,
  });

  double _calculateTotal() {
    return cartItems.fold(0, (sum, item) => sum + item.price);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Masa: $selectedTable',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: isTableOccupied ? Colors.red : Colors.black,
                    ),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: isTableOccupied ? null : onSelectTable,
              ),
            ],
          ),
          if (isTableOccupied)
            const Text(
              'This table is already occupied!',
              style: TextStyle(color: Colors.red),
            ),
          const Divider(),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Dismissible(
                  key: Key(item.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) => onRemove(index),
                  child: ListTile(
                    title: Text(item.name),
                    subtitle: Text('\TL${item.price.toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle),
                      onPressed: () => onRemove(index),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Toplam:', style: Theme.of(context).textTheme.titleLarge),
                Text('\TL${_calculateTotal().toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: isTableOccupied ? Colors.grey : Colors.orange,
              ),
              onPressed: isTableOccupied ? null : onConfirmOrder,
              child: const Text(
                'Sepete Onayla',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
