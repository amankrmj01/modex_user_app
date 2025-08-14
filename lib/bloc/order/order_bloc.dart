import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/order_repository.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository orderRepository;

  OrderBloc({required this.orderRepository}) : super(OrderInitial()) {
    on<PlaceOrder>(_onPlaceOrder);
  }

  void _onPlaceOrder(PlaceOrder event, Emitter<OrderState> emit) async {
    emit(OrderPlacementInProgress());
    try {
      await orderRepository.placeOrder(event.cart);
      emit(OrderPlacementSuccess());
    } catch (e) {
      emit(OrderPlacementFailure(e.toString()));
    }
  }
}
