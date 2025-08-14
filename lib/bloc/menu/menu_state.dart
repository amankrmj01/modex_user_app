import 'package:equatable/equatable.dart';
import '../../data/models/menu_item_model.dart';

abstract class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object?> get props => [];
}

class MenuInitial extends MenuState {}

class MenuLoading extends MenuState {}

class MenuLoaded extends MenuState {
  final List<MenuItemModel> menuItems;

  const MenuLoaded({required this.menuItems});

  @override
  List<Object?> get props => [menuItems];
}

class MenuError extends MenuState {
  final String message;

  const MenuError({required this.message});

  @override
  List<Object?> get props => [message];
}
