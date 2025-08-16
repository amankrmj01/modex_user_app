import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../bloc/order_history/order_history_bloc.dart';
import '../../../data/repositories/order_repository.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderHistoryBloc(
        orderRepository: RepositoryProvider.of<OrderRepository>(context),
      )..add(FetchOrderHistory()),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: Text(
            'My Orders',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color(0xFF667eea),
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const _OrdersBody(),
      ),
    );
  }
}

class _OrdersBody extends StatelessWidget {
  const _OrdersBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
      builder: (context, state) {
        if (state is OrderHistoryLoading) {
          return const _OrdersLoadingView();
        }
        if (state is OrderHistoryLoaded) {
          if (state.orders.isEmpty) return const _NoOrdersView();
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.orders.length,
            itemBuilder: (context, index) =>
                _OrderCard(order: state.orders[index]),
          );
        }
        if (state is OrderHistoryError) {
          return _OrdersErrorView(
            message: state.message,
            onRetry: () =>
                context.read<OrderHistoryBloc>().add(FetchOrderHistory()),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _OrdersLoadingView extends StatelessWidget {
  const _OrdersLoadingView();

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
            'Loading your orders...',
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

class _NoOrdersView extends StatelessWidget {
  const _NoOrdersView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF667eea).withAlpha((0.1 * 255).toInt()),
                  const Color(0xFF764ba2).withAlpha((0.1 * 255).toInt()),
                ],
              ),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.receipt_long,
              size: 60,
              color: Color(0xFF667eea),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Orders Yet',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "You haven't placed any orders yet.\nStart exploring restaurants to place your first order!",
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF667eea),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: Text(
              'Explore Restaurants',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrdersErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _OrdersErrorView({required this.message, required this.onRetry});

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
            'Error: $message',
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

class _OrderCard extends StatelessWidget {
  final dynamic order;

  const _OrderCard({required this.order});

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
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.all(20),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          leading: _buildOrderIcon(),
          title: _buildOrderTitle(),
          subtitle: _buildOrderSubtitle(),
          trailing: _buildOrderTrailing(),
          children: [_OrderDetails(order: order)],
        ),
      ),
    );
  }

  Widget _buildOrderIcon() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.receipt, color: Colors.white, size: 24),
    );
  }

  Widget _buildOrderTitle() {
    return Text(
      'Order #${order.id.substring(4, 9)}',
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade800,
      ),
    );
  }

  Widget _buildOrderSubtitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor(order.status).withAlpha((0.1 * 255).toInt()),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            order.status,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: _getStatusColor(order.status),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.restaurant_menu, size: 16, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            Text(
              '${order.items.length} items',
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

  Widget _buildOrderTrailing() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '\$${order.totalPrice.toStringAsFixed(2)}',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF667eea),
          ),
        ),
        const SizedBox(height: 4),
        Icon(Icons.expand_more, color: Colors.grey.shade400, size: 20),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'preparing':
        return Colors.orange;
      case 'on the way':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return const Color(0xFF667eea);
    }
  }
}

class _OrderDetails extends StatelessWidget {
  final dynamic order;

  const _OrderDetails({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Details',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 12),
          ...order.items.map((item) => _OrderItemTile(item: item)).toList(),
          const SizedBox(height: 8),
          _OrderTotal(total: order.totalPrice),
        ],
      ),
    );
  }
}

class _OrderItemTile extends StatelessWidget {
  final dynamic item;

  const _OrderItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.fastfood, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.menuItem.name,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade800,
                  ),
                ),
                Text(
                  '\$${item.menuItem.price.toStringAsFixed(2)} each',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF667eea).withAlpha((0.1 * 255).toInt()),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'x${item.quantity}',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF667eea),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderTotal extends StatelessWidget {
  final double total;

  const _OrderTotal({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Amount',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Text(
            '\$${total.toStringAsFixed(2)}',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
