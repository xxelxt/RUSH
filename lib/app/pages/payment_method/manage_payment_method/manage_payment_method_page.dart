import 'package:rush/app/providers/account_provider.dart';

import 'package:rush/app/providers/payment_method_provider.dart';
import 'package:rush/app/widgets/radio_card.dart';
import 'package:rush/core/domain/entities/payment_method/payment_method.dart';
import 'package:rush/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManagePaymentMethodPage extends StatefulWidget {
  const ManagePaymentMethodPage({super.key});

  @override
  State<ManagePaymentMethodPage> createState() => _ManagePaymentMethodPageState();
}

class _ManagePaymentMethodPageState extends State<ManagePaymentMethodPage> {
  bool returnPaymentMethod = false;

  String accountId = FirebaseAuth.instance.currentUser!.uid;

  PaymentMethod? selectedPaymentMethod;

  bool _isLoading = false;

  @override
  void initState() {
    Future.microtask(
      () {
        returnPaymentMethod = ModalRoute.of(context)!.settings.arguments as bool;

        selectedPaymentMethod = context.read<AccountProvider>().account.primaryPaymentMethod;
        context.read<PaymentMethodProvider>().getPaymentMethod(accountId: accountId);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Payment'),
        actions: [
          TextButton(
            onPressed: () {
              NavigateRoute.toAddPaymentMethod(context: context);
            },
            child: const Text('Add Method'),
          ),
        ],
      ),
      body: Consumer<PaymentMethodProvider>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            children: [
              // Address List
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    children: [
                      if (value.listPaymentMethod.isEmpty)
                        Center(
                          child: Text(
                            'Payment Method is Empty,\nAdd your payment method for payment purpose',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      if (value.listPaymentMethod.isNotEmpty)
                        ...value.listPaymentMethod.map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: RadioCard<PaymentMethod>(
                              title: e.cardholderName,
                              subtitle: e.cardNumber,
                              value: e,
                              selectedValue: selectedPaymentMethod,
                              onChanged: (value) {
                                setState(() {
                                  selectedPaymentMethod = value;
                                });
                              },
                              onDelete: () {
                                value.delete(accountId: accountId, paymentMethodId: e.paymentMethodId);

                                // If the primary payment method deleted
                                if (selectedPaymentMethod == e) {
                                  selectedPaymentMethod = null;
                                  context.read<AccountProvider>().update(data: {
                                    'primary_payment_method': null,
                                  });
                                }
                              },
                              onEdit: () {
                                NavigateRoute.toEditPaymentMethod(context: context, paymentMethod: e);
                              },
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ),

              // Button
              if (value.listPaymentMethod.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: ElevatedButton(
                    onPressed: selectedPaymentMethod == null
                        ? null
                        : () async {
                            if (_isLoading) return;

                            if (returnPaymentMethod) {
                              Navigator.of(context).pop(selectedPaymentMethod);
                              return;
                            }

                            setState(() {
                              _isLoading = true;
                            });

                            PaymentMethod? oldData = context.read<AccountProvider>().account.primaryPaymentMethod;
                            await value
                                .changePrimary(accountId: accountId, data: selectedPaymentMethod!, oldData: oldData)
                                .whenComplete(
                              () async {
                                context.read<AccountProvider>().getProfile();
                                setState(() {
                                  _isLoading = false;
                                });
                                Navigator.of(context).pop();
                              },
                            );
                          },
                    child: _isLoading
                        ? const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                              ),
                            ),
                          )
                        : returnPaymentMethod
                            ? const Text('Select Payment Method')
                            : const Text('Change Primary Payment Method'),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
