import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modex_user_app/presentation/widgets/common/bottom_bar.dart';

import '../../../bloc/cart/cart_bloc.dart';
import '../../../bloc/cart/cart_event.dart';
import '../../../bloc/menu/menu_bloc.dart';
import '../../../bloc/menu/menu_event.dart';
import '../../../bloc/menu/menu_state.dart';
import '../../../data/models/cart_model.dart';
import '../../../data/models/restaurant_model.dart';
import '../../../data/repositories/restaurant_repository.dart';

class RestaurantDetailsScreen extends StatelessWidget {
  final RestaurantModel restaurant;

  const RestaurantDetailsScreen({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MenuBloc(
        restaurantRepository: RepositoryProvider.of<RestaurantRepository>(
          context,
        ),
      )..add(FetchMenu(restaurantId: restaurant.id)),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        bottomNavigationBar: BottomBar(),
        body: CustomScrollView(
          slivers: [
            _buildAppBar(),
            _buildRestaurantInfo(),
            _buildMenuHeader(),
            _buildMenuList(),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: const Color(0xFF667eea),
      flexibleSpace: FlexibleSpaceBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              restaurant.name,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: const Offset(0, 1),
                    blurRadius: 3,
                    color: Colors.black.withAlpha((0.5 * 255).toInt()),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              restaurant.address,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              restaurant.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _buildImagePlaceholder(),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withAlpha((0.7 * 255).toInt()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
      ),
      child: const Center(
        child: Icon(Icons.restaurant, size: 80, color: Colors.white),
      ),
    );
  }

  Widget _buildRestaurantInfo() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCuisineAndRating(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _InfoItem(
                  icon: Icons.access_time,
                  value: '25-35 min',
                  label: 'Delivery',
                ),
                const SizedBox(width: 24),
                _InfoItem(
                  icon: Icons.delivery_dining,
                  value: 'Free',
                  label: 'Delivery Fee',
                ),
                const SizedBox(width: 24),
                _InfoItem(
                  icon: Icons.location_on,
                  value: '2.1 km',
                  label: 'Distance',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCuisineAndRating() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF667eea).withAlpha((0.1 * 255).toInt()),
            borderRadius: BorderRadius.circular(20),
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
        const Spacer(),
        Row(
          children: [
            Icon(Icons.star, size: 20, color: Colors.amber.shade600),
            const SizedBox(width: 4),
            Text(
              restaurant.rating,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            Text(
              ' (120+ reviews)',
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

  Widget _buildMenuHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Text(
          'Menu',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade800,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuList() {
    return BlocBuilder<MenuBloc, MenuState>(
      builder: (context, state) {
        if (state is MenuLoading) {
          return const SliverToBoxAdapter(child: _MenuLoadingView());
        }
        if (state is MenuLoaded) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _MenuItemCard(item: state.menuItems[index]),
              childCount: state.menuItems.length,
            ),
          );
        }
        if (state is MenuError) {
          return SliverToBoxAdapter(
            child: _MenuErrorView(
              message: state.message,
              onRetry: () {
                context.read<MenuBloc>().add(
                  FetchMenu(restaurantId: restaurant.id),
                );
              },
            ),
          );
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _InfoItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF667eea)),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

class _MenuLoadingView extends StatelessWidget {
  const _MenuLoadingView();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Color(0xFF667eea)),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading menu...',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _MenuErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(16),
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
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
            const SizedBox(height: 16),
            Text(
              'Failed to load menu',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF667eea),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Retry',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final dynamic item;

  const _MenuItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.06 * 255).toInt()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildImage(),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetails(),
                  const SizedBox(height: 12),
                  _buildAddToCartButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.fastfood, color: Colors.white, size: 32),
    );
  }

  Widget _buildDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              item.name,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            const Spacer(),
            Text(
              '\$${item.price.toStringAsFixed(2)}',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF667eea),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          item.description,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade600),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildAddToCartButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withAlpha((0.3 * 255).toInt()),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              context.read<CartBloc>().add(RemoveItemFromCart(item));

              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.info, color: Colors.white),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${item.name} removed from cart!',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.orange.shade600,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(16),
                  ),
                );
            },
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Icon(Icons.remove, color: Colors.white, size: 20),
            ),
          ),
          Container(
            color: Colors.white,
            width: 50,
            height: 40,
            alignment: Alignment.center,
            child: Builder(
              builder: (context) {
                final cartState = context.watch<CartBloc>().state;
                final cartItem = cartState.cart.items.firstWhere(
                  (ci) => ci.menuItem.id == item.id,
                  orElse: () => CartItemModel(menuItem: item, quantity: 0),
                );
                final quantity = cartItem.quantity;
                return Text(
                  quantity.toString(),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                );
              },
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              context.read<CartBloc>().add(AddItemToCart(item));

              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.white),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${item.name} added to cart!',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.green.shade600,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(16),
                  ),
                );
            },
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Icon(Icons.add, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
