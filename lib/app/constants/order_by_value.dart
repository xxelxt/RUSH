import 'package:rush/utils/extension.dart';

class OrderByValue {
  final String orderBy;
  final bool descending;

  OrderByValue({
    required this.orderBy,
    required this.descending,
  });
}

enum OrderByEnum {
  newest(0),
  oldest(1),
  cheapest(2),
  mostExpensive(3),
  leastStar(4),
  mostStar(5);

  final num value;
  const OrderByEnum(this.value);

  @override
  String toString() => name.capitalizeFirstLetter();
}

OrderByValue getEnumValue(OrderByEnum data) {
  switch (data) {
    case OrderByEnum.newest:
      return OrderByValue(orderBy: 'created_at', descending: true);
    case OrderByEnum.oldest:
      return OrderByValue(orderBy: 'created_at', descending: false);
    case OrderByEnum.cheapest:
      return OrderByValue(orderBy: 'product_price', descending: false);
    case OrderByEnum.mostExpensive:
      return OrderByValue(orderBy: 'product_price', descending: true);
    default:
      return OrderByValue(orderBy: 'created_at', descending: true);
  }
}
