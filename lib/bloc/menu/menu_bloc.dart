import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/restaurant_repository.dart';
import 'menu_event.dart';
import 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final RestaurantRepository restaurantRepository;

  MenuBloc({required this.restaurantRepository}) : super(MenuInitial()) {
    on<FetchMenu>(_onFetchMenu);
  }

  void _onFetchMenu(FetchMenu event, Emitter<MenuState> emit) async {
    emit(MenuLoading());
    try {
      final menuItems = await restaurantRepository.fetchMenuForRestaurant(
        event.restaurantId,
      );
      emit(MenuLoaded(menuItems: menuItems));
    } catch (e) {
      emit(MenuError(message: e.toString()));
    }
  }
}
