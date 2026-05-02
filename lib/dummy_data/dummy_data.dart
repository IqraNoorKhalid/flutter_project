// lib/dummy_data/dummy_data.dart
import '../models/shopping_list.dart';
import '../models/shopping_item.dart';
import '../models/product.dart';
import '../models/price_point.dart';
import '../models/store_price.dart';
import '../models/store_offer.dart';
import '../models/app_notification.dart';

class DummyData {
  static final List<String> stores = [
    'Metro Store',
    'CarreFour',
    'Al-Fatah',
    'Imtiaz',
    'Utility Stores'
  ];

  static final List<ShoppingList> shoppingLists = [
    ShoppingList(
      id: '1',
      name: 'Weekly Groceries',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      tags: ['Essentials', 'Weekly'],
      isCompleted: false,
      items: [
        ShoppingItem(
          id: 'i1',
          name: 'Milk 1L',
          quantity: 2,
          unit: 'L',
          isChecked: false,
          lowestPrice: 150,
          bestStore: 'Metro Store',
        ),
        ShoppingItem(
          id: 'i2',
          name: 'Eggs (12pcs)',
          quantity: 1,
          unit: 'dozen',
          isChecked: true,
          lowestPrice: 180,
          bestStore: 'CarreFour',
        ),
        ShoppingItem(
          id: 'i3',
          name: 'Bread',
          quantity: 1,
          unit: 'pcs',
          isChecked: false,
          lowestPrice: 120,
          bestStore: 'Al-Fatah',
        ),
        ShoppingItem(
          id: 'i4',
          name: 'Basmati Rice 5kg',
          quantity: 1,
          unit: 'bag',
          isChecked: false,
          lowestPrice: 850,
          bestStore: 'Imtiaz',
        ),
        ShoppingItem(
          id: 'i5',
          name: 'Cooking Oil 5L',
          quantity: 1,
          unit: 'bottle',
          isChecked: false,
          lowestPrice: 1200,
          bestStore: 'Utility Stores',
        ),
        ShoppingItem(
          id: 'i6',
          name: 'Sugar 1kg',
          quantity: 2,
          unit: 'kg',
          isChecked: false,
          lowestPrice: 110,
          bestStore: 'Metro Store',
        ),
      ],
    ),
    ShoppingList(
      id: '2',
      name: 'Party Supplies',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      tags: ['Party', 'Entertainment'],
      isCompleted: false,
      items: [
        ShoppingItem(
          id: 'i7',
          name: 'Chips',
          quantity: 5,
          unit: 'pcs',
          isChecked: false,
          lowestPrice: 50,
          bestStore: 'CarreFour',
        ),
        ShoppingItem(
          id: 'i8',
          name: 'Cold Drinks',
          quantity: 12,
          unit: 'cans',
          isChecked: true,
          lowestPrice: 840,
          bestStore: 'Metro Store',
        ),
        ShoppingItem(
          id: 'i9',
          name: 'Paper Plates',
          quantity: 50,
          unit: 'pcs',
          isChecked: false,
          lowestPrice: 200,
          bestStore: 'Al-Fatah',
        ),
        ShoppingItem(
          id: 'i10',
          name: 'Cupcakes',
          quantity: 24,
          unit: 'pcs',
          isChecked: false,
          lowestPrice: 600,
          bestStore: 'Imtiaz',
        ),
        ShoppingItem(
          id: 'i11',
          name: 'Ice Cream',
          quantity: 2,
          unit: 'liters',
          isChecked: false,
          lowestPrice: 700,
          bestStore: 'CarreFour',
        ),
      ],
    ),
    ShoppingList(
      id: '3',
      name: 'Office Snacks',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      tags: ['Office', 'Snacks'],
      isCompleted: false,
      items: [
        ShoppingItem(
          id: 'i12',
          name: 'Coffee',
          quantity: 1,
          unit: 'jar',
          isChecked: false,
          lowestPrice: 450,
          bestStore: 'Metro Store',
        ),
        ShoppingItem(
          id: 'i13',
          name: 'Biscuits',
          quantity: 3,
          unit: 'packs',
          isChecked: false,
          lowestPrice: 90,
          bestStore: 'CarreFour',
        ),
        ShoppingItem(
          id: 'i14',
          name: 'Tea 200g',
          quantity: 1,
          unit: 'pack',
          isChecked: true,
          lowestPrice: 350,
          bestStore: 'Al-Fatah',
        ),
        ShoppingItem(
          id: 'i15',
          name: 'Nuts',
          quantity: 2,
          unit: 'packs',
          isChecked: false,
          lowestPrice: 300,
          bestStore: 'Utility Stores',
        ),
      ],
    ),
    ShoppingList(
      id: '4',
      name: 'Ramadan Essentials',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      tags: ['Ramadan', 'Essentials'],
      isCompleted: true,
      items: [
        ShoppingItem(
          id: 'i16',
          name: 'Dates',
          quantity: 2,
          unit: 'kg',
          isChecked: true,
          lowestPrice: 600,
          bestStore: 'Al-Fatah',
        ),
        ShoppingItem(
          id: 'i17',
          name: 'Rooh Afza',
          quantity: 1,
          unit: 'bottle',
          isChecked: true,
          lowestPrice: 280,
          bestStore: 'Metro Store',
        ),
        ShoppingItem(
          id: 'i18',
          name: 'Flour 10kg',
          quantity: 1,
          unit: 'bag',
          isChecked: true,
          lowestPrice: 800,
          bestStore: 'Utility Stores',
        ),
        ShoppingItem(
          id: 'i19',
          name: 'Lentils',
          quantity: 3,
          unit: 'kg',
          isChecked: true,
          lowestPrice: 450,
          bestStore: 'Imtiaz',
        ),
        ShoppingItem(
          id: 'i20',
          name: 'Samosa Sheets',
          quantity: 2,
          unit: 'packs',
          isChecked: true,
          lowestPrice: 150,
          bestStore: 'CarreFour',
        ),
        ShoppingItem(
          id: 'i21',
          name: 'Chicken 1kg',
          quantity: 2,
          unit: 'kg',
          isChecked: true,
          lowestPrice: 350,
          bestStore: 'Metro Store',
        ),
      ],
    ),
  ];

