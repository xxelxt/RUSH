import 'package:rush/app/providers/account_provider.dart';
import 'package:rush/app/providers/address_provider.dart';
import 'package:rush/app/widgets/radio_card.dart';
import 'package:rush/core/domain/entities/address/address.dart';
import 'package:rush/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageAddressPage extends StatefulWidget {
  const ManageAddressPage({super.key});

  @override
  State<ManageAddressPage> createState() => _ManageAddressPageState();
}

class _ManageAddressPageState extends State<ManageAddressPage> {
  bool returnAddress = false;

  String accountId = FirebaseAuth.instance.currentUser!.uid;

  Address? selectedAddress;

  bool _isLoading = false;

  @override
  void initState() {
    Future.microtask(
          () {
        // Lấy tham số truyền vào (có trả về địa chỉ không)
        returnAddress = ModalRoute.of(context)!.settings.arguments as bool;

        // Lấy địa chỉ mặc định từ tài khoản
        selectedAddress = context.read<AccountProvider>().account.primaryAddress;

        // Lấy danh sách địa chỉ từ AddressProvider
        context.read<AddressProvider>().getAddress(accountId: accountId);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách địa chỉ'),
        actions: [
          // Nút thêm địa chỉ mới
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(RouteName.kAddAddress);
            },
            child: const Text('Thêm địa chỉ'),
          ),
        ],
      ),

      body: Consumer<AddressProvider>(
        builder: (context, value, child) {
          // Hiển thị vòng tròn loading nếu đang tải danh sách địa chỉ
          if (value.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    children: [

                      // Nếu không có địa chỉ, hiển thị thông báo
                      if (value.listAddress.isEmpty)
                        Center(
                          child: Text(
                            'Không có địa chỉ nào\nVui lòng thêm địa chỉ để chúng mình có thể ship hàng đến cho bạn nhé!',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),

                      // Nếu có địa chỉ, hiển thị danh sách
                      if (value.listAddress.isNotEmpty)
                        ...value.listAddress.map(
                              (e) => Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: RadioCard<Address>(
                              title: e.name,
                              subtitle: '${e.address} ${e.city} ${e.zipCode}',
                              value: e, // Giá trị của radio button
                              selectedValue: selectedAddress,
                              onChanged: (value) {
                                setState(() {
                                  selectedAddress = value; // Cập nhật địa chỉ được chọn
                                });
                              },
                              onDelete: () {
                                value.delete(accountId: accountId, addressId: e.addressId);

                                // Nếu địa chỉ mặc định bị xóa, đặt lại thành null
                                if (selectedAddress == e) {
                                  selectedAddress = null;
                                  context.read<AccountProvider>().update(data: {
                                    'primary_address': null,
                                  });
                                }
                              },
                              onEdit: () {
                                NavigateRoute.toEditAddress(context: context, address: e);
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Nút hành động
              if (value.listAddress.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: ElevatedButton(
                    onPressed: selectedAddress == null
                        ? null // Vô hiệu hóa nút nếu không có địa chỉ được chọn
                        : () async {
                      if (_isLoading) return;

                      // Nếu cần trả về địa chỉ, đóng màn hình và trả về địa chỉ được chọn
                      if (returnAddress) {
                        Navigator.of(context).pop(selectedAddress);
                        return;
                      }

                      setState(() {
                        _isLoading = true; // Bắt đầu trạng thái loading
                      });

                      Address? oldData = context.read<AccountProvider>().account.primaryAddress;
                      await value.changePrimary(
                        accountId: accountId,
                        data: selectedAddress!,
                        oldData: oldData,
                      ).whenComplete(() async {
                        context.read<AccountProvider>().getProfile(); // Cập nhật hồ sơ tài khoản
                        setState(() {
                          _isLoading = false; // Kết thúc trạng thái loading
                        });
                        Navigator.of(context).pop();
                      });
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
                        : returnAddress
                        ? const Text('Chọn địa chỉ')
                        : const Text('Đặt làm mặc định'),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
