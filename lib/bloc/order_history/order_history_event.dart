part of 'order_history_bloc.dart';

sealed class OrderHistoryEvent extends Equatable {
  const OrderHistoryEvent();
}

class FetchOrderHistory extends OrderHistoryEvent {
  @override
  List<Object?> get props => [];
}
