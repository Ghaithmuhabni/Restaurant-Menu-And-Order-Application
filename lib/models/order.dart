import 'package:flutter_application_1/models/menu_item.dart';

class Order {
  final String id;
  final int tableNumber;
  final List<MenuItem> items;
  final DateTime orderTime;
  final double totalPrice;

  Order({
    required this.id,
    required this.tableNumber,
    required this.items,
    required this.orderTime,
    required this.totalPrice,
  });

  String get formattedTime => '${orderTime.hour}:${orderTime.minute.toString().padLeft(2, '0')}';
}