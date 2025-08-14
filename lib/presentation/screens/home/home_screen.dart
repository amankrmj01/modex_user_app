import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/restaurant/restaurant_list_bloc.dart';
import '../../../bloc/restaurant/restaurant_list_event.dart';
import '../../../bloc/restaurant/restaurant_list_state.dart';
import '../../../data/repositories/restaurant_repository.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Create and provide the BLoC to this screen's widget subtree.
      // Also, immediately add the event to fetch data.
      create: (context) => RestaurantListBloc(
        restaurantRepository: RepositoryProvider.of<RestaurantRepository>(
          context,
        ),
      )..add(FetchRestaurants()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Restaurants')),
        body: BlocBuilder<RestaurantListBloc, RestaurantListState>(
          builder: (context, state) {
            if (state is RestaurantListLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is RestaurantListLoaded) {
              return ListView.builder(
                itemCount: state.restaurants.length,
                itemBuilder: (context, index) {
                  final restaurant = state.restaurants[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Image.network(
                        restaurant.imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                      title: Text(restaurant.name),
                      subtitle: Text(restaurant.cuisine),
                      onTap: () {
                        // TODO: Navigate to Restaurant Details Screen
                      },
                    ),
                  );
                },
              );
            }
            if (state is RestaurantListError) {
              return Center(
                child: Text('Failed to load restaurants: ${state.message}'),
              );
            }
            // Initial state
            return const Center(child: Text('Welcome! Loading restaurants...'));
          },
        ),
      ),
    );
  }
}
