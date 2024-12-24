import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rush/app/providers/address_provider.dart';
import 'package:rush/core/domain/entities/address/address.dart';
import 'package:rush/core/domain/usecases/address/add_address.dart';
import 'package:rush/core/domain/usecases/address/change_primary_address.dart';
import 'package:rush/core/domain/usecases/address/delete_address.dart';
import 'package:rush/core/domain/usecases/address/get_account_address.dart';
import 'package:rush/core/domain/usecases/address/update_address.dart';

// Generate mock classes
@GenerateMocks([
  AddAddress,
  GetAccountAddress,
  UpdateAddress,
  DeleteAddress,
  ChangePrimaryAddress,
])
import 'address_provider_test.mocks.dart'; // Import file mock được tự động tạo

void main() {
  // Các mock use case
  late MockAddAddress mockAddAddress;
  late MockGetAccountAddress mockGetAccountAddress;
  late MockUpdateAddress mockUpdateAddress;
  late MockDeleteAddress mockDeleteAddress;
  late MockChangePrimaryAddress mockChangePrimaryAddress;

  // AddressProvider cần kiểm tra
  late AddressProvider addressProvider;

  setUp(() {
    // Khởi tạo mock
    mockAddAddress = MockAddAddress();
    mockGetAccountAddress = MockGetAccountAddress();
    mockUpdateAddress = MockUpdateAddress();
    mockDeleteAddress = MockDeleteAddress();
    mockChangePrimaryAddress = MockChangePrimaryAddress();

    // Tạo instance AddressProvider với mock
    addressProvider = AddressProvider(
      addAddress: mockAddAddress,
      getAccountAddress: mockGetAccountAddress,
      updateAddress: mockUpdateAddress,
      deleteAddress: mockDeleteAddress,
      changePrimaryAddress: mockChangePrimaryAddress,
    );
  });

  group('AddressProvider Tests', () {
    test('Initial state should be loading and empty list', () {
      expect(addressProvider.isLoading, true);
      expect(addressProvider.listAddress, []);
    });

    test('Should add a new address successfully', () async {
      // Mock dữ liệu
      final accountId = 'user123';
      final newAddress = Address(
        addressId: 'address1',
        name: 'Home',
        address: '123 Street',
        city: 'Cityville',
        zipCode: '12345',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Khi thực hiện addAddress, không làm gì thêm
      when(mockAddAddress.execute(accountId: accountId, data: newAddress))
          .thenAnswer((_) async {});

      // Gọi hàm add
      await addressProvider.add(accountId: accountId, data: newAddress);

      // Kiểm tra danh sách địa chỉ có địa chỉ mới
      expect(addressProvider.listAddress, contains(newAddress));
      expect(addressProvider.isLoading, false);

      // Đảm bảo hàm use case được gọi chính xác
      verify(mockAddAddress.execute(accountId: accountId, data: newAddress))
          .called(1);
    });

    test('Should fetch addresses successfully', () async {
      // Mock dữ liệu trả về
      final accountId = 'user123';
      final addresses = [
        Address(
          addressId: 'address1',
          name: 'Home',
          address: '123 Street',
          city: 'Cityville',
          zipCode: '12345',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Address(
          addressId: 'address2',
          name: 'Office',
          address: '456 Avenue',
          city: 'Townsville',
          zipCode: '67890',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      // Khi gọi getAccountAddress, trả về danh sách địa chỉ
      when(mockGetAccountAddress.execute(accountId: accountId))
          .thenAnswer((_) async => addresses);

      // Gọi hàm getAddress
      await addressProvider.getAddress(accountId: accountId);

      // Kiểm tra danh sách địa chỉ được cập nhật
      expect(addressProvider.listAddress, addresses);
      expect(addressProvider.isLoading, false);

      // Đảm bảo hàm use case được gọi chính xác
      verify(mockGetAccountAddress.execute(accountId: accountId)).called(1);
    });

    test('Should delete address successfully', () async {
      // Mock dữ liệu
      final accountId = 'user123';
      final addressToDelete = Address(
        addressId: 'address1',
        name: 'Home',
        address: '123 Street',
        city: 'Cityville',
        zipCode: '12345',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      addressProvider.listAddress.add(addressToDelete);

      // Khi gọi deleteAddress, không làm gì thêm
      when(mockDeleteAddress.execute(accountId: accountId, addressId: 'address1'))
          .thenAnswer((_) async {});

      // Gọi hàm delete
      await addressProvider.delete(accountId: accountId, addressId: 'address1');

      // Kiểm tra danh sách địa chỉ không còn địa chỉ đã xoá
      expect(addressProvider.listAddress, isEmpty);

      // Đảm bảo hàm use case được gọi chính xác
      verify(mockDeleteAddress.execute(accountId: accountId, addressId: 'address1'))
          .called(1);
    });

    test('Should change primary address successfully', () async {
      // Mock dữ liệu
      final accountId = 'user123';
      final newPrimaryAddress = Address(
        addressId: 'address2',
        name: 'Office',
        address: '456 Avenue',
        city: 'Townsville',
        zipCode: '67890',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Khi gọi changePrimaryAddress, không làm gì thêm
      when(mockChangePrimaryAddress.execute(accountId: accountId, data: newPrimaryAddress))
          .thenAnswer((_) async {});

      // Gọi hàm changePrimary
      await addressProvider.changePrimary(
        accountId: accountId,
        data: newPrimaryAddress,
        oldData: null,
      );

      // Đảm bảo hàm use case được gọi chính xác
      verify(mockChangePrimaryAddress.execute(accountId: accountId, data: newPrimaryAddress))
          .called(1);
    });
  });
}
