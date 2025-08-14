import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../bloc/cart/cart_bloc.dart';
import '../../../bloc/cart/cart_event.dart';
import '../../../bloc/cart/cart_state.dart';
import '../../../bloc/order/order_bloc.dart';
import '../../../bloc/order/order_event.dart';
import '../../../bloc/order/order_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'My Cart',
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
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.cart.items.isEmpty) return const _EmptyCartView();

          return Column(
            children: [
              Expanded(child: _CartItemsList(items: state.cart.items)),
              _OrderSummary(cartState: state),
              _PlaceOrderButton(cartState: state),
            ],
          );
        },
      ),
    );
  }
}

//
// ---------- Empty Cart View ----------
class _EmptyCartView extends StatelessWidget {
  const _EmptyCartView();

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
              Icons.shopping_cart_outlined,
              size: 60,
              color: Color(0xFF667eea),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Your Cart is Empty',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Looks like you haven't added\nanything to your cart yet.",
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
              'Browse Restaurants',
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

//
// ---------- Cart Items List ----------
class _CartItemsList extends StatelessWidget {
  final List<dynamic> items; // replace with CartItem type
  const _CartItemsList({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final cartItem = items[index];
        return _CartItemCard(cartItem: cartItem);
      },
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final dynamic cartItem; // replace with CartItem type
  const _CartItemCard({required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
            _itemImage(),
            const SizedBox(width: 16),
            Expanded(child: _ItemDetails(cartItem: cartItem)),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    _ItemRemove(cartItem: cartItem),
                    const SizedBox(width: 4),
                    Text(
                      '${(cartItem.quantity).toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF667eea),
                      ),
                    ),
                    const SizedBox(width: 4),
                    _ItemAdd(cartItem: cartItem),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  '\$${(cartItem.menuItem.price * cartItem.quantity).toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF667eea),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemImage() => Container(
    width: 60,
    height: 60,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
      ),
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Icon(Icons.fastfood, color: Colors.white, size: 28),
  );
}

class _ItemDetails extends StatelessWidget {
  final dynamic cartItem;

  const _ItemDetails({required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          cartItem.menuItem.name,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '\$${cartItem.menuItem.price.toStringAsFixed(2)} each',
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              'Qty: ',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF667eea).withAlpha((0.1 * 255).toInt()),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${cartItem.quantity}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF667eea),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ItemRemove extends StatelessWidget {
  final dynamic cartItem;

  const _ItemRemove({required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(Icons.remove_outlined, color: Colors.red.shade600, size: 20),
        onPressed: () {
          context.read<CartBloc>().add(RemoveItemFromCart(cartItem.menuItem));

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.white, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${cartItem.menuItem.name} removed from cart',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
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
        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
        padding: const EdgeInsets.all(6),
      ),
    );
  }
}

class _ItemAdd extends StatelessWidget {
  final dynamic cartItem;

  const _ItemAdd({required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(
          Icons.add_box_rounded,
          color: Colors.green.shade600,
          size: 20,
        ),
        onPressed: () {
          context.read<CartBloc>().add(AddItemToCart(cartItem.menuItem));

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.white, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${cartItem.menuItem.name} added to cart',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
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
        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
        padding: const EdgeInsets.all(6),
      ),
    );
  }
}

//
// ---------- Order Summary ----------
class _OrderSummary extends StatelessWidget {
  final CartState cartState;

  const _OrderSummary({required this.cartState});

  @override
  Widget build(BuildContext context) {
    final subtotal = cartState.cart.totalPrice;
    final tax = subtotal * 0.1;
    final total = subtotal + tax;

    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 16),
          _SummaryRow(
            label: 'Subtotal',
            value: '\$${subtotal.toStringAsFixed(2)}',
          ),
          _SummaryRow(
            label: 'Delivery Fee',
            value: 'Free',
            valueColor: Colors.green.shade600,
          ),
          _SummaryRow(label: 'Tax', value: '\$${tax.toStringAsFixed(2)}'),
          const SizedBox(height: 16),
          Container(height: 1, color: Colors.grey.shade200),
          const SizedBox(height: 16),
          _SummaryRow(
            label: 'Total',
            value: '\$${total.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isTotal;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: isTotal ? 20 : 16,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.normal,
            color: isTotal ? Colors.grey.shade800 : Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: isTotal ? 20 : 16,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color:
                valueColor ??
                (isTotal ? const Color(0xFF667eea) : Colors.grey.shade800),
          ),
        ),
      ],
    );
  }
}

//
// ---------- Place Order Button ----------
class _PlaceOrderButton extends StatelessWidget {
  final CartState cartState;

  const _PlaceOrderButton({required this.cartState});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderBloc, OrderState>(
      listener: (context, orderState) {
        if (orderState is OrderPlacementSuccess) {
          context.read<CartBloc>().add(ClearCart());
          _showSnack(
            context,
            'Order placed successfully!',
            Colors.green.shade600,
            Icons.check_circle,
          );
          Navigator.of(context).pop();
        } else if (orderState is OrderPlacementFailure) {
          _showSnack(
            context,
            'Order failed: ${orderState.error}',
            Colors.red.shade600,
            Icons.error_outline,
          );
        }
      },
      builder: (context, orderState) {
        final total = (cartState.cart.totalPrice * 1.1).toStringAsFixed(2);
        final isActive =
            cartState.cart.items.isNotEmpty &&
            orderState is! OrderPlacementInProgress;

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 32),
          height: 56,
          decoration: BoxDecoration(
            gradient: isActive
                ? const LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  )
                : null,
            color: isActive ? null : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: const Color(
                        0xFF667eea,
                      ).withAlpha((0.4 * 255).toInt()),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : null,
          ),
          child: ElevatedButton(
            onPressed: isActive
                ? () {
                    final cart = context.read<CartBloc>().state.cart;
                    context.read<OrderBloc>().add(PlaceOrder(cart));
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: orderState is OrderPlacementInProgress
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Placing Order...',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                : Text(
                    'Place Order - \$$total',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isActive ? Colors.white : Colors.grey.shade600,
                    ),
                  ),
          ),
        );
      },
    );
  }

  void _showSnack(
    BuildContext context,
    String text,
    Color color,
    IconData icon,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
  }
}
