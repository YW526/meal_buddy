import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/friendship_controller.dart';
import '../home/feed.dart';

class SearchTab extends GetView<HomeController> {
  const SearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    //final controller = Get.find<HomeController>();
    final searchController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Image.asset('assets/images/boblogo.png'),
        ),
        title: Text('밥친구 검색'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_outlined),
            onPressed: () => {
              Get.toNamed('/friend-list'),
            }, 
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: '메뉴, 장소, 제목 검색',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    controller.searchMealBuddies(searchController.text);
                  },
                ),
              ),
              onSubmitted: (value) {
                controller.searchMealBuddies(value);
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.searchResultList.isEmpty) {
                return const Center(child: Text('검색 결과가 없습니다.'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(18),
                itemCount: controller.searchResultList.length,
                itemBuilder: (context, index) {
                  final item = controller.searchResultList[index];
                  return _buildMealItemCard(item);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // 밥친구 게시글 카드
  Widget _buildMealItemCard(item) {
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
              crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            item.place,
                            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text('|', style: TextStyle(color: Colors.grey[400])),
                        const SizedBox(width: 6),
                        Icon(Icons.restaurant, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            item.menu,
                            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text('|', style: TextStyle(color: Colors.grey[400])),
                        const SizedBox(width: 6),
                        Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            item.time,
                            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// 좋아요 버튼
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
