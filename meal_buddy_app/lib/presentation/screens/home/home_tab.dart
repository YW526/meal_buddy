import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/friendship_controller.dart';
import 'food/food_screen.dart';
import '../home/feed.dart';

class HomeTab extends GetView<HomeController> {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.mealbuddyList.isEmpty) {
          return const Center(child: Text('등록된 밥친구 게시글이 없습니다.'));
        }

        return Column(
          children: [
            _divider(),

            // 메뉴 추천
            _menuRecommendCard(),

            _divider(),
            const SizedBox(height: 10),

            // 현재 위치 + 로고 Row
            _locationArea(),

            _divider(),
            const SizedBox(height: 10),

            // 카테고리
            _categorySelector(),

            // 게시글 리스트
            Expanded(child: _mealList()),
          ],
        );
      }),
    );
  }

  //AppBar
  AppBar _buildAppBar() {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Image.asset('assets/images/boblogo.png'),
      ),
      title: const Text('밥친구'),
      actions: [
        IconButton(
          icon: const Icon(Icons.create),
          onPressed: () => Get.offAllNamed('/create'),
        ),
      ],
    );
  }

  // 구분선
  Divider _divider() {
    return Divider(
      color: Colors.black.withOpacity(0.5),
      thickness: 1,
      height: 1,
    );
  }

  // 메뉴추천
  Widget _menuRecommendCard() {
    return FoodScreen();
  }

  // 지역 + 로고 영역
  Widget _locationArea() {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 24),
              const SizedBox(width: 4),
              const Text(
                '용현동',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down, size: 24),
              const SizedBox(width: 8),
            ],
          ),
          
          // 새로고침 버튼
          GestureDetector(
            onTap: () async {
              await controller.loadMealBuddys();
              Get.snackbar(
                '새로고침',
                '게시글을 불러왔습니다.',
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 1),
              );
            },
            child: Image.asset(
              'assets/images/boblogo.png',
              width: 60,
              height: 60,
            ),
          ),
        ],
      ),
    );
  }

  // 카테고리
  Widget _categorySelector() {
    return SizedBox(
      height: 40,
      child: Obx(() {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: controller.categories.map((category) {
              final isSelected = controller.selectedCategory.value == category;
              final textColor = isSelected
                  ? const Color(0xFFD4AD69)
                  : const Color(0xFF8D8D8D);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GestureDetector(
                  onTap: () => controller.changeCategory(category),
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 4),
                    decoration: isSelected
                        ? const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xFFD4AD69),
                                width: 2,
                              ),
                            ),
                          )
                        : null,
                    child: Text(
                      category,
                      style: TextStyle(
                        fontSize: 16,
                        color: textColor,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }),
    );
  }

  // 밥친구 게시글 리스트
  Widget _mealList() {
    return Obx(() {
      final items = controller.filteredMeals;

      if (items.isEmpty) {
        return const Center(child: Text('등록된 밥친구 게시글이 없습니다.'));
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _mealItemCard(item);
        },
      );
    });
  }
  
  // 밥친구 게시글
  Widget _mealItemCard(item) {
    print('authorAge: ${item.authorAge}');
    return GestureDetector(
      onTap: () {
        Get.to(() => Feed(mealItem: item));
      },
      child: Card(
        color: AppTheme.backgroundColor,
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: AppTheme.primaryColor, width: 1),
        ),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 작성자 정보 + 신청 버튼
              Row(
                children: [
                  // 프로필 사진
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppTheme.splash,
                    backgroundImage: item.authorProfileImage != null
                        ? NetworkImage(item.authorProfileImage!)
                        : null,
                    child: item.authorProfileImage == null
                        ? const Icon(Icons.person, size: 24, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 10),

                  // 이름, 나이, 성별
                  Text(
                    '${item.authorName}  ${item.authorAge}세 ${item.authorGender}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const Spacer(),

                  // 신청 버튼
                  OutlinedButton(
                    onPressed: () {
                      _sendFriendRequest(item);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      side: const BorderSide(color: AppTheme.primaryColor),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      minimumSize: const Size(60, 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      '신청',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 10),

              // 제목
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),

              // 정보 (장소, 메뉴, 시간)
              Row(
                children: [
                  Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    item.place,
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 6),
                  Text('|', style: TextStyle(color: Colors.grey[400])),
                  const SizedBox(width: 6),
                  Icon(Icons.restaurant, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    item.menu,
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 6),
                  Text('|', style: TextStyle(color: Colors.grey[400])),
                  const SizedBox(width: 6),
                  Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    item.time,
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),

                  const Spacer(),

                  // 좋아요 버튼
                  Obx(() => IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      item.isFavorite.value
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: item.isFavorite.value ? Colors.red : Colors.grey,
                      size: 20,
                    ),
                    onPressed: () => controller.heartMealBuddy(item),
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 신청 함수
  void _sendFriendRequest(item) {
    Get.dialog(
      AlertDialog(
        title: Text('${item.authorName}님에게 밥친구 신청'),
        content: Text('${item.authorName}님에게 밥친구를 신청하시겠어요?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();

              // FriendshipController 가져오기
              final friendshipController = Get.put(FriendshipController());
              final success = await friendshipController.sendFriendRequest(
                item.userId,
              );

              if (success) {
                // 성공 시 스낵바는 Controller에서 이미 표시
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text('신청'),
          ),
        ],
      ),
    );
  }
}
