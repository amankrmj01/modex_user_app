import 'package:equatable/equatable.dart';
import '../../data/models/menu_item_model.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class AddItemToCart extends CartEvent {
  final MenuItemModel menuItem;

  const AddItemToCart(this.menuItem);

  @override
  List<Object> get props => [menuItem];
}

class RemoveItemFromCart extends CartEvent {
  final MenuItemModel menuItem;

  const RemoveItemFromCart(this.menuItem);

  @override
  List<Object> get props => [menuItem];
}

class ClearCart extends CartEvent {}
