import 'package:flutter/material.dart';
import '../models/menu_item.dart';

class MenuGrid extends StatelessWidget {
  final List<MenuItem> items;
  final Function(MenuItem) onAddToCart;

  const MenuGrid({super.key, required this.items, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          child: Column(
            children: [
              Expanded(
                child: Image.asset(
                  item.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.fastfood, size: 50), // Fallback widget
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(item.name,
                        style: Theme.of(context).textTheme.titleMedium),
                    Text('₺${item.price.toStringAsFixed(2)}'),
                    ElevatedButton(
                      onPressed: () => onAddToCart(item),
                      child: const Text('Sepete Ekle'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
