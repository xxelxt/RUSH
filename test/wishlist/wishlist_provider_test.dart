import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rush/app/constants/order_by_value.dart';
import 'package:rush/app/providers/wishlist_provider.dart';
import 'package:rush/core/domain/entities/product/product.dart';
import 'package:rush/core/domain/entities/wishlist/wishlist.dart';
import 'package:rush/core/domain/usecases/product/get_product.dart';
import 'package:rush/core/domain/usecases/wishlist/add_account_wishlist.dart';
import 'package:rush/core/domain/usecases/wishlist/delete_account_wishlist.dart';
import 'package:rush/core/domain/usecases/wishlist/get_account_wishlist.dart';

// Generate mock classes
@GenerateMocks([
  AddAccountWishlist,
  GetAccountWishlist,
  DeleteAccountWishlist,
  GetProduct,
])
import 'wishlist_provider_test.mocks.dart'; // Import file mock tự động

void main() {
  // Mock các use case
  late MockAddAccountWishlist mockAddAccountWishlist;
  late MockGetAccountWishlist mockGetAccountWishlist;
  late MockDeleteAccountWishlist mockDeleteAccountWishlist;
  late MockGetProduct mockGetProduct;

  // WishlistProvider cần kiểm tra
  late WishlistProvider wishlistProvider;

  setUp(() {
    // Khởi tạo mock
    mockAddAccountWishlist = MockAddAccountWishlist();
    mockGetAccountWishlist = MockGetAccountWishlist();
    mockDeleteAccountWishlist = MockDeleteAccountWishlist();
    mockGetProduct = MockGetProduct();

    // Tạo instance WishlistProvider với mock
    wishlistProvider = WishlistProvider(
      addAccountWishlist: mockAddAccountWishlist,
      getAccountWishlist: mockGetAccountWishlist,
      deleteAccountWishlist: mockDeleteAccountWishlist,
      getProduct: mockGetProduct,
    );
  });

  group('WishlistProvider Tests', () {
    test('Should load wishlist with product details successfully', () async {
      // Mock dữ liệu
      final accountId = 'user123';
      final mockWishlist = [
        Wishlist(
          wishlistId: 'wishlist1',
          productId: 'product1',
          product: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      final mockProduct = Product(
        productId: 'product1',
        productName: 'Test Product',
        productPrice: 1000.0,
        productDescription: 'Test Description',
        productImage: ['image1.jpg'],
        totalReviews: 10,
        rating: 4.5,
        stock: 5,
        isDeleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Khi gọi getAccountWishlist, trả về danh sách mockWishlist
      when(mockGetAccountWishlist.execute(accountId: accountId, search: ''))
          .thenAnswer((_) async => mockWishlist);

      // Khi gọi getProduct, trả về sản phẩm mockProduct
      when(mockGetProduct.execute(productId: 'product1'))
          .thenAnswer((_) async => mockProduct);

      // Gọi hàm loadWishlist
      await wishlistProvider.loadWishlist(accountId: accountId);

      // Kiểm tra danh sách được cập nhật
      expect(wishlistProvider.listWishlist.length, 1);
      expect(wishlistProvider.listWishlist.first.product?.productName, 'Test Product');
      expect(wishlistProvider.isLoadData, false);

      // Đảm bảo use case được gọi đúng
      verify(mockGetAccountWishlist.execute(accountId: accountId, search: '')).called(1);
      verify(mockGetProduct.execute(productId: 'product1')).called(1);
    });

    test('Should add a new item to wishlist with product details', () async {
      // Mock dữ liệu
      final accountId = 'user123';
      final newWishlist = Wishlist(
        wishlistId: 'wishlist1',
        productId: 'product1',
        product: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final mockProduct = Product(
        productId: 'product1',
        productName: 'New Product',
        productPrice: 2000.0,
        productDescription: 'New Product Description',
        productImage: ['image2.jpg'],
        totalReviews: 15,
        rating: 4.8,
        stock: 10,
        isDeleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Khi gọi addAccountWishlist, không làm gì thêm
      when(mockAddAccountWishlist.execute(accountId: accountId, data: newWishlist))
          .thenAnswer((_) async {});

      // Khi gọi getProduct, trả về sản phẩm mockProduct
      when(mockGetProduct.execute(productId: 'product1'))
          .thenAnswer((_) async => mockProduct);

      // Gọi hàm add
      await wishlistProvider.add(accountId: accountId, data: newWishlist);

      // Kiểm tra danh sách được cập nhật
      expect(wishlistProvider.listWishlist.length, 1);
      expect(wishlistProvider.listWishlist.first.product?.productName, 'New Product');
      expect(wishlistProvider.isLoading, false);

      // Đảm bảo use case được gọi đúng
      verify(mockAddAccountWishlist.execute(accountId: accountId, data: newWishlist)).called(1);
      verify(mockGetProduct.execute(productId: 'product1')).called(1);
    });

    test('Should delete an item from wishlist successfully', () async {
      // Mock dữ liệu
      final accountId = 'user123';
      final wishlistToDelete = Wishlist(
        wishlistId: 'wishlist1',
        productId: 'product1',
        product: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      wishlistProvider.listWishlist.add(wishlistToDelete);

      // Khi gọi deleteAccountWishlist, không làm gì thêm
      when(mockDeleteAccountWishlist.execute(accountId: accountId, wishlistId: 'wishlist1'))
          .thenAnswer((_) async {});

      // Gọi hàm delete
      await wishlistProvider.delete(accountId: accountId, wishlistId: 'wishlist1');

      // Kiểm tra danh sách không còn phần tử đã xoá
      expect(wishlistProvider.listWishlist, isEmpty);
      expect(wishlistProvider.isLoading, false);

      // Đảm bảo use case được gọi đúng
      verify(mockDeleteAccountWishlist.execute(accountId: accountId, wishlistId: 'wishlist1'))
          .called(1);
    });
  });
}
