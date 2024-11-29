import 'package:rush/app/pages/address/add_address/add_address_page.dart';
import 'package:rush/app/pages/address/edit_address/edit_address_page.dart';
import 'package:rush/app/pages/address/manage_address/manage_address_page.dart';
import 'package:rush/app/pages/auth/forgot_password/forgot_password_page.dart';
import 'package:rush/app/pages/checkout/checkout_page.dart';
import 'package:rush/app/pages/payment/payment_page.dart';
import 'package:rush/app/pages/payment_method/add_payment_method/add_payment_method_page.dart';
import 'package:rush/app/pages/payment_method/edit_payment_method/edit_payment_method_page.dart';
import 'package:rush/app/pages/payment_method/manage_payment_method/manage_payment_method_page.dart';
import 'package:rush/app/pages/product/product_review/product_review_page.dart';
import 'package:rush/app/pages/transaction/detail_transaction/detail_transaction_page.dart';
import 'package:rush/core/domain/entities/address/address.dart';
import 'package:rush/core/domain/entities/payment_method/payment_method.dart';
import 'package:rush/core/domain/entities/product/product.dart';
import 'package:flutter/material.dart';

import 'app/pages/auth/login/login_page.dart';
import 'app/pages/auth/register/register_page.dart';
import 'app/pages/product/add_product/add_product_page.dart';
import 'app/pages/product/detail_product/detail_product_page.dart';
import 'app/pages/product/edit_product/edit_product_page.dart';
import 'core/domain/entities/review/review.dart';

class RouteName {
  static const String kLogin = '/login';
  static const String kRegister = '/register';
  static const String kAddProduct = '/add_product';
  static const String kDetailProduct = '/detail_product';
  static const String kEditProduct = '/edit_product';
  static const String kProductReview = '/product_review';
  static const String kForgotPassword = '/forgot_password';
  static const String kManageAddress = '/manage_address';
  static const String kAddAddress = '/add_address';
  static const String kEditAddress = '/edit_address';
  static const String kManagePaymentMethod = '/manage_payment_method';
  static const String kAddPaymentMethod = '/add_payment_method';
  static const String kEditPaymentMethod = '/edit_payment_method';
  static const String kCheckout = '/checkout';
  static const String kPayment = '/payment';
  static const String kDetailTransaction = '/detail_transaction';
}

class NavigateRoute {
  static toLogin({required BuildContext context}) {
    Navigator.of(context).pushNamed(RouteName.kLogin);
  }

  static toRegister({required BuildContext context}) {
    Navigator.of(context).pushNamed(RouteName.kRegister);
  }

  static toAddProduct({required BuildContext context}) {
    Navigator.of(context).pushNamed(RouteName.kAddProduct);
  }

  static toDetailProduct({required BuildContext context, required String productId}) {
    Navigator.of(context).pushNamed(RouteName.kDetailProduct, arguments: productId);
  }

  static toEditProduct({required BuildContext context, required Product product}) {
    Navigator.of(context).pushNamed(RouteName.kEditProduct, arguments: product);
  }

  static toProductReview({required BuildContext context, required List<Review> productReview}) {
    Navigator.of(context).pushNamed(RouteName.kProductReview, arguments: productReview);
  }

  static toForgotPassword({required BuildContext context}) {
    Navigator.of(context).pushNamed(RouteName.kForgotPassword);
  }

  static Future toManageAddress({required BuildContext context, bool returnAddress = false}) async {
    return await Navigator.of(context).pushNamed(RouteName.kManageAddress, arguments: returnAddress);
  }

  static toAddAddress({required BuildContext context}) {
    Navigator.of(context).pushNamed(RouteName.kAddAddress);
  }

  static toEditAddress({required BuildContext context, required Address address}) {
    Navigator.of(context).pushNamed(RouteName.kEditAddress, arguments: address);
  }

  static Future toManagePaymentMethod({required BuildContext context, bool returnPaymentMethod = false}) async {
    return await Navigator.of(context).pushNamed(RouteName.kManagePaymentMethod, arguments: returnPaymentMethod);
  }

  static toAddPaymentMethod({required BuildContext context}) {
    Navigator.of(context).pushNamed(RouteName.kAddPaymentMethod);
  }

  static toEditPaymentMethod({required BuildContext context, required PaymentMethod paymentMethod}) {
    Navigator.of(context).pushNamed(RouteName.kEditPaymentMethod, arguments: paymentMethod);
  }

  static toCheckout({required BuildContext context}) {
    Navigator.of(context).pushNamed(RouteName.kCheckout);
  }

  static toPayment({required BuildContext context}) {
    Navigator.of(context).pushNamed(RouteName.kPayment);
  }

  static toDetailTransaction({required BuildContext context, required String transactionID}) {
    Navigator.of(context).pushNamed(RouteName.kDetailTransaction, arguments: transactionID);
  }
}

final routes = {
  RouteName.kLogin: (_) => const LoginPage(),
  RouteName.kRegister: (_) => const RegisterPage(),
  RouteName.kAddProduct: (_) => const AddProductPage(),
  RouteName.kDetailProduct: (_) => const DetailProductPage(),
  RouteName.kEditProduct: (_) => const EditProductPage(),
  RouteName.kProductReview: (_) => const ProductReviewPage(),
  RouteName.kForgotPassword: (_) => const ForgotPasswordPage(),
  RouteName.kManageAddress: (_) => const ManageAddressPage(),
  RouteName.kAddAddress: (_) => const AddAddressPage(),
  RouteName.kEditAddress: (_) => const EditAddressPage(),
  RouteName.kManagePaymentMethod: (_) => const ManagePaymentMethodPage(),
  RouteName.kAddPaymentMethod: (_) => const AddPaymentMethodPage(),
  RouteName.kEditPaymentMethod: (_) => const EditPaymentMethodPage(),
  RouteName.kCheckout: (_) => const CheckoutPage(),
  RouteName.kPayment: (_) => const PaymentPage(),
  RouteName.kDetailTransaction: (_) => const DetailTransactionPage(),
};
