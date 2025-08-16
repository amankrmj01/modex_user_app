import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/cart_model.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddItemToCart>(_onAddItemToCart);
    on<RemoveItemFromCart>(_onRemoveItemFromCart);
    on<ClearCart>((event, emit) {
      emit(const CartState(cart: CartModel()));
    });
  }

  void _onAddItemToCart(AddItemToCart event, Emitter<CartState> emit) {
    final currentState = state.cart;
    List<CartItemModel> updatedItems = List.from(currentState.items);

    int index = updatedItems.indexWhere(
      (item) => item.menuItem.id == event.menuItem.id,
    );

    if (index != -1) {
      CartItemModel existingItem = updatedItems[index];
      updatedItems[index] = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );
    } else {
      updatedItems.add(CartItemModel(menuItem: event.menuItem, quantity: 1));
    }

    double totalPrice = _calculateTotalPrice(updatedItems);

    emit(
      CartState(
        cart: CartModel(items: updatedItems, totalPrice: totalPrice),
      ),
    );
  }

  void _onRemoveItemFromCart(
    RemoveItemFromCart event,
    Emitter<CartState> emit,
  ) {
    final currentState = state.cart;
    List<CartItemModel> updatedItems = List.from(currentState.items);

    int index = updatedItems.indexWhere(
      (item) => item.menuItem.id == event.menuItem.id,
    );

    if (updatedItems[index].quantity > 1) {
      CartItemModel existingItem = updatedItems[index];
      updatedItems[index] = existingItem.copyWith(
        quantity: existingItem.quantity - 1,
      );
    } else {
      updatedItems.removeAt(index);
    }

    double totalPrice = _calculateTotalPrice(updatedItems);

    emit(
      CartState(
        cart: CartModel(items: updatedItems, totalPrice: totalPrice),
      ),
    );
  }

  double _calculateTotalPrice(List<CartItemModel> items) {
    return items.fold(
      0.0,
      (sum, item) => sum + (item.menuItem.price * item.quantity),
    );
  }
}
