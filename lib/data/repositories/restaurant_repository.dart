import '../models/menu_item_model.dart';
import '../models/restaurant_model.dart';

class RestaurantRepository {
  Future<List<RestaurantModel>> fetchRestaurants() async {
    await Future.delayed(const Duration(seconds: 1));
    // mock data
    return [
      const RestaurantModel(
        id: 'r1',
        name: 'The Golden Spoon',
        imageUrl: 'https://placehold.co/150',
        cuisine: 'Italian',
      ),
      const RestaurantModel(
        id: 'r2',
        name: 'Spice Village',
        imageUrl: 'https://placehold.co/150',
        cuisine: 'Indian',
      ),
      const RestaurantModel(
        id: 'r3',
        name: 'Sushi Central',
        imageUrl: 'https://placehold.co/150',
        cuisine: 'Japanese',
      ),
      const RestaurantModel(
        id: 'r4',
        name: 'Burger Queen',
        imageUrl: 'https://placehold.co/150',
        cuisine: 'American',
      ),
    ];
  }

  Future<List<MenuItemModel>> fetchMenuForRestaurant(
    String restaurantId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (restaurantId == 'r1') {
      return const [
        MenuItemModel(
          id: 'm1',
          name: 'Margherita Pizza',
          description: 'Classic cheese and tomato',
          price: 12.99,
        ),
        MenuItemModel(
          id: 'm2',
          name: 'Pasta Carbonara',
          description: 'Creamy pasta with bacon',
          price: 14.50,
        ),
      ];
    } else if (restaurantId == 'r2') {
      return const [
        MenuItemModel(
          id: 'm3',
          name: 'Butter Chicken',
          description: 'Rich and creamy chicken curry',
          price: 15.00,
        ),
        MenuItemModel(
          id: 'm4',
          name: 'Garlic Naan',
          description: 'Soft bread with garlic',
          price: 4.00,
        ),
      ];
    } else {
      // Default menu for other restaurants
      return const [
        MenuItemModel(
          id: 'm5',
          name: 'House Special',
          description: 'Chef\'s recommendation',
          price: 18.00,
        ),
      ];
    }
  }
}
