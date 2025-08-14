import '../models/restaurant_model.dart';

class RestaurantRepository {
  Future<List<RestaurantModel>> fetchRestaurants() async {
    await Future.delayed(const Duration(seconds: 1));
    // mock data
    return [
      const RestaurantModel(
        id: 'r1',
        name: 'The Golden Spoon',
        imageUrl: 'https://via.placeholder.com/150',
        cuisine: 'Italian',
      ),
      const RestaurantModel(
        id: 'r2',
        name: 'Spice Village',
        imageUrl: 'https://via.placeholder.com/150',
        cuisine: 'Indian',
      ),
      const RestaurantModel(
        id: 'r3',
        name: 'Sushi Central',
        imageUrl: 'https://via.placeholder.com/150',
        cuisine: 'Japanese',
      ),
      const RestaurantModel(
        id: 'r4',
        name: 'Burger Queen',
        imageUrl: 'https://via.placeholder.com/150',
        cuisine: 'American',
      ),
    ];
  }
}
