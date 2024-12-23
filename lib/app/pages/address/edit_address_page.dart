import 'package:rush/app/constants/validation_type.dart';
import 'package:rush/app/providers/address_provider.dart';
import 'package:rush/app/widgets/error_banner.dart';
import 'package:rush/core/domain/entities/address/address.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class EditAddressPage extends StatefulWidget {
  const EditAddressPage({super.key});

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  // Lưu trữ địa chỉ cần chỉnh sửa
  late Address address;

  final MapController _mapController = MapController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // TextEditingController
  final TextEditingController _txtName = TextEditingController();
  final TextEditingController _txtAddress = TextEditingController();
  final TextEditingController _txtCity = TextEditingController();
  final TextEditingController _txtZipCode = TextEditingController();

  // FocusNode để quản lý focus trên các trường input
  final FocusNode _fnName = FocusNode();
  final FocusNode _fnAddress = FocusNode();
  final FocusNode _fnCity = FocusNode();
  final FocusNode _fnZipCode = FocusNode();

  // ValidationType instance để xác thực dữ liệu
  ValidationType validation = ValidationType.instance;

  bool _isLoading = false;

  // Vị trí mặc định: Hà Nội
  LatLng _mapCenter = LatLng(21.028511, 105.804817);

  final String _mapTilerApiKey = 'WHQXRA9ToOKpbxjiRCmu';

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Kiểm tra dịch vụ GPS đã bật chưa
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showPermissionDialog(
        title: 'Dịch vụ vị trí bị tắt',
        content: 'Vui lòng bật dịch vụ vị trí trên thiết bị của bạn để sử dụng chức năng này.',
      );
      return;
    }

    // Kiểm tra quyền truy cập vị trí
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showPermissionDialog(
          title: 'Quyền vị trí bị từ chối',
          content: 'Ứng dụng cần quyền truy cập vị trí để hiển thị vị trí hiện tại của bạn.',
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showPermissionDialog(
        title: 'Quyền vị trí bị từ chối vĩnh viễn',
        content: 'Vui lòng cấp quyền vị trí trong cài đặt thiết bị để sử dụng chức năng này.',
      );
      return;
    }

    // Lấy vị trí hiện tại
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _mapCenter = LatLng(position.latitude, position.longitude);
        _mapController.move(_mapCenter, 15.0); // Di chuyển bản đồ đến vị trí mới
      });

      // Lấy thông tin địa chỉ từ tọa độ
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        // Điền dữ liệu vào các trường nhập
        setState(() {
          _txtAddress.text = place.street ?? ''; // Đường
          _txtCity.text = place.locality ?? place.administrativeArea ?? place.subAdministrativeArea ?? ''; // Thành phố
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã cập nhật vị trí hiện tại.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể lấy vị trí: $e')),
      );
    }
  }

  void _showPermissionDialog({required String title, required String content}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Đóng'),
            ),
            if (title == 'Quyền vị trí bị từ chối vĩnh viễn')
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Geolocator.openAppSettings();
                },
                child: const Text('Cài đặt'),
              ),
          ],
        );
      },
    );
  }

  void _updateMapLocation() async {
    final String fullAddress = "${_txtAddress.text}, ${_txtCity.text}";
    if (fullAddress.trim().isEmpty) {
      return;
    }

    try {
      // Sử dụng Geocoding API để lấy tọa độ từ địa chỉ
      List<Location> locations = await locationFromAddress(fullAddress);
      if (locations.isNotEmpty) {
        final Location location = locations.first;
        setState(() {
          _mapCenter = LatLng(location.latitude, location.longitude);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không tìm thấy vị trí.')),
        );
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Không thể tìm thấy vị trí.')),
      // );
    }
  }

  @override
  void initState() {
    // Lấy dữ liệu địa chỉ từ tham số truyền vào khi mở trang
    Future.microtask(() {
      address = ModalRoute.of(context)!.settings.arguments as Address;

      // Gán giá trị ban đầu cho các trường nhập
      _txtName.text = address.name;
      _txtAddress.text = address.address;
      _txtCity.text = address.city;
      _txtZipCode.text = address.zipCode;

      _updateMapLocation();
    });
    super.initState();
  }

  // Giải phóng bộ nhớ
  @override
  void dispose() {
    _txtName.dispose();
    _txtAddress.dispose();
    _txtCity.dispose();
    _txtZipCode.dispose();

    _fnName.dispose();
    _fnAddress.dispose();
    _fnCity.dispose();
    _fnZipCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cập nhật địa chỉ'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Form nhập địa chỉ
          Expanded(
            child: Form(
              key: _formKey, // Gắn form key để kiểm tra validation
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _txtName,
                      focusNode: _fnName,
                      validator: validation.emptyValidation,
                      keyboardType: TextInputType.name,
                      onFieldSubmitted: (value) =>
                          FocusScope.of(context).requestFocus(_fnAddress), // Chuyển focus
                      decoration: const InputDecoration(
                        hintText: 'Nhập loại địa chỉ của bạn (vd: Nhà riêng)',
                        labelText: 'Loại địa chỉ',
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _txtAddress,
                      focusNode: _fnAddress,
                      validator: validation.emptyValidation,
                      keyboardType: TextInputType.streetAddress,
                      minLines: 2,
                      maxLines: 10,
                      onFieldSubmitted: (value) =>
                          FocusScope.of(context).requestFocus(_fnCity),
                      decoration: const InputDecoration(
                        hintText: 'Nhập địa chỉ của bạn',
                        labelText: 'Địa chỉ',
                      ),
                      onChanged: (_) => _updateMapLocation(),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _txtCity,
                      focusNode: _fnCity,
                      validator: validation.emptyValidation,
                      keyboardType: TextInputType.text,
                      onFieldSubmitted: (value) =>
                          FocusScope.of(context).requestFocus(_fnZipCode),
                      decoration: const InputDecoration(
                        hintText: 'Nhập tỉnh/thành phố',
                        labelText: 'Tỉnh/thành phố',
                      ),
                      onChanged: (_) => _updateMapLocation(),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _txtZipCode,
                      focusNode: _fnZipCode,
                      validator: validation.emptyValidation,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onFieldSubmitted: (value) =>
                          FocusScope.of(context).unfocus(), // Bỏ focus khi nhập xong
                      decoration: const InputDecoration(
                        hintText: 'Nhập mã ZIP',
                        labelText: 'Mã ZIP',
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextButton.icon(
                      onPressed: _getCurrentLocation,
                      icon: const Icon(Icons.my_location),
                      label: const Text('Sử dụng vị trí hiện tại'),
                    ),
                    const SizedBox(height: 8),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(8), // Bo tròn góc
                      child: SizedBox(
                        height: 300, // Chiều cao cố định
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: FlutterMap(
                            mapController: _mapController, // Truyền MapController vào đây
                            options: MapOptions(
                              center: _mapCenter,
                              zoom: 15.0,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                "https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=$_mapTilerApiKey",
                                additionalOptions: {
                                  'key': _mapTilerApiKey,
                                },
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: _mapCenter,
                                    builder: (ctx) => const Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Nút cập nhật địa chỉ
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Consumer<AddressProvider>( // Sử dụng Provider để quản lý trạng thái địa chỉ
              builder: (context, value, child) {
                // Hiển thị ProgressIndicator nếu đang tải
                if (_isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ElevatedButton(
                  child: const Text('Cập nhật'),
                  onPressed: () async {
                    FocusScope.of(context).unfocus(); // Ẩn bàn phím

                    // Kiểm tra form hợp lệ và không đang tải
                    if (_formKey.currentState!.validate() && !_isLoading) {
                      try {
                        setState(() {
                          _isLoading = true; // Chuyển trạng thái loading
                        });

                        ScaffoldMessenger.of(context).removeCurrentMaterialBanner();

                        // Tạo đối tượng Address với dữ liệu mới
                        Address data = Address(
                          addressId: address.addressId, // Giữ nguyên ID địa chỉ
                          name: _txtName.text,
                          address: _txtAddress.text,
                          city: _txtCity.text,
                          zipCode: _txtZipCode.text,
                          createdAt: address.createdAt, // Giữ nguyên thời gian tạo
                          updatedAt: DateTime.now(), // Cập nhật thời gian chỉnh sửa
                        );

                        String accountId = FirebaseAuth.instance.currentUser!.uid; // Lấy ID người dùng hiện tại

                        // Cập nhật địa chỉ qua Provider
                        await value.update(accountId: accountId, data: data).whenComplete(() {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Cập nhật địa chỉ thành công'),
                            ),
                          );
                          value.getAddress(accountId: accountId); // Cập nhật danh sách địa chỉ
                        });
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
                          ScaffoldMessenger.of(context).showMaterialBanner(
                            errorBanner(context: context, msg: e.toString()),
                          );
                        }
                        setState(() {
                          _isLoading = false; // Kết thúc trạng thái loading
                        });
                      }
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
