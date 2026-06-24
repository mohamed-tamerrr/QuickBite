import 'package:QuickBite/features/auth/cubit/auth_cubit.dart';
import 'package:QuickBite/features/orders/widgets/payment_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PaymentMethodView extends StatefulWidget {
  const PaymentMethodView({
    super.key,
    this.visaText,
    required this.selectedMethod,
    required this.onMethodSelected,
  });

  final String? visaText;
  final PaymentMethod selectedMethod;
  final void Function(PaymentMethod method) onMethodSelected;

  @override
  State<PaymentMethodView> createState() =>
      _PaymentMethodViewState();
}

class _PaymentMethodViewState extends State<PaymentMethodView> {
  /// Mask
  String _maskedVisa(String visa) {
    final digits = visa.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length <= 4) {
      return visa;
    }
    final last4 = digits.substring(digits.length - 4);
    return 'Visa •••• $last4';
  }

  @override
  Widget build(BuildContext context) {
    final hasVisa =
        widget.visaText != null && widget.visaText!.isNotEmpty;
    return Column(
      children: [
        PaymentCard(
          widget: widget,
          method: PaymentMethod.cashOnDelivery,
          title: 'Cash on Delivery',
          subtitle: 'Pay when your order arrives',
          image: 'assets/cash.png',
        ),

        if (hasVisa) ...[
          const Gap(16),
          PaymentCard(
            widget: widget,
            method: PaymentMethod.visa,
            title: 'Visa',
            subtitle: _maskedVisa(widget.visaText!),
            image: 'assets/visa.png',
          ),
        ],
      ],
    );
  }
}
