import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rush/app/providers/payment_method_provider.dart';
import 'package:rush/core/domain/entities/payment_method/payment_method.dart';
import 'package:rush/core/domain/usecases/payment_method/add_payment_method.dart';
import 'package:rush/core/domain/usecases/payment_method/change_primary_payment_method.dart';
import 'package:rush/core/domain/usecases/payment_method/delete_payment_method.dart';
import 'package:rush/core/domain/usecases/payment_method/get_account_payment_method.dart';
import 'package:rush/core/domain/usecases/payment_method/update_payment_method.dart';

// Generate mock classes
@GenerateMocks([
  AddPaymentMethod,
  GetAccountPaymentMethod,
  UpdatePaymentMethod,
  DeletePaymentMethod,
  ChangePrimaryPaymentMethod,
])
import 'payment_method_provider_test.mocks.dart'; // Import file mock tự động

void main() {
  // Mock các use case
  late MockAddPaymentMethod mockAddPaymentMethod;
  late MockGetAccountPaymentMethod mockGetAccountPaymentMethod;
  late MockUpdatePaymentMethod mockUpdatePaymentMethod;
  late MockDeletePaymentMethod mockDeletePaymentMethod;
  late MockChangePrimaryPaymentMethod mockChangePrimaryPaymentMethod;

  // PaymentMethodProvider cần kiểm tra
  late PaymentMethodProvider paymentMethodProvider;

  setUp(() {
    // Khởi tạo mock
    mockAddPaymentMethod = MockAddPaymentMethod();
    mockGetAccountPaymentMethod = MockGetAccountPaymentMethod();
    mockUpdatePaymentMethod = MockUpdatePaymentMethod();
    mockDeletePaymentMethod = MockDeletePaymentMethod();
    mockChangePrimaryPaymentMethod = MockChangePrimaryPaymentMethod();

    // Tạo instance PaymentMethodProvider với mock
    paymentMethodProvider = PaymentMethodProvider(
      addPaymentMethod: mockAddPaymentMethod,
      getAccountPaymentMethod: mockGetAccountPaymentMethod,
      updatePaymentMethod: mockUpdatePaymentMethod,
      deletePaymentMethod: mockDeletePaymentMethod,
      changePrimaryPaymentMethod: mockChangePrimaryPaymentMethod,
    );
  });

  group('PaymentMethodProvider Tests', () {
    test('Initial state should be loading and empty list', () {
      expect(paymentMethodProvider.isLoading, false);
      expect(paymentMethodProvider.listPaymentMethod, []);
    });

    test('Should add a new payment method successfully', () async {
      // Mock dữ liệu
      final accountId = 'user123';
      final newPaymentMethod = PaymentMethod(
        paymentMethodId: 'pm1',
        cardNumber: '1234 5678 1234 5678',
        cardholderName: 'John Doe',
        expiryDate: '12/25',
        cvv: '123',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Khi thực hiện addPaymentMethod, không làm gì thêm
      when(mockAddPaymentMethod.execute(accountId: accountId, data: newPaymentMethod))
          .thenAnswer((_) async {});

      // Gọi hàm add
      await paymentMethodProvider.add(accountId: accountId, data: newPaymentMethod);

      // Kiểm tra danh sách có chứa phương thức thanh toán mới
      expect(paymentMethodProvider.listPaymentMethod, contains(newPaymentMethod));
      expect(paymentMethodProvider.isLoading, false);

      // Đảm bảo use case được gọi đúng
      verify(mockAddPaymentMethod.execute(accountId: accountId, data: newPaymentMethod)).called(1);
    });

    test('Should fetch payment methods successfully', () async {
      // Mock dữ liệu trả về
      final accountId = 'user123';
      final paymentMethods = [
        PaymentMethod(
          paymentMethodId: 'pm1',
          cardNumber: '1234 5678 1234 5678',
          cardholderName: 'John Doe',
          expiryDate: '12/25',
          cvv: '123',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        PaymentMethod(
          paymentMethodId: 'pm2',
          cardNumber: '5678 1234 5678 1234',
          cardholderName: 'Jane Doe',
          expiryDate: '01/26',
          cvv: '456',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      // Khi gọi getAccountPaymentMethod, trả về danh sách phương thức thanh toán
      when(mockGetAccountPaymentMethod.execute(accountId: accountId))
          .thenAnswer((_) async => paymentMethods);

      // Gọi hàm getPaymentMethod
      await paymentMethodProvider.getPaymentMethod(accountId: accountId);

      // Kiểm tra danh sách được cập nhật
      expect(paymentMethodProvider.listPaymentMethod, paymentMethods);
      expect(paymentMethodProvider.isLoading, false);

      // Đảm bảo use case được gọi đúng
      verify(mockGetAccountPaymentMethod.execute(accountId: accountId)).called(1);
    });

    test('Should update a payment method successfully', () async {
      // Mock dữ liệu
      final accountId = 'user123';
      final oldPaymentMethod = PaymentMethod(
        paymentMethodId: 'pm1',
        cardNumber: '1234 5678 1234 5678',
        cardholderName: 'John Doe',
        expiryDate: '12/25',
        cvv: '123',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final updatedPaymentMethod = PaymentMethod(
        paymentMethodId: 'pm1',
        cardNumber: '5678 1234 5678 1234',
        cardholderName: 'Updated John Doe',
        expiryDate: '01/26',
        cvv: '456',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      paymentMethodProvider.listPaymentMethod.add(oldPaymentMethod);

      // Khi gọi updatePaymentMethod, không làm gì thêm
      when(mockUpdatePaymentMethod.execute(accountId: accountId, data: updatedPaymentMethod))
          .thenAnswer((_) async {});

      // Gọi hàm update
      await paymentMethodProvider.update(accountId: accountId, data: updatedPaymentMethod);

      // Kiểm tra phương thức thanh toán đã được cập nhật
      expect(
        paymentMethodProvider.listPaymentMethod
            .any((element) => element.cardholderName == 'Updated John Doe'),
        true,
      );

      // Đảm bảo use case được gọi đúng
      verify(mockUpdatePaymentMethod.execute(accountId: accountId, data: updatedPaymentMethod))
          .called(1);
    });

    test('Should delete a payment method successfully', () async {
      // Mock dữ liệu
      final accountId = 'user123';
      final paymentMethodToDelete = PaymentMethod(
        paymentMethodId: 'pm1',
        cardNumber: '1234 5678 1234 5678',
        cardholderName: 'John Doe',
        expiryDate: '12/25',
        cvv: '123',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      paymentMethodProvider.listPaymentMethod.add(paymentMethodToDelete);

      // Khi gọi deletePaymentMethod, không làm gì thêm
      when(mockDeletePaymentMethod.execute(accountId: accountId, paymentMethodId: 'pm1'))
          .thenAnswer((_) async {});

      // Gọi hàm delete
      await paymentMethodProvider.delete(accountId: accountId, paymentMethodId: 'pm1');

      // Kiểm tra danh sách không còn phương thức thanh toán đã xoá
      expect(paymentMethodProvider.listPaymentMethod, isEmpty);

      // Đảm bảo use case được gọi đúng
      verify(mockDeletePaymentMethod.execute(accountId: accountId, paymentMethodId: 'pm1')).called(1);
    });

    test('Should change primary payment method successfully', () async {
      // Mock dữ liệu
      final accountId = 'user123';
      final newPrimaryPaymentMethod = PaymentMethod(
        paymentMethodId: 'pm2',
        cardNumber: '5678 1234 5678 1234',
        cardholderName: 'Jane Doe',
        expiryDate: '01/26',
        cvv: '456',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Khi gọi changePrimaryPaymentMethod, không làm gì thêm
      when(mockChangePrimaryPaymentMethod.execute(
          accountId: accountId, paymentMethod: newPrimaryPaymentMethod))
          .thenAnswer((_) async {});

      // Gọi hàm changePrimary
      await paymentMethodProvider.changePrimary(
        accountId: accountId,
        data: newPrimaryPaymentMethod,
        oldData: null,
      );

      // Đảm bảo use case được gọi đúng
      verify(mockChangePrimaryPaymentMethod.execute(
          accountId: accountId, paymentMethod: newPrimaryPaymentMethod))
          .called(1);
    });
  });
}
