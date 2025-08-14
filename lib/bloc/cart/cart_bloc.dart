import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/cart_model.dart';
import '../../data/models/menu_item_model.dart';
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

    // Check if item already exists
    int index = updatedItems.indexWhere(
      (item) => item.menuItem.id == event.menuItem.id,
    );

    if (index != -1) {
      // Item exists, increment quantity
      CartItemModel existingItem = updatedItems[index];
      updatedItems[index] = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );
    } else {
      // Item does not exist, add it
      updatedItems.add(CartItemModel(menuItem: event.menuItem, quantity: 1));
    }

    // Recalculate total price
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

    // Remove the item
    updatedItems.removeWhere((item) => item.menuItem.id == event.menuItem.id);

    // Recalculate total price
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
