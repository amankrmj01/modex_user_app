import 'package:equatable/equatable.dart';
import '../../data/models/cart_model.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class PlaceOrder extends OrderEvent {
  final CartModel cart;

  const PlaceOrder(this.cart);

  @override
  List<Object> get props => [cart];
}
