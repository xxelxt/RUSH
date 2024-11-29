import 'package:rush/app/pages/payment/widgets/select_payment_method.dart';
import 'package:rush/app/providers/account_provider.dart';
import 'package:rush/app/providers/cart_provider.dart';
import 'package:rush/app/providers/checkout_provider.dart';
import 'package:rush/app/providers/transaction_provider.dart';
import 'package:rush/app/widgets/error_banner.dart';
import 'package:rush/core/domain/entities/payment_method/payment_method.dart';
import 'package:rush/routes.dart';
import 'package:rush/themes/custom_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rush/utils/extension.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  PaymentMethod? paymentMethod;

  @override
  void initState() {
    Future.microtask(() {
      setState(() {
        paymentMethod = context.read<AccountProvider>().account.primaryPaymentMethod;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Consumer<CheckoutProvider>(
        builder: (context, value, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Payment Method
                      SelectPaymentMethod(
                        paymentMethod: paymentMethod,
                        selectPaymentMethod: () async {
                          var result = await NavigateRoute.toManagePaymentMethod(context: context, returnPaymentMethod: true);
                          setState(() {
                            paymentMethod = result;
                          });
                        },
                        removePaymentMethod: () {
                          setState(() {
                            paymentMethod = null;
                          });
                        },
                      ),
                      const SizedBox(height: 12),

                      // Payment Summary
                      Text(
                        'Payment Summary',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Bill',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            value.dataTransaction.totalBill?.toCurrency() ?? '-',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Service Fee',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            value.dataTransaction.serviceFee?.toCurrency() ?? '-',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Total Pay & Pay
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Pay',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          value.dataTransaction.totalPay?.toCurrency() ?? '-',
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                color: CustomColor.error,
                              ),
                        ),
                      ],
                    ),
                    Consumer<CheckoutProvider>(
                      builder: (context, value, child) {
                        if (value.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return ElevatedButton(
                          onPressed: paymentMethod == null
                              ? null
                              : () async {
                                  if (value.isLoading) return;

                                  try {
                                    ScaffoldMessenger.of(context).removeCurrentMaterialBanner();

                                    value.dataTransaction.paymentMethod = paymentMethod;
                                    await value.payCheckout().whenComplete(() {
                                      context.read<CartProvider>().getCart(accountId: FirebaseAuth.instance.currentUser!.uid);

                                      Navigator.of(context).popUntil((route) => route.isFirst);

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Transaction Success, check your transaction status on transaction page',
                                          ),
                                        ),
                                      );
                                      context.read<TransactionProvider>().loadAccountTransaction();
                                    });
                                  } catch (e) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
                                      ScaffoldMessenger.of(context).showMaterialBanner(
                                        errorBanner(context: context, msg: e.toString()),
                                      );
                                    }
                                  }
                                },
                          child: const Text('Pay'),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
