import 'package:rush/app/widgets/count_and_option.dart'; // Widget hiển thị số lượng và tuỳ chọn
import 'package:rush/app/widgets/product_review_card.dart'; // Widget hiển thị thẻ đánh giá sản phẩm
import 'package:rush/core/domain/entities/review/review.dart'; // Mô hình dữ liệu đánh giá
import 'package:flutter/material.dart';

import '../../../constants/order_by_value.dart'; // Enum dùng để sắp xếp
import '../../../widgets/sort_filter_chip.dart'; // Widget cho phép chọn bộ lọc và sắp xếp

// Trang hiển thị danh sách đánh giá sản phẩm
class ProductReviewPage extends StatefulWidget {
  const ProductReviewPage({super.key});

  @override
  State<ProductReviewPage> createState() => _ProductReviewPageState();
}

class _ProductReviewPageState extends State<ProductReviewPage> {
  // Biến lưu trạng thái sắp xếp
  OrderByEnum orderByEnum = OrderByEnum.newest;

  // Danh sách các giá trị enum dùng để sắp xếp
  List<OrderByEnum> dataEnum = [];

  @override
  void initState() {
    // Khởi tạo các tuỳ chọn sắp xếp
    dataEnum.addAll(OrderByEnum.values); // Lấy tất cả giá trị từ enum
    dataEnum.removeRange(2, 3); // Loại bỏ giá trị thứ 3 (index 2)
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Nhận danh sách đánh giá từ tham số truyền vào
    final List<Review> productReview = ModalRoute.of(context)!.settings.arguments as List<Review>;

    // Hàm sắp xếp danh sách đánh giá dựa vào lựa chọn
    sortProductReview() {
      switch (orderByEnum) {
        case OrderByEnum.newest: // Sắp xếp từ mới nhất
          productReview.sort(
                (a, b) => b.createdAt.compareTo(a.createdAt),
          );
          break;
        case OrderByEnum.oldest: // Sắp xếp từ cũ nhất
          productReview.sort(
                (a, b) => a.createdAt.compareTo(b.createdAt),
          );
          break;
        case OrderByEnum.leastStar: // Sắp xếp theo đánh giá thấp nhất
          productReview.sort(
                (a, b) => b.star.compareTo(a.star),
          );
          break;
        case OrderByEnum.mostStar: // Sắp xếp theo đánh giá cao nhất
          productReview.sort(
                (a, b) => a.star.compareTo(b.star),
          );
          break;
        default: // Mặc định sắp xếp từ mới nhất
          productReview.sort(
                (a, b) => b.createdAt.compareTo(a.createdAt),
          );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đánh giá'), // Tiêu đề trang
      ),
      body: productReview.isEmpty
          ? Center(
        child: Text(
          'Chưa có đánh giá cho sản phẩm này', // Hiển thị thông báo nếu không có đánh giá
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Căn chỉnh nội dung sang trái
          children: [
            // Hiển thị số lượng đánh giá và tuỳ chọn sắp xếp
            CountAndOption(
              count: productReview.length,
              itemName: 'đánh giá',
              isSort: true,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return SortFilterChip(
                          dataEnum: dataEnum, // Danh sách giá trị sắp xếp
                          onSelected: (value) {
                            setState(() {
                              orderByEnum = value; // Cập nhật trạng thái sắp xếp
                              sortProductReview(); // Gọi hàm sắp xếp
                            });
                          },
                          selectedEnum: orderByEnum, // Giá trị sắp xếp hiện tại
                        );
                      },
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            // Hiển thị danh sách đánh giá
            ...productReview.map((e) => ProductReviewCard(item: e))
          ],
        ),
      ),
    );
  }
}
