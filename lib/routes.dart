import 'package:rush/app/pages/address/add_address_page.dart';
import 'package:rush/app/pages/address/edit_address_page.dart';
import 'package:rush/app/pages/address/manage_address_page.dart';
import 'package:rush/app/pages/auth/forgot_password/forgot_password_page.dart';
import 'package:rush/app/pages/checkout/checkout_page.dart';
import 'package:rush/app/pages/payment/payment_page.dart';
import 'package:rush/app/pages/payment_method/add_payment_method_page.dart';
import 'package:rush/app/pages/payment_method/edit_payment_method_page.dart';
import 'package:rush/app/pages/payment_method/manage_payment_method_page.dart';
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
  static const String kLogin = '/login'; // Route cho trang đăng nhập
  static const String kRegister = '/register'; // Route cho trang đăng ký
  static const String kAddProduct = '/add_product'; // Route thêm sản phẩm
  static const String kDetailProduct = '/detail_product'; // Route xem chi tiết sản phẩm
  static const String kEditProduct = '/edit_product'; // Route chỉnh sửa sản phẩm
  static const String kProductReview = '/product_review'; // Route xem đánh giá sản phẩm
  static const String kForgotPassword = '/forgot_password'; // Route quên mật khẩu
  static const String kManageAddress = '/manage_address'; // Route quản lý địa chỉ
  static const String kAddAddress = '/add_address'; // Route thêm địa chỉ
  static const String kEditAddress = '/edit_address'; // Route chỉnh sửa địa chỉ
  static const String kManagePaymentMethod = '/manage_payment_method'; // Route quản lý phương thức thanh toán
  static const String kAddPaymentMethod = '/add_payment_method'; // Route thêm phương thức thanh toán
  static const String kEditPaymentMethod = '/edit_payment_method'; // Route chỉnh sửa phương thức thanh toán
  static const String kCheckout = '/checkout'; // Route thanh toán
  static const String kPayment = '/payment'; // Route thanh toán chi tiết
  static const String kDetailTransaction = '/detail_transaction'; // Route chi tiết giao dịch
}

// Lớp NavigateRoute cung cấp các phương thức điều hướng đến các trang khác nhau
class NavigateRoute {
  static toLogin({required BuildContext context}) {
    Navigator.of(context).pushNamed(RouteName.kLogin); // Điều hướng đến trang đăng nhập
  }

  static toRegister({required BuildContext context}) {
    Navigator.of(context).pushNamed(RouteName.kRegister); // Điều hướng đến trang đăng ký
  }

  static toAddProduct({required BuildContext context}) {
    Navigator.of(context).pushNamed(RouteName.kAddProduct); // Điều hướng đến trang thêm sản phẩm
  }

  static toDetailProduct({required BuildContext context, required String productId}) {
    Navigator.of(context).pushNamed(RouteName.kDetailProduct, arguments: productId); // Điều hướng đến chi tiết sản phẩm
  }

  static toEditProduct({required BuildContext context, required Product product}) {
    Navigator.of(context).pushNamed(RouteName.kEditProduct, arguments: product); // Điều hướng đến chỉnh sửa sản phẩm
  }

  static toProductReview({required BuildContext context, required List<Review> productReview}) {
    Navigator.of(context).pushNamed(RouteName.kProductReview, arguments: productReview); // Điều hướng đến trang đánh giá sản phẩm
  }

  static toForgotPassword({required BuildContext context}) {
    Navigator.of(context).pushNamed(RouteName.kForgotPassword); // Điều hướng đến trang quên mật khẩu
  }

  static Future toManageAddress({required BuildContext context, bool returnAddress = false}) async {
    return await Navigator.of(context).pushNamed(RouteName.kManageAddress, arguments: returnAddress); // Điều hướng đến quản lý địa chỉ
  }

  static toAddAddress({required BuildContext context}) {
    Navigator.of(context).pushNamed(RouteName.kAddAddress); // Điều hướng đến thêm địa chỉ
  }

  static toEditAddress({required BuildContext context, required Address address}) {
    Navigator.of(context).pushNamed(RouteName.kEditAddress, arguments: address); // Điều hướng đến chỉnh sửa địa chỉ
  }

  static Future toManagePaymentMethod({required BuildContext context, bool returnPaymentMethod = false}) async {
    return await Navigator.of(context).pushNamed(RouteName.kManagePaymentMethod, arguments: returnPaymentMethod); // Điều hướng đến quản lý phương thức thanh toán
  }

  static toAddPaymentMethod({required BuildContext context}) {
    Navigator.of(context).pushNamed(RouteName.kAddPaymentMethod); // Điều hướng đến thêm phương thức thanh toán
  }

  static toEditPaymentMethod({required BuildContext context, required PaymentMethod paymentMethod}) {
    Navigator.of(context).pushNamed(RouteName.kEditPaymentMethod, arguments: paymentMethod); // Điều hướng đến chỉnh sửa phương thức thanh toán
  }

  static toCheckout({required BuildContext context}) {
    Navigator.of(context).pushNamed(RouteName.kCheckout); // Điều hướng đến trang thanh toán
  }

  static toPayment({required BuildContext context}) {
    Navigator.of(context).pushNamed(RouteName.kPayment); // Điều hướng đến chi tiết thanh toán
  }

  static toDetailTransaction({required BuildContext context, required String transactionID}) {
    Navigator.of(context).pushNamed(RouteName.kDetailTransaction, arguments: transactionID); // Điều hướng đến chi tiết giao dịch
  }
}

// Cấu hình map các route với widget tương ứng
final routes = {
  RouteName.kLogin: (_) => const LoginPage(), // Map route đến widget LoginPage
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
