import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/restaurant_repository.dart';
import 'restaurant_list_event.dart';
import 'restaurant_list_state.dart';

class RestaurantListBloc
    extends Bloc<RestaurantListEvent, RestaurantListState> {
  final RestaurantRepository restaurantRepository;

  RestaurantListBloc({required this.restaurantRepository})
    : super(RestaurantListInitial()) {
    on<FetchRestaurants>(_onFetchRestaurants);
  }

  void _onFetchRestaurants(
    FetchRestaurants event,
    Emitter<RestaurantListState> emit,
  ) async {
    emit(RestaurantListLoading());
    try {
      final restaurants = await restaurantRepository.fetchRestaurants();
      emit(RestaurantListLoaded(restaurants: restaurants));
    } catch (e) {
      emit(RestaurantListError(message: e.toString()));
    }
  }
}
