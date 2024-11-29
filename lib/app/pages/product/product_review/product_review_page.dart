import 'package:rush/app/widgets/count_and_option.dart';
import 'package:rush/app/widgets/product_review_card.dart';
import 'package:rush/core/domain/entities/review/review.dart';
import 'package:flutter/material.dart';

import '../../../constants/order_by_value.dart';
import '../../../widgets/sort_filter_chip.dart';

class ProductReviewPage extends StatefulWidget {
  const ProductReviewPage({super.key});

  @override
  State<ProductReviewPage> createState() => _ProductReviewPageState();
}

class _ProductReviewPageState extends State<ProductReviewPage> {
  // Sort
  OrderByEnum orderByEnum = OrderByEnum.newest;
  List<OrderByEnum> dataEnum = [];

  @override
  void initState() {
    dataEnum.addAll(OrderByEnum.values);
    dataEnum.removeRange(2, 3);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Review> productReview = ModalRoute.of(context)!.settings.arguments as List<Review>;

    sortProductReview() {
      switch (orderByEnum) {
        case OrderByEnum.newest:
          productReview.sort(
            (a, b) => b.createdAt.compareTo(a.createdAt),
          );
          break;
        case OrderByEnum.oldest:
          productReview.sort(
            (a, b) => a.createdAt.compareTo(b.createdAt),
          );
          break;
        case OrderByEnum.leastStar:
          productReview.sort(
            (a, b) => b.star.compareTo(a.star),
          );
          break;
        case OrderByEnum.mostStar:
          productReview.sort(
            (a, b) => a.star.compareTo(b.star),
          );
          break;
        default:
          productReview.sort(
            (a, b) => b.createdAt.compareTo(a.createdAt),
          );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
      ),
      body: productReview.isEmpty
          ? Center(
              child: Text(
                'There are no reviews for this product yet',
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Count Reviews & Sort Reviews
                  CountAndOption(
                    count: productReview.length,
                    itemName: 'Reviews',
                    isSort: true,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return SortFilterChip(
                                dataEnum: dataEnum,
                                onSelected: (value) {
                                  setState(() {
                                    orderByEnum = value;
                                    sortProductReview();
                                  });
                                },
                                selectedEnum: orderByEnum,
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  ...productReview.map((e) => ProductReviewCard(item: e))
                ],
              ),
            ),
    );
  }
}
