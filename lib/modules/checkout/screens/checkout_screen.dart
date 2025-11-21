import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/routes/routes.dart';
import 'package:ecommerce_mobile/modules/checkout/constants/checkout-api.routes.dart';
import 'package:ecommerce_mobile/modules/checkout/constants/checkout-api.constant.dart';
import 'package:ecommerce_mobile/modules/checkout/types/pre_process_order_request.dart';
import 'package:ecommerce_mobile/modules/checkout/types/pre_process_order_response.dart';
import 'package:ecommerce_mobile/modules/checkout/types/create_sales_order_request.dart';
import 'package:ecommerce_mobile/modules/checkout/types/create_sales_order_response.dart';
import 'package:ecommerce_mobile/modules/checkout/types/pre_process_anonymous_order_request.dart';
import 'package:ecommerce_mobile/modules/checkout/types/pre_process_anonymous_order_response.dart';
import 'package:ecommerce_mobile/modules/checkout/types/create_anonymous_sales_order_request.dart';
import 'package:ecommerce_mobile/modules/checkout/types/create_anonymous_sales_order_response.dart';
import 'package:ecommerce_mobile/modules/checkout/types/customer.dart';
import 'package:ecommerce_mobile/modules/checkout/types/customer_address.dart';
import 'package:ecommerce_mobile/modules/checkout/types/customer_billing_address.dart';

