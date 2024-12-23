import 'package:rush/app/pages/customer/list_customer_page.dart';
import 'package:rush/app/pages/product/list_product/list_product_page.dart';
import 'package:rush/app/pages/profile/profile_page.dart';
import 'package:rush/app/pages/transaction/list_transaction/list_transaction_page.dart';
import 'package:rush/app/pages/wishlist/list_wishlist_page.dart';
import 'package:rush/app/providers/account_provider.dart';
import 'package:rush/app/providers/cart_provider.dart';
import 'package:rush/app/providers/product_provider.dart';
import 'package:rush/app/providers/transaction_provider.dart';
import 'package:rush/app/providers/wishlist_provider.dart';
import 'package:rush/config/flavor_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  // Danh sách màn hình tương ứng với các mục Navigation
  final List<Widget> _buildScreens = [];

  // Danh sách các mục Navigation
  final List<NavigationDestination> _destinations = [];

  FlavorConfig flavor = FlavorConfig.instance;

  @override
  void initState() {
    // Thêm mục "Trang chủ"
    _destinations.add(
      const NavigationDestination(
        icon: Icon(Icons.home_outlined), // Icon khi chưa chọn
        label: 'Trang chủ',
        selectedIcon: Icon(Icons.home_rounded), // Icon khi được chọn
      ),
    );
    _buildScreens.add(const ListProductPage());

    // Thêm các mục dành cho người dùng
    if (flavor.flavor == Flavor.user) {
      _destinations.addAll([
        const NavigationDestination(
          icon: Icon(Icons.favorite_outline_rounded),
          label: 'Yêu thích',
          selectedIcon: Icon(Icons.favorite_rounded),
        ),
        const NavigationDestination(
          icon: Icon(Icons.receipt_long_outlined),
          label: 'Đơn hàng',
          selectedIcon: Icon(Icons.receipt_long_rounded),
        ),
      ]);
      _buildScreens.addAll([
        const ListWishlistPage(), // Màn hình danh sách yêu thích
        const ListTransactionPage(), // Màn hình danh sách đơn hàng
      ]);
    } else {

      // Thêm các mục dành cho admin
      _destinations.addAll([
        const NavigationDestination(
          icon: Icon(Icons.receipt_long_outlined),
          label: 'Đơn hàng',
          selectedIcon: Icon(Icons.receipt_long_rounded),
        ),
        const NavigationDestination(
          icon: Icon(Icons.group_outlined),
          label: 'Khách hàng',
          selectedIcon: Icon(Icons.group_rounded),
        ),
      ]);
      _buildScreens.addAll([
        const ListTransactionPage(), // Màn hình danh sách đơn hàng
        const ListCustomerPage(), // Màn hình danh sách khách hàng
      ]);
    }

    // Thêm mục "Tài khoản"
    _buildScreens.add(const ProfilePage());
    _destinations.add(
      const NavigationDestination(
        icon: Icon(Icons.person_outline),
        label: 'Tài khoản',
        selectedIcon: Icon(Icons.person_rounded),
      ),
    );

    // Tải dữ liệu cần thiết khi khởi tạo
    Future.microtask(() {
      String accountId = FirebaseAuth.instance.currentUser!.uid; // Lấy ID người dùng hiện tại
      context.read<ProductProvider>().loadListProduct(); // Tải danh sách sản phẩm
      context.read<CartProvider>().getCart(accountId: accountId); // Tải giỏ hàng
      if (flavor.flavor == Flavor.user) {
        // Dành cho người dùng
        context.read<WishlistProvider>().loadWishlist(accountId: accountId); // Tải danh sách yêu thích
        context.read<TransactionProvider>().loadAccountTransaction(); // Tải giao dịch của tài khoản
      } else {
        // Dành cho admin
        context.read<TransactionProvider>().loadAllTransaction(); // Tải tất cả giao dịch
        context.read<AccountProvider>().getListAccount(); // Tải danh sách tài khoản
      }
      context.read<AccountProvider>().getProfile(); // Tải hồ sơ cá nhân
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildScreens[_currentIndex], // Hiển thị màn hình tương ứng với mục đã chọn
      bottomNavigationBar: NavigationBar(
        destinations: _destinations, // Danh sách các mục Navigation
        selectedIndex: _currentIndex, // Chỉ số mục hiện tại
        onDestinationSelected: (int index) {
          // Thay đổi màn hình khi chọn mục khác
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
