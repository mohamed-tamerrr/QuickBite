import 'package:QuickBite/features/checkout/data/order_model.dart';
import 'package:QuickBite/features/checkout/data/order_repo.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../shared/custom_button.dart';
import '../../../shared/custom_text.dart';

class OrderHistoryView extends StatefulWidget {
  const OrderHistoryView({super.key});

  @override
  State<OrderHistoryView> createState() =>
      _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView> {
  final OrderRepo _orderRepo = OrderRepo();
  OrdersResponse? _orders;
  Future<void> _getOrders() async {
    try {
      _orders = await _orderRepo.getOrders();
      setState(() {});
    } catch (e) {
      throw Exception('Failed to load orders: $e');
    }
  }

  @override
  initState() {
    _getOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const Gap(60),

            /// Title
            Row(
              children: const [
                CustomText(
                  text: "Order History",
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),

            /// Cart Items List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(top: 10),
                itemCount: _orders?.data?.length ?? 0,
                separatorBuilder: (_, __) => const Gap(15),
                itemBuilder: (context, index) {
                  final order = _orders!.data![index];
                  return Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 20,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Image.network(
                                order.productImage ?? '',
                                width: 80,
                                height: 80,
                              ),
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: 'Order #${order.id}',
                                  ),
                                  CustomText(
                                    text: 'Quantity: 2',
                                  ),
                                  CustomText(
                                    text: order.totalPrice ?? '',
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Gap(20),
                          CustomButton(
                            text: 'Re order',
                            onTap: () {},
                            color: Colors.grey.shade400,
                            width: double.infinity,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
