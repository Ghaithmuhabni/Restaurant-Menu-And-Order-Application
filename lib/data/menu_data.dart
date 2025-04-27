import 'package:flutter_application_1/models/menu_item.dart';

// data/menu_data.dart İÇİNDE BU TANIM OLMALI:
final List<String> categories = [
  // BU SATIR
  'Ana Yemekler',
  'Başlangıçlar',
  'İçecekler',
  'Tatlılar',
];

final List<MenuItem> menuItems = [
  MenuItem(
    id: '1',
    name: 'Köfte',
    price: 85.0,
    category: 'Ana Yemekler',
    image: 'images/1.jpg',
  ),
  MenuItem(
    id: '2',
    name: 'Salmon Salad',
    price: 45.0,
    category: 'Başlangıçlar',
    image: 'images/2.jpg',
  ),
  MenuItem(
    id: '3',
    name: 'Kahve',
    price: 15.0,
    category: 'İçecekler',
    image: 'images/3.jpg',
  ),
  MenuItem(
    id: '4',
    name: 'Baklava',
    price: 35.0,
    category: 'Tatlılar',
    image: 'images/4.jpg',
  ),
];
