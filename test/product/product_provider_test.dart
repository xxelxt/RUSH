import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rush/app/providers/product_provider.dart';
import 'package:rush/core/domain/entities/product/product.dart';
import 'package:rush/core/domain/entities/review/review.dart';
import 'package:rush/core/domain/usecases/product/add_product.dart';
import 'package:rush/core/domain/usecases/product/delete_product.dart';
import 'package:rush/core/domain/usecases/product/get_list_product.dart';
import 'package:rush/core/domain/usecases/product/get_product.dart';
import 'package:rush/core/domain/usecases/product/get_product_review.dart';
import 'package:rush/core/domain/usecases/product/update_product.dart';

import 'product_provider_test.mocks.dart';

@GenerateMocks([
  GetListProduct,
  GetProduct,
  GetProductReview,
  AddProduct,
  UpdateProduct,
  DeleteProduct,
])
void main() {
  late MockGetListProduct mockGetListProduct;
  late MockGetProduct mockGetProduct;
  late MockGetProductReview mockGetProductReview;
  late MockAddProduct mockAddProduct;
  late MockUpdateProduct mockUpdateProduct;
  late MockDeleteProduct mockDeleteProduct;
  late ProductProvider productProvider;

  setUp(() {
    mockGetListProduct = MockGetListProduct();
    mockGetProduct = MockGetProduct();
    mockGetProductReview = MockGetProductReview();
    mockAddProduct = MockAddProduct();
    mockUpdateProduct = MockUpdateProduct();
    mockDeleteProduct = MockDeleteProduct();

    productProvider = ProductProvider(
      getListProduct: mockGetListProduct,
      getProduct: mockGetProduct,
      getProductReview: mockGetProductReview,
      addProduct: mockAddProduct,
      updateProduct: mockUpdateProduct,
      deleteProduct: mockDeleteProduct,
    );
  });

  test('Should load product list successfully', () async {
    final mockProduct = Product(
      productId: 'prod123',
      productName: 'Sample Product',
      productPrice: 100.0,
      productDescription: 'Sample Description',
      productImage: [],
      totalReviews: 10,
      rating: 4.5,
      stock: 100,
      isDeleted: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    when(mockGetListProduct.execute(search: '')).thenAnswer((_) async => [mockProduct]);

    await productProvider.loadListProduct();

    expect(productProvider.listProduct.length, 1);
    expect(productProvider.listProduct.first.productId, 'prod123');
    verify(mockGetListProduct.execute(search: '')).called(1);
  });

  test('Should load product details and reviews successfully', () async {
    final mockProduct = Product(
      productId: 'prod123',
      productName: 'Sample Product',
      productPrice: 100.0,
      productDescription: 'Sample Description',
      productImage: [],
      totalReviews: 10,
      rating: 4.5,
      stock: 100,
      isDeleted: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final mockReview = Review(
      reviewId: 'rev123',
      productId: 'prod123',
      product: mockProduct,
      accountId: 'user123',
      reviewerName: 'John Doe',
      star: 5,
      description: 'Excellent product!',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    when(mockGetProduct.execute(productId: 'prod123')).thenAnswer((_) async => mockProduct);
    when(mockGetProductReview.execute(productId: 'prod123')).thenAnswer((_) async => [mockReview]);

    await productProvider.loadDetailProduct(productId: 'prod123');

    expect(productProvider.detailProduct!.productId, 'prod123');
    expect(productProvider.listProductReview.first.reviewId, 'rev123');
    verify(mockGetProduct.execute(productId: 'prod123')).called(1);
    verify(mockGetProductReview.execute(productId: 'prod123')).called(1);
  });

  test('Should add a product successfully', () async {
    final mockProduct = Product(
      productId: 'prod123',
      productName: 'Sample Product',
      productPrice: 100.0,
      productDescription: 'Sample Description',
      productImage: [],
      totalReviews: 10,
      rating: 4.5,
      stock: 100,
      isDeleted: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    when(mockAddProduct.execute(data: mockProduct)).thenAnswer((_) async {});

    await productProvider.add(data: mockProduct);

    verify(mockAddProduct.execute(data: mockProduct)).called(1);
  });

  test('Should update a product successfully', () async {
    final mockProduct = Product(
      productId: 'prod123',
      productName: 'Updated Product',
      productPrice: 150.0,
      productDescription: 'Updated Description',
      productImage: [],
      totalReviews: 20,
      rating: 4.8,
      stock: 50,
      isDeleted: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    when(mockUpdateProduct.execute(data: mockProduct)).thenAnswer((_) async {});

    await productProvider.update(data: mockProduct);

    verify(mockUpdateProduct.execute(data: mockProduct)).called(1);
  });

  test('Should delete a product successfully', () async {
    when(mockDeleteProduct.execute(productId: 'prod123')).thenAnswer((_) async {});

    await productProvider.delete(productId: 'prod123');

    verify(mockDeleteProduct.execute(productId: 'prod123')).called(1);
  });
}
