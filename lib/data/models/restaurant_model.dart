import 'package:equatable/equatable.dart';

class RestaurantModel extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final String cuisine;

  const RestaurantModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.cuisine,
  });

  @override
  List<Object?> get props => [id, name, imageUrl, cuisine];
}
