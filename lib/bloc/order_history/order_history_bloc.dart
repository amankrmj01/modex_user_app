import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/order_model.dart';
import '../../data/repositories/order_repository.dart';

part 'order_history_event.dart';

part 'order_history_state.dart';

class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  final OrderRepository orderRepository;

  OrderHistoryBloc({required this.orderRepository})
    : super(OrderHistoryInitial()) {
    on<FetchOrderHistory>((event, emit) async {
      emit(OrderHistoryLoading());
      try {
        final orders = await orderRepository.fetchOrderHistory();
        emit(OrderHistoryLoaded(orders: orders));
      } catch (e) {
        emit(OrderHistoryError(message: e.toString()));
      }
    });
  }
}
