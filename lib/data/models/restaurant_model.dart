import 'package:equatable/equatable.dart';

class RestaurantModel extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final String cuisine;
  final String description;
  final String rating;
  final String address;

  const RestaurantModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.cuisine,
    required this.description,
    required this.rating,
    required this.address,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    imageUrl,
    cuisine,
    description,
    rating,
    address,
  ];
}
