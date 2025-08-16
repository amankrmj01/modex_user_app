import '../models/cart_model.dart';
import '../models/order_model.dart';

class OrderRepository {
  final List<OrderModel> _orders = [];

  Future<OrderModel> placeOrder(CartModel cart) async {
    await Future.delayed(const Duration(seconds: 2));

    final newOrder = OrderModel(
      id: 'ord_${DateTime.now().millisecondsSinceEpoch}',
      items: cart.items,
      totalPrice: cart.totalPrice,
      status: 'Pending',
      date: DateTime.now(),
    );
    _orders.add(newOrder);
    return newOrder;
  }

  Future<List<OrderModel>> fetchOrderHistory() async {
    await Future.delayed(const Duration(seconds: 1));
    return List.from(_orders.reversed);
  }
}
