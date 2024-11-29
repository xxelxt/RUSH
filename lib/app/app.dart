import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rush/app/constants/collections_name.dart';
import 'package:rush/app/pages/navigation/bottom_navigation.dart';
import 'package:rush/app/providers/account_provider.dart';
import 'package:rush/app/providers/address_provider.dart';
import 'package:rush/app/providers/auth_provider.dart' as auth_provider;
import 'package:rush/app/providers/cart_provider.dart';
import 'package:rush/app/providers/checkout_provider.dart';
import 'package:rush/app/providers/dark_mode_provider.dart';
import 'package:rush/app/providers/payment_method_provider.dart';
import 'package:rush/app/providers/product_provider.dart';
import 'package:rush/app/providers/transaction_provider.dart';
import 'package:rush/app/providers/wishlist_provider.dart';
import 'package:rush/config/flavor_config.dart';
import 'package:rush/core/domain/usecases/account/ban_account.dart';
import 'package:rush/core/domain/usecases/account/get_account_profile.dart';
import 'package:rush/core/domain/usecases/account/get_all_account.dart';
import 'package:rush/core/domain/usecases/account/update_account.dart';
import 'package:rush/core/domain/usecases/address/add_address.dart';
import 'package:rush/core/domain/usecases/address/change_primary_address.dart';
import 'package:rush/core/domain/usecases/address/delete_address.dart';
import 'package:rush/core/domain/usecases/address/get_account_address.dart';
import 'package:rush/core/domain/usecases/address/update_address.dart';
import 'package:rush/core/domain/usecases/auth/login_account.dart';
import 'package:rush/core/domain/usecases/auth/logout_account.dart';
import 'package:rush/core/domain/usecases/auth/register_account.dart';
import 'package:rush/core/domain/usecases/cart/add_account_cart.dart';
import 'package:rush/core/domain/usecases/cart/delete_account_cart.dart';
import 'package:rush/core/domain/usecases/cart/get_account_cart.dart';
import 'package:rush/core/domain/usecases/cart/update_account_cart.dart';
import 'package:rush/core/domain/usecases/checkout/pay.dart';
import 'package:rush/core/domain/usecases/checkout/start_checkout.dart';
import 'package:rush/core/domain/usecases/payment_method/add_payment_method.dart';
import 'package:rush/core/domain/usecases/payment_method/change_primary_payment_method.dart';
import 'package:rush/core/domain/usecases/payment_method/delete_payment_method.dart';
import 'package:rush/core/domain/usecases/payment_method/get_account_payment_method.dart';
import 'package:rush/core/domain/usecases/payment_method/update_payment_method.dart';
import 'package:rush/core/domain/usecases/product/add_product.dart';
import 'package:rush/core/domain/usecases/product/delete_product.dart';
import 'package:rush/core/domain/usecases/product/get_list_product.dart';
import 'package:rush/core/domain/usecases/product/get_product.dart';
import 'package:rush/core/domain/usecases/product/get_product_review.dart';
import 'package:rush/core/domain/usecases/product/update_product.dart';
import 'package:rush/core/domain/usecases/transaction/accept_transaction.dart';
import 'package:rush/core/domain/usecases/transaction/add_review.dart';
import 'package:rush/core/domain/usecases/transaction/change_transaction_status.dart';
import 'package:rush/core/domain/usecases/transaction/get_account_transaction.dart';
import 'package:rush/core/domain/usecases/transaction/get_all_transaction.dart';
import 'package:rush/core/domain/usecases/transaction/get_transaction.dart';
import 'package:rush/core/domain/usecases/wishlist/add_account_wishlist.dart';
import 'package:rush/core/domain/usecases/wishlist/delete_account_wishlist.dart';
import 'package:rush/core/domain/usecases/wishlist/get_account_wishlist.dart';
import 'package:rush/core/repositories/account_repository_impl.dart';
import 'package:rush/core/repositories/address_repository_impl.dart';
import 'package:rush/core/repositories/auth_repository_impl.dart';
import 'package:rush/core/repositories/cart_repository_impl.dart';
import 'package:rush/core/repositories/checkout_repository_impl.dart';
import 'package:rush/core/repositories/payment_method_repository_impl.dart';
import 'package:rush/core/repositories/product_repository_impl.dart';
import 'package:rush/core/repositories/transaction_repository_impl.dart';
import 'package:rush/core/repositories/wishlist_repository_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes.dart';
import 'pages/auth/login/login_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  // Collection Reference
  final CollectionReference _accountCollection = FirebaseFirestore.instance.collection(CollectionsName.kACCOUNT);
  final CollectionReference _productCollection = FirebaseFirestore.instance.collection(CollectionsName.kPRODUCT);
  final CollectionReference _transactionCollection = FirebaseFirestore.instance.collection(CollectionsName.kTRANSACTION);

  // Repository Impl
  late AuthRepositoryImpl _authRepositoryImpl;
  late AccountRepositoryImpl _accountRepositoryImpl;
  late ProductRepositoryImpl _productRepositoryImpl;
  late CartRepositoryImpl _cartRepositoryImpl;
  late WishlistRepositoryImpl _wishlistRepositoryImpl;
  late AddressRepositoryImpl _addressRepositoryImpl;
  late PaymentMethodRepositoryImpl _paymentMethodRepositoryImpl;
  late CheckoutRepositoryImpl _checkoutRepositoryImpl;
  late TransactionRepositoryImpl _transactionRepositoryImpl;

  @override
  void initState() {
    _authRepositoryImpl = AuthRepositoryImpl(auth: FirebaseAuth.instance, collectionReference: _accountCollection);
    _accountRepositoryImpl = AccountRepositoryImpl(collectionReference: _accountCollection);
    _productRepositoryImpl = ProductRepositoryImpl(collectionReference: _productCollection);
    _cartRepositoryImpl = CartRepositoryImpl(collectionReference: _accountCollection);
    _wishlistRepositoryImpl = WishlistRepositoryImpl(collectionReference: _accountCollection);
    _addressRepositoryImpl = AddressRepositoryImpl(collectionReference: _accountCollection);
    _paymentMethodRepositoryImpl = PaymentMethodRepositoryImpl(collectionReference: _accountCollection);
    _checkoutRepositoryImpl = CheckoutRepositoryImpl(collectionReference: _transactionCollection);
    _transactionRepositoryImpl = TransactionRepositoryImpl(collectionReference: _transactionCollection);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => auth_provider.AuthProvider(
            loginAccount: LoginAccount(_authRepositoryImpl),
            registerAccount: RegisterAccount(_authRepositoryImpl),
            logoutAccount: LogoutAccount(_authRepositoryImpl),
          )..isLoggedIn(),
        ),
        ChangeNotifierProvider(
          create: (_) => DarkModeProvider()..getDarkMode(),
        ),
        ChangeNotifierProvider(
          create: (_) => AccountProvider(
            getAccountProfile: GetAccountProfile(_accountRepositoryImpl),
            getAllAccount: GetAllAccount(_accountRepositoryImpl),
            updateAccount: UpdateAccount(_accountRepositoryImpl),
            banAccount: BanAccount(_accountRepositoryImpl),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductProvider(
            getListProduct: GetListProduct(_productRepositoryImpl),
            getProduct: GetProduct(_productRepositoryImpl),
            getProductReview: GetProductReview(_productRepositoryImpl),
            addProduct: AddProduct(_productRepositoryImpl),
            updateProduct: UpdateProduct(_productRepositoryImpl),
            deleteProduct: DeleteProduct(_productRepositoryImpl),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(
            addAccountCart: AddAccountCart(_cartRepositoryImpl),
            getAccountCart: GetAccountCart(_cartRepositoryImpl),
            updateAccountCart: UpdateAccountCart(_cartRepositoryImpl),
            deleteAccountCart: DeleteAccountCart(_cartRepositoryImpl),
            getProduct: GetProduct(_productRepositoryImpl),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => WishlistProvider(
            addAccountWishlist: AddAccountWishlist(_wishlistRepositoryImpl),
            getAccountWishlist: GetAccountWishlist(_wishlistRepositoryImpl),
            deleteAccountWishlist: DeleteAccountWishlist(_wishlistRepositoryImpl),
            getProduct: GetProduct(_productRepositoryImpl),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => AddressProvider(
            addAddress: AddAddress(_addressRepositoryImpl),
            getAccountAddress: GetAccountAddress(_addressRepositoryImpl),
            updateAddress: UpdateAddress(_addressRepositoryImpl),
            deleteAddress: DeleteAddress(_addressRepositoryImpl),
            changePrimaryAddress: ChangePrimaryAddress(_addressRepositoryImpl),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => PaymentMethodProvider(
            addPaymentMethod: AddPaymentMethod(_paymentMethodRepositoryImpl),
            getAccountPaymentMethod: GetAccountPaymentMethod(_paymentMethodRepositoryImpl),
            updatePaymentMethod: UpdatePaymentMethod(_paymentMethodRepositoryImpl),
            deletePaymentMethod: DeletePaymentMethod(_paymentMethodRepositoryImpl),
            changePrimaryPaymentMethod: ChangePrimaryPaymentMethod(_paymentMethodRepositoryImpl),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => CheckoutProvider(
            startCheckout: StartCheckout(_checkoutRepositoryImpl),
            pay: Pay(_checkoutRepositoryImpl),
            updateProduct: UpdateProduct(_productRepositoryImpl),
            deleteAccountCart: DeleteAccountCart(_cartRepositoryImpl),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => TransactionProvider(
            getAccountTransaction: GetAccountTransaction(_transactionRepositoryImpl),
            getTransaction: GetTransaction(_transactionRepositoryImpl),
            getAllTransaction: GetAllTransaction(_transactionRepositoryImpl),
            acceptTransaction: AcceptTransaction(_transactionRepositoryImpl),
            addReview: AddReview(_transactionRepositoryImpl),
            changeTransactionStatus: ChangeTransactionStatus(_transactionRepositoryImpl),
            getAccountProfile: GetAccountProfile(_accountRepositoryImpl),
          ),
        ),
      ],
      child: Consumer<DarkModeProvider>(
        builder: (context, darkMode, child) {
          return MaterialApp(
            title: FlavorConfig.instance.flavorValues.roleConfig.appName(),
            theme: FlavorConfig.instance.flavorValues.roleConfig.theme(),
            darkTheme: FlavorConfig.instance.flavorValues.roleConfig.darkTheme(),
            themeMode: darkMode.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            routes: routes,
            debugShowCheckedModeBanner: false,
            home: Consumer<auth_provider.AuthProvider>(
              child: const BottomNavigation(),
              builder: (context, auth, child) {
                if (auth.checkUser || darkMode.isLoading) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (auth.isUserLoggedIn) {
                  return child!;
                }

                return const LoginPage();
              },
            ),
          );
        },
      ),
    );
  }
}
