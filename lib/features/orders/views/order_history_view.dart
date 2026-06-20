import 'package:QuickBite/features/orders/data/order_model.dart';
import 'package:QuickBite/features/orders/data/order_repo.dart';
import 'package:QuickBite/shared/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../shared/custom_button.dart';

class OrderHistoryView extends StatefulWidget {
  const OrderHistoryView({super.key});

  @override
  State<OrderHistoryView> createState() =>
      _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView> {
  final OrderRepo _orderRepo = OrderRepo();
  OrdersResponse? _orders;
  bool isLoading = true;

  Future<void> _getOrders() async {
    try {
      final response = await _orderRepo.getOrders();
      setState(() {
        _orders = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
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
    /// No Data
    if ((_orders?.data?.isEmpty ?? true)) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 90,
                color: Colors.grey.shade400,
              ),

              const Gap(20),

              const CustomText(
                text: 'No Orders Yet',

                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),

              const Gap(8),

              CustomText(
                text: 'Your previous orders will appear here',
                color: Colors.grey.shade600,
              ),
            ],
          ),
        ),
      );
    }

    /// Loading
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(60),

            /// Title
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Order History',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  '${_orders?.data?.length ?? 0} orders',
                  style: TextStyle(color: Colors.grey.shade600),
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
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: .05,
                          ),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(18),
                              child: Image.network(
                                order.productImage ?? '',
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order #${order.id}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight.w700,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Text(
                                    'Quantity: ${1}',
                                    style: TextStyle(
                                      color:
                                          Colors.grey.shade600,
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                    decoration: BoxDecoration(
                                      color: Colors.green
                                          .withValues(
                                            alpha: .12,
                                          ),
                                      borderRadius:
                                          BorderRadius.circular(
                                            30,
                                          ),
                                    ),
                                    child: const Text(
                                      'Delivered',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight:
                                            FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Text(
                              '\$${order.totalPrice}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            text: 'Reorder',
                            onTap: () {},
                          ),
                        ),
                      ],
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
