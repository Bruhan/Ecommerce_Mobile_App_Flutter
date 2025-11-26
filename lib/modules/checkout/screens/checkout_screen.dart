import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ecommerce_mobile/routes/routes.dart';

import '../../../globals/theme.dart';
import '../../../models/cart_item.dart';
import '../../../network/api_service.dart';
import '../../../services/cart_manager.dart';

import '../../general/types/api.types.dart';
import 'package:ecommerce_mobile/modules/checkout/types/customer.dart';
import 'package:ecommerce_mobile/modules/checkout/types/customer_address.dart';
import 'package:ecommerce_mobile/modules/checkout/types/customer_billing_address.dart';

import 'package:ecommerce_mobile/modules/checkout/constants/checkout-api.routes.dart';
import 'apply_coupon_screen.dart'; // local screen

double _toDouble(dynamic v) {
  if (v == null) return 0.0;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0.0;
}

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final ApiService _apiService = ApiService();

  Customer? customerData;
  bool customerLoading = false;

  List<CustomerAddress>? shippingList;
  bool shippingLoading = false;

  CustomerBillingAddress? billingAddress;
  bool billingLoading = false;

  // price details expand/collapse
  bool _priceExpanded = false;

  // scroll controller + key to jump to price details
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _priceKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    fetchCustomer();
    fetchShipping();
    fetchBilling();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchCustomer() async {
    setState(() => customerLoading = true);
    try {
      final res = await _apiService.get(CheckoutApiRoutes.getCustomer);
      WebResponse<Customer> response = WebResponse.fromJson(
        res,
        (data) => Customer.fromJson(data),
      );

      if (response.statusCode == 200) {
        setState(() => customerData = response.results);
      }
    } catch (e) {
      debugPrint('fetchCustomer error: $e');
    } finally {
      setState(() => customerLoading = false);
    }
  }

  Future<void> fetchShipping() async {
    setState(() => shippingLoading = true);
    try {
      final res = await _api_service_getSafe(CheckoutApiRoutes.getAllCustomerAddressV2);
      WebResponse<List<CustomerAddress>> response =
          WebResponse.fromJson(res, (data) {
        return (data as List).map((e) => CustomerAddress.fromJson(e)).toList();
      });

      if (response.statusCode == 200) {
        setState(() => shippingList = response.results);
      }
    } catch (e) {
      debugPrint('fetchShipping error: $e');
    } finally {
      setState(() => shippingLoading = false);
    }
  }

  Future<void> fetchBilling() async {
    setState(() => billingLoading = true);
    try {
      final res = await _api_service_getSafe(CheckoutApiRoutes.getCustomerBillingAddress);
      WebResponse<CustomerBillingAddress> response =
          WebResponse.fromJson(res, (data) => CustomerBillingAddress.fromJson(data));
      if (response.statusCode == 200) {
        setState(() => billingAddress = response.results);
      }
    } catch (e) {
      debugPrint('fetchBilling error: $e');
    } finally {
      setState(() => billingLoading = false);
    }
  }

  Future<dynamic> _api_service_getSafe(String path) async {
    final r = await _apiService.get(path);
    return r;
  }

  CustomerAddress? get _selectedShipping {
    if (shippingList != null && shippingList!.isNotEmpty) {
      return shippingList!.first;
    }
    return null;
  }

  Future<void> _openAddressBookAndAwaitSelection() async {
    final result = await Navigator.pushNamed(context, Routes.addresses);
    if (result == null) return;

    if (result is CustomerAddress) {
      setState(() {
        shippingList = shippingList ?? [];
        if (shippingList!.isEmpty) shippingList!.insert(0, result);
        else shippingList![0] = result;
      });
      return;
    }

    if (result is Map<String, dynamic>) {
      try {
        final picked = CustomerAddress.fromJson(result);
        setState(() {
          shippingList = shippingList ?? [];
          if (shippingList!.isEmpty) shippingList!.insert(0, picked);
          else shippingList![0] = picked;
        });
      } catch (e) {
        debugPrint('Could not parse address result: $e');
      }
    }
  }

  String _formatDeliveryDate(DateTime dt) {
    final weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final w = weekdays[dt.weekday % 7];
    final m = months[dt.month - 1];
    return '$w, $m ${dt.day}';
  }

  DateTime _deliveryEstimateForItem(int index) {
    final baseDays = 2;
    return DateTime.now().add(Duration(days: baseDays + index));
  }

  /// Robust scroll helper:
  /// 1) ensure expanded.
  /// 2) wait a frame so widget is laid out.
  /// 3) call Scrollable.ensureVisible on the price card context.
  Future<void> _scrollToPriceDetails() async {
    setState(() => _priceExpanded = true);

    // Wait for next frame so the expanded child is included in layout
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final ctx = _priceKey.currentContext;
        if (ctx != null) {
          await Scrollable.ensureVisible(ctx,
              duration: const Duration(milliseconds: 360),
              curve: Curves.easeInOut,
              alignment: 0.12);
        } else {
          // fallback: scroll to bottom
          if (_scrollController.hasClients) {
            await _scrollController.animateTo(_scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 360), curve: Curves.easeInOut);
          }
        }
      } catch (e) {
        debugPrint('scrollToPriceDetails failed: $e');
      }
    });
  }

  Widget _orderItemsList(List<CartItem> items) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadii.md)),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Items (${items.length})', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: AppSpacing.md),
        Column(
          children: List.generate(items.length, (index) {
            final item = items[index];
            final deliveryDt = _deliveryEstimateForItem(index);
            final deliveryStr = 'Delivery by ${_formatDeliveryDate(deliveryDt)}';

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 72,
                    height: 72,
                    child: Image.network(item.imageUrl ?? '', fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: AppColors.surface, child: const Icon(Icons.image, size: 32, color: Colors.grey))),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),

                // title + meta + qty controls + delivery
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(item.title ?? 'Product', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Row(children: [
                      Text('Qty: ${item.quantity}', style: AppTextStyles.caption),
                      const SizedBox(width: 8),
                      if ((item.size ?? '').isNotEmpty) Text('Size: ${item.size}', style: AppTextStyles.caption),
                    ]),
                    const SizedBox(height: 8),
                    Text('₹${_toDouble(item.price).toStringAsFixed(2)}', style: AppTextStyles.body),
                    const SizedBox(height: AppSpacing.sm),

                    // delivery estimate
                    Text(deliveryStr, style: AppTextStyles.caption),

                    const SizedBox(height: AppSpacing.sm),

                    // quantity controls row (compact)
                    Row(children: [
                      // decrement
                      InkWell(
                        onTap: () {
                          final previousQty = item.quantity ?? 1;
                          final newQty = previousQty - 1;
                          if (newQty <= 0) {
                            final removedItem = CartItem(
                              id: item.id,
                              title: item.title,
                              price: item.price,
                              imageUrl: item.imageUrl,
                              quantity: previousQty,
                              size: item.size,
                            );
                            try {
                              CartManager.instance.removeItem(item.id, size: item.size);
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Item removed'),
                                  action: SnackBarAction(
                                    label: 'UNDO',
                                    onPressed: () {
                                      try {
                                        CartManager.instance.addItem(removedItem);
                                      } catch (e) {
                                        debugPrint('Failed to undo remove: $e');
                                      }
                                    },
                                  ),
                                ),
                              );
                            } catch (e) {
                              debugPrint('Failed to remove item: $e');
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to remove item')));
                            }
                          } else {
                            try {
                              CartManager.instance.updateQuantity(item.id, item.size, newQty);
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quantity updated'), duration: Duration(milliseconds: 900)));
                            } catch (e) {
                              debugPrint('Failed to update qty: $e');
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to update quantity')));
                            }
                          }
                        },
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: AppColors.fieldBorder)),
                          child: const Icon(Icons.remove, size: 16),
                        ),
                      ),

                      const SizedBox(width: AppSpacing.sm),

                      // quantity display
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: AppColors.fieldBorder)),
                        child: Text('${item.quantity}', style: AppTextStyles.body),
                      ),

                      const SizedBox(width: AppSpacing.sm),

                      // increment
                      InkWell(
                        onTap: () {
                          final previousQty = item.quantity ?? 1;
                          final newQty = previousQty + 1;
                          try {
                            CartManager.instance.updateQuantity(item.id, item.size, newQty);
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quantity updated'), duration: Duration(milliseconds: 900)));
                          } catch (e) {
                            debugPrint('Failed to update qty: $e');
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to update quantity')));
                          }
                        },
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.04), borderRadius: BorderRadius.circular(6), border: Border.all(color: AppColors.fieldBorder)),
                          child: const Icon(Icons.add, size: 16),
                        ),
                      ),
                    ]),
                  ]),
                ),
              ]),
            );
          }),
        ),
      ],
    ));
  }

  Widget _summaryRow(String title, String value, {bool isTotal = false}) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title, style: isTotal ? AppTextStyles.body.copyWith(fontWeight: FontWeight.w700) : AppTextStyles.caption),
      Text(value, style: isTotal ? AppTextStyles.h2.copyWith(fontSize: 18) : AppTextStyles.body),
    ]);
  }

  Map<String, double> _computePriceDetails() {
    final cart = CartManager.instance;
    final subtotal = _toDouble(cart.subtotal);
    final platformFee = 0.0;
    final shipping = _toDouble(cart.shippingFee);
    final vat = _toDouble(cart.vatAmount);
    final discount = _toDouble(cart.couponDiscount);
    final total = (subtotal + shipping + platformFee + vat) - discount;
    return {
      'subtotal': subtotal,
      'vat': vat,
      'shipping': shipping,
      'platformFee': platformFee,
      'discount': discount,
      'total': total < 0 ? 0.0 : total,
    };
  }

  Widget _priceDetailsCard(bool expanded) {
    final pd = _computePriceDetails();
    final subtotal = pd['subtotal']!;
    final discount = pd['discount']!;
    final shipping = pd['shipping']!;
    final platformFee = pd['platformFee']!;
    final total = pd['total']!;
    final savings = ((subtotal) - discount) - total;

    final header = Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text("Price Details", style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w700)),
      Icon(expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
    ]);

    final expandedView = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: AppSpacing.sm),
      _priceRow("Price (${CartManager.instance.items.length} items)", '₹${subtotal.toStringAsFixed(2)}'),
      const SizedBox(height: AppSpacing.sm),
      _priceRow("Discount on MRP", '- ₹${discount.toStringAsFixed(2)}', valueColor: Colors.green),
      const SizedBox(height: AppSpacing.sm),
      _priceRow("Platform Fee", '₹${platformFee.toStringAsFixed(2)}'),
      const SizedBox(height: AppSpacing.sm),
      _priceRow("Shipping", '₹${shipping.toStringAsFixed(2)}'),
      const Divider(height: 28),
      _priceRow("Total Amount", '₹${total.toStringAsFixed(2)}', isTotal: true),
      const SizedBox(height: AppSpacing.md),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.success.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
        child: Center(child: Text('You will save ₹${savings.abs().toStringAsFixed(0)} on this order', style: AppTextStyles.body.copyWith(color: AppColors.success))),
      ),
    ]);

    return Container(
      key: _priceKey,
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadii.lg)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        GestureDetector(
          // clicking header should EXPAND & SCROLL (not toggle hide)
          onTap: _scrollToPriceDetails,
          child: header,
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: expandedView,
          crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
        )
      ]),
    );
  }

  Widget _priceRow(String label, String value, {bool isTotal = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(label, style: isTotal ? AppTextStyles.body.copyWith(fontWeight: FontWeight.w700) : AppTextStyles.body)),
        const SizedBox(width: AppSpacing.sm),
        Text(value, style: isTotal ? AppTextStyles.h2.copyWith(fontSize: 18) : AppTextStyles.body.copyWith(color: valueColor ?? Colors.black)),
      ],
    );
  }

  Future<void> _openApplyCouponScreen() async {
    final res = await Navigator.push(context, MaterialPageRoute(builder: (_) => const ApplyCouponScreen()));
    if (res is Map<String, dynamic>) {
      final code = res['code'] as String?;
      final discount = res['discount'] is num ? (res['discount'] as num).toDouble() : _toDouble(res['discount']);
      if (code != null) {
        CartManager.instance.applyCoupon(code, discount);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Coupon $code applied')));
      }
    }
  }

  void _removeCoupon() {
    CartManager.instance.removeCoupon();
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartManager.instance;
    final selected = _selectedShipping;

    return Scaffold(
      appBar: AppBar(leading: const BackButton(), title: const Text("Checkout")),
      bottomNavigationBar: AnimatedBuilder(
        animation: CartManager.instance,
        builder: (context, _) {
          final total = CartManager.instance.totalPrice;
          return SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
              decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, -2))]),
              child: Row(children: [
                Expanded(
                  child: InkWell(
                    onTap: _scrollToPriceDetails, // reliable scroll to price details
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: total, end: total),
                        duration: const Duration(milliseconds: 400),
                        builder: (context, value, child) {
                          return Text('₹${value.toStringAsFixed(2)}', style: AppTextStyles.h2.copyWith(fontSize: 18, fontWeight: FontWeight.w800));
                        },
                      ),
                      const SizedBox(height: 4),
                      Text('View price details', style: AppTextStyles.caption.copyWith(color: AppColors.primary)),
                    ]),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                SizedBox(
                  width: 150,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.payment);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.amber[700], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    child: Text('Continue', style: AppTextStyles.body.copyWith(color: Colors.black, fontWeight: FontWeight.w700)),
                  ),
                ),
              ]),
            ),
          );
        },
      ),
      body: AnimatedBuilder(
        animation: CartManager.instance,
        builder: (context, _) {
          if (cart.items.isEmpty) {
            return Center(child: Text("Your cart is empty", style: AppTextStyles.body.copyWith(fontSize: 18)));
          }

          final items = cart.items;

          return SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (selected != null)
                _addressCard(
                  title: "Delivery Address",
                  name: selected.addr1 ?? 'Home',
                  phone: selected.mobileNumber ?? '',
                  line1: selected.addr1 ?? '',
                  line2: selected.addr2 ?? '',
                  line3: selected.addr3 ?? '',
                  line4: selected.addr4 ?? '',
                  state: selected.state ?? '',
                  country: '',
                )
              else if (billingLoading || shippingLoading || customerLoading)
                const Center(child: CircularProgressIndicator())
              else if (billingAddress != null)
                _addressCard(
                  title: "Delivery Address",
                  name: billingAddress!.customerName ?? '',
                  phone: billingAddress!.mobileNumber ?? '',
                  line1: billingAddress!.addr1 ?? '',
                  line2: billingAddress!.addr2 ?? '',
                  line3: billingAddress!.addr3 ?? '',
                  line4: billingAddress!.addr4 ?? '',
                  state: billingAddress!.state ?? '',
                  country: billingAddress!.country ?? '',
                )
              else
                Text('No address found', style: AppTextStyles.caption),

              const SizedBox(height: AppSpacing.xl),

              Text("Order Summary", style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: AppSpacing.lg),

              _orderItemsList(items),
              const SizedBox(height: AppSpacing.xl),

              // price details with key
              _priceDetailsCard(_priceExpanded),
              const SizedBox(height: AppSpacing.lg),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                if (CartManager.instance.couponCode == null)
                  Expanded(
                    child: InkWell(
                      onTap: _openApplyCouponScreen,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppRadii.md), border: Border.all(color: AppColors.fieldBorder)),
                        child: Row(children: [
                          const Icon(Icons.local_offer_outlined, size: 20, color: Colors.grey),
                          const SizedBox(width: AppSpacing.sm),
                          Text('Apply Coupon', style: AppTextStyles.body),
                        ]),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppRadii.md), color: AppColors.surface),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('Coupon: ${CartManager.instance.couponCode ?? ''}', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                        TextButton(onPressed: _removeCoupon, child: Text('Remove', style: AppTextStyles.body.copyWith(color: AppColors.primary))),
                      ]),
                    ),
                  ),
              ]),
              const SizedBox(height: 100),
            ]),
          );
        },
      ),
    );
  }

  Widget _addressCard({
    required String title,
    required String name,
    required String phone,
    required String line1,
    required String line2,
    required String line3,
    required String line4,
    required String state,
    required String country,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(title, style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w700)),
          InkWell(
            onTap: () {
              _openAddressBookAndAwaitSelection();
            },
            child: Text("Change", style: AppTextStyles.body.copyWith(color: AppColors.primary, decoration: TextDecoration.underline)),
          ),
        ]),
        const SizedBox(height: AppSpacing.md),
        Row(children: [
          const Icon(Icons.location_on, size: 22, color: Colors.black87),
          const SizedBox(width: AppSpacing.md),
          Text(name, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: AppSpacing.sm),
        Padding(
          padding: const EdgeInsets.only(left: 28),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(phone, style: AppTextStyles.caption),
            Text("$line1 $line2 $line3 $line4".trim(), style: AppTextStyles.caption),
            Text("$state${country.isNotEmpty ? ', $country' : ''}", style: AppTextStyles.caption),
          ]),
        ),
      ]),
    );
  }
}
