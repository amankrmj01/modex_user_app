part of 'order_history_bloc.dart';

sealed class OrderHistoryState extends Equatable {
  const OrderHistoryState();
}

final class OrderHistoryInitial extends OrderHistoryState {
  @override
  List<Object> get props => [];
}

class OrderHistoryLoading extends OrderHistoryState {
  @override
  List<Object?> get props => [];
}

class OrderHistoryLoaded extends OrderHistoryState {
  final List<OrderModel> orders;

  const OrderHistoryLoaded({required this.orders});

  @override
  List<Object?> get props => [orders];
}

class OrderHistoryError extends OrderHistoryState {
  final String message;

  const OrderHistoryError({required this.message});

  @override
  List<Object?> get props => [message];
}
