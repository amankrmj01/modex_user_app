import 'package:equatable/equatable.dart';
import '../../data/models/cart_model.dart';

class CartState extends Equatable {
  final CartModel cart;

  const CartState({this.cart = const CartModel()});

  @override
  List<Object> get props => [cart];
}
