## RUSH | Ứng dụng order cafe với Flutter

## Nhóm 11

- 📋 **Đề tài**: Xây dựng ứng dụng order cafe trên Flutter

- 💻 **Lớp học phần**: 241IS26A01

### 💐 Danh sách thành viên

| Họ và tên              | Mã sinh viên | 🔗 Link to GitHub profile                         |
| ---------------------- | ------------ | ------------------------------------------------- |
| Phạm Ngọc Nghiệp 🌟    | 24A4042603   | [xxelxt](https://github.com/xxelxt)               |
| Bùi Phương Linh        | 25A4041557   | [bphglinh374](https://github.com/bphglinh374)     |
| Lê Phương Linh         | 25A4041893   | [Bamboo-rat](https://github.com/Bamboo-rat)       |
| Đàm Thị Huyền Trang    | 25A4041962   | [Damhuyentrang](https://github.com/Damhuyentrang) |'

### 🚀 Giới thiệu tên gọi

*Bạn đã bao giờ vội vã để bắt kịp guồng quay công việc hay học tập mà không kịp lấy cho mình một cốc cafe tiếp năng lượng?*

**RUSH** là ứng dụng đặt và giao cafe được phát triển nhằm đáp ứng nhu cầu của những cá nhân bận rộn, đặc biệt trong guồng quay công việc và học tập hằng ngày. Tên gọi RUSH không chỉ gợi lên sự vội vã của những buổi sáng gấp gáp, mà còn thể hiện tốc độ trong việc phục vụ và giao hàng. Dù đang trên đường đến công sở, tại trường học hay làm việc tại nhà, RUSH sẽ nhanh chóng mang đến nguồn năng lượng cần thiết để bạn bắt đầu một ngày hứng khởi.

### ☕ Tính năng

- Project có **2 flavors**: 1 cho admin (**RUSH-ing**) và 1 cho user (**RUSH**)

<details>
<summary>Click để mở rộng</summary>

| **Tính năng**                                             | **admin** | **user** |
| --------------------------------------------------------- | --------- | -------- |
| Xem, tìm kiếm, sort sản phẩm                              | x         | x        |
| Thêm và chỉnh sửa sản phẩm                                | x         |          |
| Thêm sản phẩm vào wishlist (danh sách yêu thích)          |           | x        |
| Đặt hàng                                                  |           | x        |
| Duyệt và cập nhật trạng thái đơn hàng                     | x         |          |
| Xem, tìm kiếm, sort khách hàng                            | x         |          |
| Khoá tài khoản khách hàng                                 | x         |          |
| Chỉnh sửa thông tin tài khoản cá nhân                     | x         | x        |

</details>

### 🍵 Ứng dụng tham khảo

| Ứng dụng          | App Store                                                                | Google Play                                                                             |
| ----------------- | ------------------------------------------------------------------------ | --------------------------------------------------------------------------------------- |
| The Coffee House  | [Link](https://apps.apple.com/vn/app/the-coffee-house/id1138218678?l=vi) | [Link](https://play.google.com/store/apps/details?id=com.thecoffeehouse.guestapp&hl=vi) |
| Highlands         | [Link](https://apps.apple.com/vn/app/highlands-coffee/id1535599037?l=vi) | [Link](https://play.google.com/store/apps/details?id=com.vti.highlands&hl=vi)           |
| Starbucks Vietnam | [Link](https://apps.apple.com/vn/app/starbucks-vietnam/id1410451879)     | [Link](https://play.google.com/store/apps/details?id=com.starbucks.vn&hl=vi)            |

### 🥐 Package sử dụng

<details>
<summary>Click để mở rộng</summary>

| **Package**                     | **Version**    | **Mục đích sử dụng**                                               |
|----------------------------------|----------------|--------------------------------------------------------------------|
| `badges`                         | `^3.1.2`       | Hiển thị huy hiệu (badge) cho widget                               |
| `build_runner`                   | `^2.4.13`      | Tạo mã tự động (dùng với `json_serializable`)                      |
| `cached_network_image`           | `^3.3.1`       | Hiển thị hình ảnh từ mạng với bộ nhớ đệm                           |
| `cloud_firestore`                | `^4.16.0`      | Tương tác với Firestore Database                                   |
| `cloudinary_flutter`             | `^1.3.0`       | Tương tác với Cloudinary để quản lý và xử lý ảnh/video             |
| `cloudinary_url_gen`             | `^1.6.0`       | Tạo URL động để quản lý hình ảnh và video trên Cloudinary          |
| `equatable`                      | `^2.0.5`       | So sánh các đối tượng (sử dụng trong state management)             |
| `firebase_auth`                  | `^4.19.0`      | Cung cấp các chức năng authenticate cho người dùng Firebase        |
| `firebase_auth_mocks`            | `^0.13.0`      | Mô phỏng các chức năng firebase_auth trong kiểm thử                |
| `firebase_core`                  | `^2.28.0`      | Cấu hình Firebase cơ bản                                           |
| `firebase_database_mocks`        | `^0.6.1`       | Mô phỏng Firebase Database trong kiểm thử                          |
| `flutter_image_compress`         | `^2.2.0`       | Nén hình ảnh để giảm kích thước tệp                                |
| `flutter_launcher_icons`         | `^0.13.1`      | Tạo icon cho ứng dụng Flutter                                      |
| `flutter_lints`                  | `^3.0.2`       | Cung cấp bộ quy tắc lint cho mã nguồn Flutter                      |
| ~~`firebase_storage`~~           | ~~`^11.7.0`~~  | ~~Lưu trữ và quản lý các tệp trong Firebase Storage~~              |
| `flutter_map`                    | `^5.0.0`       | Hiển thị bản đồ trong ứng dụng Flutter                             |
| `flutter_native_splash`          | `^2.4.3`       | Tạo splash screen cho ứng dụng Flutter                             |
| `flutter_svg`                    | `^2.0.10+1`    | Hiển thị các tệp SVG                                               |
| `get_it`                         | `^7.6.8`       | Dependency injection và state management                           |
| `geocoding`                      | `^3.0.0`       | Dịch mã địa lý thành thông tin địa chỉ                             |
| `geolocator`                     | `^12.0.0`      | Xác định vị trí địa lý của thiết bị                                |
| `google_fonts`                   | `^6.2.1`       | Sử dụng các font chữ từ Google Fonts                               |
| `http`                           | `^1.1.0`       | Gửi và nhận các yêu cầu HTTP                                       |
| `image_picker`                   | `^1.0.7`       | Chọn ảnh từ thư viện/chụp ảnh bằng camera                          |
| `intl`                           | `^0.19.0`      | Xử lý định dạng số, ngày giờ và quốc tế hóa                        |
| `json_annotation`                | `^4.8.1`       | Chú thích dữ liệu JSON cho các lớp Dart                            |
| `json_serializable`              | `^6.7.1`       | Tự động tạo mã để chuyển đổi giữa đối tượng Dart và JSON           |
| `latlong2`                       | `^0.9.1`       | Hỗ trợ làm việc với tọa độ địa lý                                  |
| `mockito`                        | `^5.4.4`       | Thư viện mô phỏng trong kiểm thử                                   |
| `provider`                       | `^6.1.2`       | Quản lý trạng thái (State management)                              |
| `shared_preferences`             | `^2.2.2`       | Lưu trữ và truy xuất dữ liệu đơn giản trên thiết bị                |
| `timeago`                        | `^3.6.1`       | Hiển thị thời gian tương đối (*ex: "3 giờ trước"*)                 |
| `url_launcher`                   | `^6.2.5`       | Mở URL, email hoặc số điện thoại trên ứng dụng khác                |

</details>
