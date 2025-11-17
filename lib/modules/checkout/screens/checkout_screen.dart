import 'dart:convert';

import 'package:ecommerce_mobile/modules/checkout/constants/checkout-api.constant.dart';
import 'package:ecommerce_mobile/modules/checkout/types/create_anonymous_sales_order_response.dart';
import 'package:ecommerce_mobile/modules/checkout/types/pre_process_anonymous_order_request.dart';
import 'package:ecommerce_mobile/modules/checkout/types/pre_process_anonymous_order_response.dart';
import 'package:ecommerce_mobile/routes/routes.dart';
import 'package:flutter/material.dart';
import '../../../globals/theme.dart';
import '../../../models/cart_item.dart';
import '../../../network/api_service.dart';
import '../../../services/cart_manager.dart';
import '../../general/types/api.types.dart';
import '../types/create_anonymous_sales_order_request.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPayment = "COD"; // default payment method
  final ApiService _apiService = ApiService();
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
                    onPressed: () {
                      _onCheckoutPressed(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Row(
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
            Radio(
              activeColor: AppColors.primary,
              value: key,
              groupValue: _selectedPayment,
              onChanged: (value) {
                setState(() => _selectedPayment = value.toString());
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onCheckoutPressed(BuildContext context)async {
    if(_selectedPayment == "COD") {
      final totalPrice = CartManager.instance.totalPrice;
      final totalQuantity = CartManager.instance.totalQuantity;


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

      final preProcessAnonymousOrderRequest = PreProcessAnonymousOrderRequest(
        customerName: "",
        mobileNumber: "",
        email: "ultra.thowfiq@gmail.com",
        addr1: "",
        addr2: "",
        addr3: "",
        addr4: "",
        state: "",
        pinCode: "",
        country: "",
        itemList: itemList,
      );

      final preProcessRes = await _apiService.post(CheckoutApiConstant.preProcessAnonymousOrder, json.encode(preProcessAnonymousOrderRequest));

      WebResponse<PreProcessAnonymousOrderResponse> preProcessResponse = WebResponse.fromJson(preProcessRes, (data) {
        return PreProcessAnonymousOrderResponse.fromJson(data);
      });

      final batch = [
        Batch(
          doLineNo: 1,
          batch: "NOBATCH",
          location: "NONSTOCK",
        )
      ];

      final anonymousOrderRequest = CreateAnonymousSalesOrderRequest(
        customerName: "",
        mobileNumber: "8668050644",
        email: "",
        addr1: "",
        addr2: "",
        addr3: "",
        addr4: "",
        state: "",
        pinCode: "",
        country: "",
        orderId: preProcessResponse.results.orderId,
        orderDate: preProcessResponse.results.orderDate,
        waybillNos: preProcessResponse.results.waybillNos,
        rzpOrderId: "",
        rzpStatus: "",
        itemList: itemList,
        remarks: doDetRemarks,
        batch: batch,
        paymentType: "CASH_ON_DELIVERY",
      );

      final createOrderRes = await _apiService.post(CheckoutApiConstant.processAnonymousOrder, json.encode(anonymousOrderRequest));

      WebResponse<CreateAnonymousSalesOrderResponse> createAnonymousOrderResponse = WebResponse.fromJson(createOrderRes, (data) {
        return CreateAnonymousSalesOrderResponse.fromJson(data);
      });
      print(createOrderRes);

      if(createAnonymousOrderResponse.statusCode == 200) {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Order placed using $_selectedPayment"),
            duration: const Duration(seconds: 1),
          ),
        );
        Navigator.pushReplacementNamed(context, Routes.home);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Order Failed"),
            duration: const Duration(seconds: 1),
          ),
        );
      }

    }

  }
}
