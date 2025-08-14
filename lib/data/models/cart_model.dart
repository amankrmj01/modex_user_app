import 'package:equatable/equatable.dart';
import 'menu_item_model.dart';

// Represents a single item within the cart, including its quantity.
class CartItemModel extends Equatable {
  final MenuItemModel menuItem;
  final int quantity;

  const CartItemModel({required this.menuItem, this.quantity = 1});

  CartItemModel copyWith({int? quantity}) {
    return CartItemModel(
      menuItem: menuItem,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [menuItem, quantity];
}

// Represents the entire shopping cart.
class CartModel extends Equatable {
  final List<CartItemModel> items;
  final double totalPrice;

  const CartModel({this.items = const [], this.totalPrice = 0.0});

  @override
  List<Object?> get props => [items, totalPrice];
}
