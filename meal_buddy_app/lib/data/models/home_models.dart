import 'package:get/get.dart';

class MealBuddyItem {
  final int postId;
  final String title;
  final String content;
  final String place;
  final String menu;
  final String time;
  final String foodType;
  RxBool isFavorite;

  // 작성자 정보
  final int userId;
  final String authorName;
  final int authorAge;
  final String authorGender;
  final String? authorProfileImage;

  MealBuddyItem({
    required this.postId,
    required this.title,
    required this.content,
    required this.place,
    required this.menu,
    required this.time,
    required this.foodType,
    required this.userId,
    required this.authorName,
    required this.authorAge,
    required this.authorGender,
    this.authorProfileImage,
    bool favorite = false,
  }) : isFavorite = favorite.obs;
}
