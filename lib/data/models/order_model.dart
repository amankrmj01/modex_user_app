import 'package:equatable/equatable.dart';
import 'cart_model.dart';

class OrderModel extends Equatable {
  final String id;
  final List<CartItemModel> items;
  final double totalPrice;
  final String status;
  final DateTime date;

  const OrderModel({
    required this.id,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.date,
  });

  @override
  List<Object?> get props => [id, items, totalPrice, status, date];
}
