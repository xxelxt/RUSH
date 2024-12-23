import 'package:rush/utils/extension.dart';

// Chứa thông tin về tiêu chí sắp xếp
class OrderByValue {
  final String orderBy; // Tên trường được sử dụng để sắp xếp (VD: created_at, product_price)
  final bool descending; // Thứ tự sắp xếp: true = giảm dần, false = tăng dần

  // Constructor bắt buộc truyền vào các tham số orderBy và descending
  OrderByValue({
    required this.orderBy,
    required this.descending,
  });
}

// enum để liệt kê các tiêu chí sắp xếp
enum OrderByEnum {
  newest(0),
  oldest(1),
  cheapest(2),
  mostExpensive(3),
  leastStar(4),
  mostStar(5);

  final num value;
  const OrderByEnum(this.value);

  // Ghi đè phương thức toString để trả về tên enum với chuỗi tùy chỉnh
  @override
  String toString() {
    switch (this) {
      case OrderByEnum.newest:
        return 'Thêm vào mới nhất';
      case OrderByEnum.oldest:
        return 'Thêm vào lâu nhất';
      case OrderByEnum.cheapest:
        return 'Mức giá thấp nhất';
      case OrderByEnum.mostExpensive:
        return 'Mức giá cao nhất';
      case OrderByEnum.leastStar:
        return 'Đánh giá thấp nhất';
      case OrderByEnum.mostStar:
        return 'Đánh giá cao nhất';
      default:
        return 'Không xác định';
    }
  }
}

// Hàm chuyển đổi từ OrderByEnum sang đối tượng OrderByValue
OrderByValue getEnumValue(OrderByEnum data) {
  switch (data) {
    case OrderByEnum.newest: // Nếu là newest
      return OrderByValue(orderBy: 'created_at', descending: true); // Sắp xếp theo created_at giảm dần
    case OrderByEnum.oldest:
      return OrderByValue(orderBy: 'created_at', descending: false);
    case OrderByEnum.cheapest:
      return OrderByValue(orderBy: 'product_price', descending: false);
    case OrderByEnum.mostExpensive:
      return OrderByValue(orderBy: 'product_price', descending: true);
    default:
      return OrderByValue(orderBy: 'created_at', descending: true); // Mặc định sắp xếp created_at giảm dần
  }
}