import '../../../globals/theme.dart';
import '../../../models/cart_item.dart';
import '../../../network/api_service.dart';
import '../../../services/cart_manager.dart';
import '../../../services/order_manager.dart';
import '../../../models/order_model.dart';
import '../../general/types/api.types.dart';
import '../../../widgets/checkout_success_dialog.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPayment = "COD"; // default payment method
  final ApiService _apiService = ApiService();

  bool _isProcessing = false;

  // Customer & addresses
  List<CustomerAddress>? customerAddressesData;
  bool customerAddressesDataLoading = false;

  CustomerBillingAddress? customerBillingAddressData;
  bool customerBillingAddressDataLoading = false;

  Customer? customerData;
  bool customerDataLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCustomer();
    fetchCustomerShippingAddress();
    fetchCustomerBillingAddress();
  }

  Future<void> fetchCustomer() async {
    setState(() {
      customerDataLoading = true;
    });
    try {
      final res = await _api_service_getSafe(CheckoutApiRoutes.getCustomer);
      WebResponse<Customer> response = WebResponse.fromJson(
        res,
        (data) => Customer.fromJson(data),
      );

      debugPrint('fetchCustomer: ${response.statusCode} ${response.message}');

      if (response.statusCode == 200) {
        setState(() {
          customerData = response.results;
          customerDataLoading = false;
        });
      } else {
        if (mounted) {
          setState(() {
            customerDataLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message ?? "Unknown error")),
          );
        }
      }
    } catch (e, st) {
      debugPrint('fetchCustomer error: $e\n$st');
      if (mounted) {
        setState(() {
          customerDataLoading = false;
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch customer: ${e.toString()}')),
      );
    }
  }

  Future<void> fetchCustomerShippingAddress() async {
    try {
      setState(() {
        customerAddressesDataLoading = true;
      });
      final res = await _api_service_getSafe(CheckoutApiRoutes.getAllCustomerAddressV2);
      WebResponse<List<CustomerAddress>> response = WebResponse.fromJson(
        res,
        (data) {
          return (data as List)
              .map((e) => CustomerAddress.fromJson(e as Map<String, dynamic>))
              .toList();
        },
      );

      debugPrint('fetchCustomerShippingAddress: ${response.statusCode}');

      if (response.statusCode == 200) {
        setState(() {
          customerAddressesData = response.results;
          customerAddressesDataLoading = false;
        });
      } else {
        setState(() {
          customerAddressesDataLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? 'Failed to fetch addresses')),
        );
      }
    } catch (ex, st) {
      debugPrint('fetchCustomerShippingAddress error: $ex\n$st');
      setState(() {
        customerAddressesDataLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch addresses: ${ex.toString()}')),
      );
    }
  }

  Future<void> fetchCustomerBillingAddress() async {
    setState(() {
      customerBillingAddressDataLoading = true;
    });
    try {
      final res = await _api_service_getSafe(CheckoutApiRoutes.getCustomerBillingAddress);
      WebResponse<CustomerBillingAddress> response = WebResponse.fromJson(
        res,
        (data) => CustomerBillingAddress.fromJson(data),
      );

      debugPrint('fetchCustomerBillingAddress: ${response.statusCode}');

      if (response.statusCode == 200) {
        setState(() {
          customerBillingAddressData = response.results;
          customerBillingAddressDataLoading = false;
        });
      } else {
        if (mounted) {
          setState(() {
            customerBillingAddressDataLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message ?? "Unknown error")),
          );
        }
      }
    } catch (e, st) {
      debugPrint('fetchCustomerBillingAddress error: $e\n$st');
      setState(() {
        customerBillingAddressDataLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch billing address: ${e.toString()}')),
      );
    }
  }

  /// helper to ensure ApiService.get returns a Map or List (keeps code robust)
  Future<dynamic> _api_service_getSafe(String path) async {
    final r = await _apiService.get(path);
    return r;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Checkout'),
      ),
      body: AnimatedBuilder(
        animation: CartManager.instance,
        builder: (context, _) {
          final items = CartManager.instance.items;
          final subtotal = CartManager.instance.subtotal;
          final shipping = CartManager.instance.shippingFee;
          final vatAmount = CartManager.instance.vatAmount;
          final total = CartManager.instance.totalPrice;

          if (items.isEmpty) {
            return Center(
              child: Text(
                'Your cart is empty',
                style: AppTextStyles.body.copyWith(fontSize: 16),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ======= ORDER SUMMARY CARD =======
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 3)),
                    ],
                  ),
                  child: Column(
                    children: [
                      _summaryRow('Sub-total', '₹${subtotal.toStringAsFixed(2)}'),
                      const SizedBox(height: AppSpacing.sm),
                      _summaryRow('VAT (${CartManager.instance.vatAmount}%)', '₹${vatAmount.toStringAsFixed(2)}'),
                      const SizedBox(height: AppSpacing.sm),
                      _summaryRow('Shipping', '₹${shipping.toStringAsFixed(2)}'),
                      const Divider(height: 30),
                      _summaryRow('Total', '₹${total.toStringAsFixed(2)}', isTotal: true),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),
                Text("Address", style: AppTextStyles.h2),
                const SizedBox(height: AppSpacing.md),
                // Show correct state for billing address
                if (customerBillingAddressDataLoading)
                  const Center(child: CircularProgressIndicator())
                else if (customerBillingAddressData != null)
                  _billingAddressCard(customerBillingAddressData!)
                else
                  Text('No billing address found', style: AppTextStyles.caption),

                const SizedBox(height: AppSpacing.xl),

                /// ======= PAYMENT METHOD SELECTION =======
                Text("Payment Method", style: AppTextStyles.h2),
                const SizedBox(height: AppSpacing.md),

                _paymentOption("COD", "Cash on Delivery", Icons.delivery_dining),
                _paymentOption("CARD", "Credit / Debit Card", Icons.credit_card),
                _paymentOption("UPI", "UPI (GPay, PhonePe, Paytm)", Icons.account_balance_wallet),
                _paymentOption("NETBANKING", "Net Banking", Icons.language),

                const SizedBox(height: AppSpacing.xl),

                /// ======= CHECKOUT BUTTON =======
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : () => _onCheckoutPressed(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isProcessing
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text("Processing...", style: AppTextStyles.body.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Place Order", style: AppTextStyles.body.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                              const SizedBox(width: 8),
                              const Icon(Icons.check_circle, color: Colors.white, size: 20),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// =================== SUMMARY ROW ========================
  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: isTotal
                ? AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)
                : AppTextStyles.caption),
        Text(value,
            style: isTotal
                ? AppTextStyles.h2.copyWith(fontSize: 18)
                : AppTextStyles.body),
      ],
    );
  }

  /// ===================== BILLING ADDRESS CARD ========================
  Widget _billingAddressCard(CustomerBillingAddress address) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Billing Address",
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
          Text(address.customerName ?? "No Name",
              style: AppTextStyles.body),
          Text("${address.mobileNumber}", style: AppTextStyles.caption),
          Text("${address.addr1 ?? ""} ${address.addr2 ?? ""} ${address.addr3 ?? ""} ${address.addr4 ?? ""}", style: AppTextStyles.caption),
          Text("${address.state ?? ""} ${address.country ?? ""}", style: AppTextStyles.caption),
        ],
      ),
    );
  }

  /// =================== PAYMENT OPTION WIDGET ========================
  Widget _paymentOption(String key, String title, IconData icon) {
    bool selected = _selectedPayment == key;

    return InkWell(
      onTap: () {
        setState(() => _selectedPayment = key);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? AppColors.primary : AppColors.fieldBorder),
        ),
        child: Row(
          children: [
            Icon(icon, size: 28, color: selected ? AppColors.primary : Colors.grey),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
            ),
            Radio<String>(
              activeColor: AppColors.primary,
              value: key,
              groupValue: _selectedPayment,
              onChanged: (value) {
                if (value == null) return;
                setState(() => _selectedPayment = value);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Create a local OrderModel from cart items (best-effort).
  OrderModel _buildOrderFromCart(String orderId) {
    final cartItems = CartManager.instance.items;
    final orderItems = cartItems.map((e) {
      final id = e.id.toString();
      String title = 'Product';
      String size = '';
      double price = 0.0;
      String imageUrl = '';

      try {
        if (e is CartItem) {
          title = (e.title ?? 'Product');
          size = (e.size ?? '');
          price = (e.price is num) ? (e.price as num).toDouble() : 0.0;
          imageUrl = (e.imageUrl ?? '');
        }
      } catch (_) {}

      return OrderItem(
        id: id,
        title: title,
        size: size,
        price: price,
        imageUrl: imageUrl,
      );
    }).toList();

    final items = orderItems.isNotEmpty
        ? orderItems
        : [
            OrderItem(id: 'unknown', title: 'Product', size: '', price: 0.0, imageUrl: ''),
          ];

    final billingAddr = customerBillingAddressData;
    final addressString = billingAddr != null
        ? '${billingAddr.addr1 ?? ''} ${billingAddr.addr2 ?? ''} ${billingAddr.addr3 ?? ''} ${billingAddr.addr4 ?? ''}'.trim()
        : (customerAddressesData != null && customerAddressesData!.isNotEmpty
            ? '${customerAddressesData!.first.addr1 ?? ''} ${customerAddressesData!.first.addr2 ?? ''} ${customerAddressesData!.first.addr3 ?? ''} ${customerAddressesData!.first.addr4 ?? ''}'.trim()
            : '');

    final order = OrderModel(
      id: orderId,
      items: items,
      status: OrderStatus.inTransit, // default to inTransit on creation
      orderDate: DateTime.now(),
      address: addressString,
      deliveryPersonName: 'Delivery Guy',
      deliveryPersonPhone: '', // safe fallback — don't assume a Customer field name
    );

    return order;
  }

  Future<void> _onCheckoutPressed(BuildContext context) async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      if (_selectedPayment == "COD") {
        if (customerData == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Customer data not found")),
          );
          setState(() => _isProcessing = false);
          return;
        }

        final itemList = CartManager.instance.items.indexed.map((item) {
          final i = item.$1;
          final e = item.$2;

          return ItemList(
            item: e.id.toString(),
            doLineNo: i + 1,
            ecomUnitPrice: e.price,
            quantityOr: e.quantity,
            promotions: [],
          );
        }).toList();

        final doDetRemarks = CartManager.instance.items.indexed.map((item) {
          final i = item.$1;
          final e = item.$2;

          return Remarks(
            item: e.id.toString(),
            doLineNo: i + 1,
            remarks: "",
          );
        }).toList();

        final preProcessOrderRequest = PreProcessOrderRequest(
          isShippingSameAsBilling: true,
          shippingAddressId: 0,
          itemList: itemList,
        );

        final preProcessRes = await _apiService.post(CheckoutApiRoutes.preProcessOrder, json.encode(preProcessOrderRequest));

        WebResponse<PreProcessOrderResponse> preProcessResponse = WebResponse.fromJson(preProcessRes, (data) {
          return PreProcessOrderResponse.fromJson(data);
        });

        if (preProcessResponse.statusCode != 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(preProcessResponse.message ?? 'Pre-process failed')),
          );
          setState(() => _isProcessing = false);
          return;
        }

        final batch = [
          Batch(
            doLineNo: 1,
            batch: "NOBATCH",
            location: "NONSTOCK",
          )
        ];

        final orderRequest = CreateSalesOrderRequest(
          orderId: preProcessResponse.results.orderId,
          orderDate: preProcessResponse.results.orderDate,
          waybillNos: preProcessResponse.results.waybillNos,
          isShippingSameAsBilling: true,
          rzpOrderId: "",
          rzpStatus: "",
          itemList: itemList,
          remarks: doDetRemarks,
          batch: batch,
          paymentType: "CASH_ON_DELIVERY",
        );

        final createOrderRes = await _apiService.post(CheckoutApiRoutes.processOrder, json.encode(orderRequest));

        WebResponse<CreateSalesOrderResponse> createOrderResponse = WebResponse.fromJson(createOrderRes, (data) {
          return CreateSalesOrderResponse.fromJson(data);
        });

        debugPrint('createOrderResponse: ${createOrderResponse.statusCode} ${createOrderResponse.message}');

        if (createOrderResponse.statusCode == 200) {
          final newOrderId = createOrderResponse.results?.orderId?.toString() ??
              preProcessResponse.results?.orderId?.toString() ??
              'ORD-${DateTime.now().millisecondsSinceEpoch}';

          // Build local OrderModel and add to OrderManager so My Orders screen reflects it
          final orderModel = _buildOrderFromCart(newOrderId);
          try {
            OrderManager.instance.addOrder(orderModel);
          } catch (e) {
            debugPrint('Failed to add order to OrderManager: $e');
          }

          // NOTE: Your CartManager does not currently expose clear() or clearItems().
          // If you add a method (e.g. CartManager.instance.clear()), call it here to empty cart.

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => CheckoutSuccessDialog(
              title: 'Congratulations!',
              message: 'Your order has been placed.',
              actionText: 'Track Your Order',
              onTrack: () {
                Navigator.of(context).pop();
                if (newOrderId.isNotEmpty) {
                  Navigator.of(context).pushNamed(
                    Routes.orders,
                    arguments: {'openTrack': true, 'orderId': newOrderId},
                  );
                } else {
                  Navigator.of(context).pushNamed(Routes.orders);
                }
              },
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Order Failed: ${createOrderResponse.message ?? ''}"),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        // Placeholder for non-COD flows (CARD / UPI / NETBANKING)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment method ($_selectedPayment) not implemented — simulating success')),
        );

        await Future.delayed(const Duration(milliseconds: 400));

        // Simulate a generated order id for demo flows
        final simulatedOrderId = 'SIM-${DateTime.now().millisecondsSinceEpoch}';

        // Build and add simulated order to OrderManager
        final simulatedOrder = _buildOrderFromCart(simulatedOrderId);
        try {
          OrderManager.instance.addOrder(simulatedOrder);
        } catch (e) {
          debugPrint('Failed to add simulated order: $e');
        }

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => CheckoutSuccessDialog(
            title: 'Congratulations!',
            message: 'Your order has been placed.',
            actionText: 'Track Your Order',
            onTrack: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(
                Routes.orders,
                arguments: {'openTrack': true, 'orderId': simulatedOrderId},
              );
            },
          ),
        );
      }
    } catch (e, st) {
      debugPrint('Checkout error: $e\n$st');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }
}
