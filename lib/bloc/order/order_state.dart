import 'package:equatable/equatable.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class OrderPlacementInProgress extends OrderState {}

class OrderPlacementSuccess extends OrderState {}

class OrderPlacementFailure extends OrderState {
  final String error;

  const OrderPlacementFailure(this.error);

  @override
  List<Object> get props => [error];
}
