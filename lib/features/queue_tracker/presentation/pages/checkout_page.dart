import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CheckoutPage extends StatefulWidget {
  final String itemName;
  final bool isDelivery;
  
  const CheckoutPage({Key? key, required this.itemName, this.isDelivery = false}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool _isProcessing = false;
  final TextEditingController _seatController = TextEditingController();

  @override
  void dispose() {
    _seatController.dispose();
    super.dispose();
  }

  void _processPayment() {
    if (widget.isDelivery && _seatController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter your Stand and Seat Number.'),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isProcessing = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isProcessing = false);
        final successText = widget.isDelivery
          ? 'Payment Successful! ${widget.itemName} will be delivered to ${_seatController.text}.'
          : 'Payment Successful! Proceed to ${widget.itemName} Express Lane.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successText),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        context.pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Imagery
          Image.network(
            'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?q=80&w=1500&auto=format&fit=crop',
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.7),
            colorBlendMode: BlendMode.darken,
          ),
          
          SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => context.pop(),
                    ),
                    const Text('Checkout', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.white.withOpacity(0.1)),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Icon(Icons.receipt_long, size: 48, color: Colors.white70),
                                const SizedBox(height: 16),
                                Text(
                                  widget.isDelivery ? 'Delivery Summary' : 'Pickup Summary',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 24),

                                if (widget.isDelivery) ...[
                                  TextField(
                                    controller: _seatController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      labelText: 'Enter Stand & Seat Number (e.g., C Stand, 42)',
                                      labelStyle: const TextStyle(color: Colors.white70),
                                      prefixIcon: const Icon(Icons.airline_seat_recline_normal, color: Colors.white70),
                                      filled: true,
                                      fillColor: Colors.black.withOpacity(0.3),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '1x ${widget.itemName}',
                                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    const Text('\$14.50', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(widget.isDelivery ? 'Delivery Fee' : 'Convenience Fee', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14)),
                                    Text(widget.isDelivery ? '\$3.50' : '\$1.50', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14)),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Divider(color: Colors.white24),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Total', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                    Text(widget.isDelivery ? '\$18.00' : '\$16.00', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                                  ],
                                ),
                                const SizedBox(height: 48),
                                
                                // Payment Options Mock
                                _buildPaymentOption(context, Icons.apple, 'Apple Pay', true),
                                const SizedBox(height: 12),
                                _buildPaymentOption(context, Icons.credit_card, '•••• 4242', false),
                                
                                const SizedBox(height: 32),
                                
                                ElevatedButton.icon(
                                  onPressed: _isProcessing ? null : _processPayment,
                                  icon: _isProcessing 
                                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                                    : const Icon(Icons.lock_outline, size: 24),
                                  label: Text(_isProcessing ? 'Processing Payment...' : (widget.isDelivery ? 'Confirm \$18.00' : 'Confirm \$16.00')),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(double.infinity, 56),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(BuildContext context, IconData icon, String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.2) : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(width: 16),
          Expanded(child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600))),
          if (isSelected)
            Icon(Icons.check_circle, color: Theme.of(context).primaryColor),
        ],
      ),
    );
  }
}
