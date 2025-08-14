import 'package:equatable/equatable.dart';

abstract class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object> get props => [];
}

class FetchMenu extends MenuEvent {
  final String restaurantId;

  const FetchMenu({required this.restaurantId});

  @override
  List<Object> get props => [restaurantId];
}
