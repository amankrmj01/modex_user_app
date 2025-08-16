import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../bloc/restaurant/restaurant_list_bloc.dart';
import '../../../bloc/restaurant/restaurant_list_event.dart';
import '../../../bloc/restaurant/restaurant_list_state.dart';
import '../../../data/repositories/restaurant_repository.dart';
import '../../widgets/common/bottom_bar.dart';
import '../orders/my_orders_screen.dart';
import '../restaurant/restaurant_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RestaurantListBloc(
        restaurantRepository: RepositoryProvider.of<RestaurantRepository>(
          context,
        ),
      )..add(FetchRestaurants()),
      child: Scaffold(
        bottomNavigationBar: BottomBar(),
        backgroundColor: Colors.grey.shade50,
        appBar: _buildAppBar(context),
        body: const _HomeBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'ModEx Restaurants',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color(0xFF667eea),
      elevation: 0,
      centerTitle: true,
      actions: [
        CircleAvatar(
          backgroundColor: Colors.grey,
          child: IconButton(
            icon: const Icon(Icons.person_outlined, color: Colors.white),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const MyOrdersScreen()));
            },
          ),
        ),
      ],
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantListBloc, RestaurantListState>(
      builder: (context, state) {
        if (state is RestaurantListLoading) {
          return const _LoadingView();
        }
        if (state is RestaurantListLoaded) {
          return state.restaurants.isEmpty
              ? const _EmptyView()
              : _RestaurantList(restaurants: state.restaurants);
        }
        if (state is RestaurantListError) {
          return _ErrorView(
            message: state.message,
            onRetry: () =>
                context.read<RestaurantListBloc>().add(FetchRestaurants()),
          );
        }
        return const _InitialView();
      },
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Color(0xFF667eea)),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading delicious restaurants...',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RestaurantList extends StatelessWidget {
  final List<dynamic> restaurants;

  const _RestaurantList({required this.restaurants});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        final restaurant = restaurants[index];
        return _RestaurantCard(restaurant: restaurant);
      },
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  final dynamic restaurant;

  const _RestaurantCard({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.08 * 255).toInt()),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => RestaurantDetailsScreen(restaurant: restaurant),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _RestaurantImage(imageUrl: restaurant.imageUrl),
              const SizedBox(width: 16),
              Expanded(child: _RestaurantInfo(restaurant: restaurant)),
              _ArrowIcon(),
            ],
          ),
        ),
      ),
    );
  }
}

class _RestaurantImage extends StatelessWidget {
  final String imageUrl;

  const _RestaurantImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrl,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _ImagePlaceholder(),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return _ImageLoadingIndicator(loadingProgress: loadingProgress);
          },
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.restaurant, color: Colors.white, size: 32),
    );
  }
}

class _ImageLoadingIndicator extends StatelessWidget {
  final ImageChunkEvent loadingProgress;

  const _ImageLoadingIndicator({required this.loadingProgress});

  @override
  Widget build(BuildContext context) {
    final value = loadingProgress.expectedTotalBytes != null
        ? loadingProgress.cumulativeBytesLoaded /
              loadingProgress.expectedTotalBytes!
        : null;
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: CircularProgressIndicator(
          value: value,
          valueColor: const AlwaysStoppedAnimation(Color(0xFF667eea)),
          strokeWidth: 2,
        ),
      ),
    );
  }
}

class _RestaurantInfo extends StatelessWidget {
  final dynamic restaurant;

  const _RestaurantInfo({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          restaurant.name,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF667eea).withAlpha((0.1 * 255).toInt()),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            restaurant.cuisine,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF667eea),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.star, size: 16, color: Colors.amber.shade600),
            const SizedBox(width: 4),
            Text(
              '4.5',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 16),
            Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            Text(
              '25-35 min',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ArrowIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF667eea).withAlpha((0.1 * 255).toInt()),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Color(0xFF667eea),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
          const SizedBox(height: 16),
          Text(
            'Oops! Something went wrong',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Failed to load restaurants: $message',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF667eea),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Try Again',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _InitialView extends StatelessWidget {
  const _InitialView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Welcome to ModEx!',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Loading delicious restaurants...',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("No restaurants found!"));
  }
}