  static final List<Product> products = [
    Product(
      id: 'p1',
      name: 'Milk 1L',
      category: 'Dairy',
      imageUrl: 'assets/images/milk.png',
      photoUrl:
          'https://images.unsplash.com/photo-1550583724-b2692b85fd20?auto=format&fit=crop&w=800&q=80',
      isTracked: true,
      priceHistory: [
        PricePoint(date: DateTime.now().subtract(const Duration(days: 180)), price: 130),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 150)), price: 135),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 120)), price: 140),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 90)), price: 138),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 60)), price: 145),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 30)), price: 148),
        PricePoint(date: DateTime.now(), price: 150),
      ],
      storePrices: [
        StorePrice(storeName: 'Metro Store', price: 150, lastUpdated: DateTime.now()),
        StorePrice(storeName: 'CarreFour', price: 155, lastUpdated: DateTime.now()),
        StorePrice(storeName: 'Al-Fatah', price: 148, lastUpdated: DateTime.now()),
        StorePrice(storeName: 'Imtiaz', price: 152, lastUpdated: DateTime.now()),
      ],
    ),
    Product(
      id: 'p2',
      name: 'Eggs (12pcs)',
      category: 'Dairy',
      imageUrl: 'assets/images/eggs.png',
      photoUrl:
          'https://images.unsplash.com/photo-1491524062910-be4daf67acde?auto=format&fit=crop&w=800&q=80',
      isTracked: true,
      priceHistory: [
        PricePoint(date: DateTime.now().subtract(const Duration(days: 180)), price: 160),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 150)), price: 165),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 120)), price: 170),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 90)), price: 175),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 60)), price: 178),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 30)), price: 180),
        PricePoint(date: DateTime.now(), price: 180),
      ],
      storePrices: [
        StorePrice(storeName: 'Metro Store', price: 180, lastUpdated: DateTime.now()),
        StorePrice(storeName: 'CarreFour', price: 175, lastUpdated: DateTime.now()),
        StorePrice(storeName: 'Al-Fatah', price: 182, lastUpdated: DateTime.now()),
      ],
    ),
    Product(
      id: 'p3',
      name: 'Bread',
      category: 'Bakery',
      imageUrl: 'assets/images/bread.png',
      photoUrl:
          'https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=800&q=80',
      isTracked: false,
      priceHistory: [
        PricePoint(date: DateTime.now().subtract(const Duration(days: 180)), price: 100),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 150)), price: 105),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 120)), price: 108),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 90)), price: 110),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 60)), price: 115),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 30)), price: 118),
        PricePoint(date: DateTime.now(), price: 120),
      ],
      storePrices: [
        StorePrice(storeName: 'Metro Store', price: 120, lastUpdated: DateTime.now()),
        StorePrice(storeName: 'CarreFour', price: 118, lastUpdated: DateTime.now()),
        StorePrice(storeName: 'Al-Fatah', price: 115, lastUpdated: DateTime.now()),
        StorePrice(storeName: 'Imtiaz', price: 122, lastUpdated: DateTime.now()),
      ],
    ),
    Product(
      id: 'p4',
      name: 'Basmati Rice 5kg',
      category: 'Grains',
      imageUrl: 'assets/images/rice.png',
      photoUrl:
          'https://images.unsplash.com/photo-1586201375761-83865001e31c?auto=format&fit=crop&w=800&q=80',
      isTracked: true,
      priceHistory: [
        PricePoint(date: DateTime.now().subtract(const Duration(days: 180)), price: 750),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 150)), price: 770),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 120)), price: 790),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 90)), price: 810),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 60)), price: 830),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 30)), price: 840),
        PricePoint(date: DateTime.now(), price: 850),
      ],
      storePrices: [
        StorePrice(storeName: 'Metro Store', price: 850, lastUpdated: DateTime.now()),
        StorePrice(storeName: 'CarreFour', price: 860, lastUpdated: DateTime.now()),
        StorePrice(storeName: 'Imtiaz', price: 840, lastUpdated: DateTime.now()),
        StorePrice(storeName: 'Utility Stores', price: 830, lastUpdated: DateTime.now()),
      ],
    ),
    Product(
      id: 'p5',
      name: 'Cooking Oil 5L',
      category: 'Essentials',
      imageUrl: 'assets/images/oil.png',
      photoUrl:
          'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?auto=format&fit=crop&w=800&q=80',
      isTracked: false,
      priceHistory: [
        PricePoint(date: DateTime.now().subtract(const Duration(days: 180)), price: 1050),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 150)), price: 1080),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 120)), price: 1110),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 90)), price: 1140),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 60)), price: 1170),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 30)), price: 1185),
        PricePoint(date: DateTime.now(), price: 1200),
      ],
      storePrices: [
        StorePrice(storeName: 'Metro Store', price: 1200, lastUpdated: DateTime.now()),
        StorePrice(storeName: 'CarreFour', price: 1190, lastUpdated: DateTime.now()),
        StorePrice(storeName: 'Utility Stores', price: 1150, lastUpdated: DateTime.now()),
      ],
    ),
    Product(
      id: 'p6',
      name: 'Sugar 1kg',
      category: 'Essentials',
      imageUrl: 'assets/images/sugar.png',
      photoUrl:
          'https://images.unsplash.com/photo-1614088429969-436d80d0fb5b?auto=format&fit=crop&w=800&q=80',
      isTracked: false,
      priceHistory: [
        PricePoint(date: DateTime.now().subtract(const Duration(days: 180)), price: 95),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 150)), price: 98),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 120)), price: 100),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 90)), price: 105),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 60)), price: 108),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 30)), price: 110),
        PricePoint(date: DateTime.now(), price: 110),
      ],
      storePrices: [
        StorePrice(storeName: 'Metro Store', price: 110, lastUpdated: DateTime.now()),
        StorePrice(storeName: 'Al-Fatah', price: 108, lastUpdated: DateTime.now()),
        StorePrice(storeName: 'Utility Stores', price: 105, lastUpdated: DateTime.now()),
      ],
    ),
    Product(
      id: 'p7',
      name: 'Tea 200g',
      category: 'Beverages',
      imageUrl: 'assets/images/tea.png',
      photoUrl:
          'https://images.unsplash.com/photo-1564890369479-c89f505726d9?auto=format&fit=crop&w=800&q=80',
      isTracked: true,
      priceHistory: [
        PricePoint(date: DateTime.now().subtract(const Duration(days: 180)), price: 320),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 150)), price: 330),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 120)), price: 335),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 90)), price: 340),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 60)), price: 345),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 30)), price: 348),
        PricePoint(date: DateTime.now(), price: 350),
      ],
      storePrices: [
        StorePrice(storeName: 'Metro Store', price: 350, lastUpdated: DateTime.now()),
        StorePrice(storeName: 'CarreFour', price: 345, lastUpdated: DateTime.now()),
        StorePrice(storeName: 'Al-Fatah', price: 340, lastUpdated: DateTime.now()),
      ],
    ),
    Product(
      id: 'p8',
      name: 'Chicken 1kg',
      category: 'Meat',
      imageUrl: 'assets/images/chicken.png',
      photoUrl:
          'https://images.unsplash.com/photo-1604503468506-a8da13d82791?auto=format&fit=crop&w=800&q=80',
      isTracked: false,
      priceHistory: [
        PricePoint(date: DateTime.now().subtract(const Duration(days: 180)), price: 320),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 150)), price: 325),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 120)), price: 330),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 90)), price: 340),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 60)), price: 345),
        PricePoint(date: DateTime.now().subtract(const Duration(days: 30)), price: 348),
        PricePoint(date: DateTime.now(), price: 350),
      ],
      storePrices: [
        StorePrice(storeName: 'Metro Store', price: 350, lastUpdated: DateTime.now()),
        StorePrice(storeName: 'CarreFour', price: 345, lastUpdated: DateTime.now()),
        StorePrice(storeName: 'Al-Fatah', price: 340, lastUpdated: DateTime.now()),
        StorePrice(storeName: 'Imtiaz', price: 348, lastUpdated: DateTime.now()),
      ],
    ),
  ];

  static final List<StoreOffer> deals = [
    StoreOffer(
      id: 'd1',
      storeName: 'Metro Store',
      productName: 'Milk 1L',
      originalPrice: 150,
      salePrice: 120,
      category: 'Dairy',
      expiresAt: DateTime.now().add(const Duration(days: 3)),
      discountPercentage: 20,
    ),
    StoreOffer(
      id: 'd2',
      storeName: 'CarreFour',
      productName: 'Bread',
      originalPrice: 120,
      salePrice: 90,
      category: 'Bakery',
      expiresAt: DateTime.now().add(const Duration(days: 2)),
      discountPercentage: 25,
    ),
    StoreOffer(
      id: 'd3',
      storeName: 'Al-Fatah',
      productName: 'Tea 200g',
      originalPrice: 350,
      salePrice: 280,
      category: 'Beverages',
      expiresAt: DateTime.now().add(const Duration(days: 5)),
      discountPercentage: 20,
    ),
    StoreOffer(
      id: 'd4',
      storeName: 'Imtiaz',
      productName: 'Chicken 1kg',
      originalPrice: 350,
      salePrice: 280,
      category: 'Meat',
      expiresAt: DateTime.now().add(const Duration(days: 1)),
      discountPercentage: 20,
    ),
    StoreOffer(
      id: 'd5',
      storeName: 'Utility Stores',
      productName: 'Basmati Rice 5kg',
      originalPrice: 850,
      salePrice: 720,
      category: 'Grains',
      expiresAt: DateTime.now().add(const Duration(days: 7)),
      discountPercentage: 15,
    ),
    StoreOffer(
      id: 'd6',
      storeName: 'Metro Store',
      productName: 'Cooking Oil 5L',
      originalPrice: 1200,
      salePrice: 1080,
      category: 'Essentials',
      expiresAt: DateTime.now().add(const Duration(days: 4)),
      discountPercentage: 10,
    ),
  ];

  static final List<AppNotification> notifications = [
    AppNotification(
      id: 'n1',
      title: 'Price Drop!',
      body: 'Milk 1L price dropped to Rs. 150 at Metro Store',
      type: 'price_drop',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    AppNotification(
      id: 'n2',
      title: 'Limited Time Deal',
      body: '25% off on Bread at CarreFour',
      type: 'deal',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: false,
    ),
    AppNotification(
      id: 'n3',
      title: 'Reminder',
      body: 'Your Weekly Groceries list has 3 items pending',
      type: 'reminder',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    AppNotification(
      id: 'n4',
      title: 'Price Alert',
      body: 'Chicken 1kg is now at lowest price in 3 months',
      type: 'price_drop',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
    AppNotification(
      id: 'n5',
      title: 'Special Offer',
      body: 'Buy 2 Get 1 Free on selected items at Imtiaz',
      type: 'deal',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
    ),
  ];

  /// Deep copy so app state never mutates canonical seed lists.
  static List<ShoppingList> cloneShoppingLists() {
    return shoppingLists
        .map(
          (l) => ShoppingList(
            id: l.id,
            name: l.name,
            createdAt: l.createdAt,
            tags: List<String>.from(l.tags),
            isCompleted: l.isCompleted,
            items: l.items
                .map(
                  (i) => ShoppingItem(
                    id: i.id,
                    name: i.name,
                    quantity: i.quantity,
                    unit: i.unit,
                    isChecked: i.isChecked,
                    lowestPrice: i.lowestPrice,
                    bestStore: i.bestStore,
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }

  static List<Product> cloneProducts() {
    return products
        .map(
          (p) => Product(
            id: p.id,
            name: p.name,
            category: p.category,
            imageUrl: p.imageUrl,
            photoUrl: p.photoUrl,
            isTracked: p.isTracked,
            priceHistory: List<PricePoint>.from(p.priceHistory),
            storePrices: List<StorePrice>.from(p.storePrices),
          ),
        )
        .toList();
  }
}