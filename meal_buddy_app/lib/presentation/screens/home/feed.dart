import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes.dart';
import '../../../app/theme.dart';
import '../../widgets/common/custom_button.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/friendship_controller.dart';

class Feed extends GetView<HomeController> {
  final dynamic mealItem;
  const Feed({super.key, required this.mealItem});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.offAllNamed('/home'),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),

        //제목: 앱 바의 타이틀
        title: Text(
          '게시글',
          //mealItem.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 작성자 정보
              CircleAvatar(
                radius: 40,
                backgroundColor: AppTheme.splash,
                backgroundImage: mealItem.authorProfileImage != null
                    ? NetworkImage(mealItem.authorProfileImage!)
                    : null,
                child: mealItem.authorProfileImage == null
                    ? const Icon(Icons.person, size: 40, color: Colors.white)
                    : null,
              ),
              const SizedBox(height: 10),
              Text(
                mealItem.authorName,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '${mealItem.authorAge}세 | ${mealItem.authorGender}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 10),
              /*OutlinedButton(
                onPressed: () {
                  // 친구 신청 로직 추가
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFD9B77C)),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: const Text('친구 신청하기', style: TextStyle(color: Color(0xFFA0A0A0)),),
              ),*/

              const SizedBox(height: 20),

              //구분선
              Container(
                height: 1,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 45,
                  separatorBuilder: (context, index) {
                    return SizedBox(width: 4);
                  },
                  itemBuilder: (context, index) {
                    return Container(
                      width: 4,
                      color: AppTheme.primaryColor,
                    );
                  },
                ),
              ),
              SizedBox(height: 30,),

              // 게시글 제목
              Text(
                mealItem.title,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              // 게시글 내용
              Text(
                mealItem.content ?? '내용이 없습니다.',
                style: const TextStyle(fontSize: 16,),
              ),
              const SizedBox(height: 30),

              //구분선
              Container(
                height: 1,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 45,
                  separatorBuilder: (context, index) {
                    return SizedBox(width: 4);
                  },
                  itemBuilder: (context, index) {
                    return Container(
                      width: 4,
                      color: AppTheme.primaryColor,
                    );
                  },
                ),
              ),
              SizedBox(height: 20,),

              // 정보 (카테고리, 장소, 시간)
              Row(
                children: [
                  const Icon(Icons.location_on, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(mealItem.place, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(width: 6),
                  const Text('|', style: TextStyle(color: Colors.grey)),
                  const SizedBox(width: 6),
                  const Icon(Icons.restaurant, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(mealItem.menu, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(width: 6),
                  const Text('|', style: TextStyle(color: Colors.grey)),
                  const SizedBox(width: 6),
                  const Icon(Icons.access_time, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(mealItem.time, style: const TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 20),

              // 지도 자리 (하드코딩)
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFD6B87E)),
                ),
                alignment: Alignment.center,
                child: const Text(
                  '지도(지원 예정)',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
              const SizedBox(height: 8),
              /*Text(
                mealItem.placeAddress ?? '',
                style: const TextStyle(color: Colors.grey),
              ),*/
              const SizedBox(height: 20),

              CustomButton(
                onPressed: () {_sendFriendRequest(mealItem);},
                text: '신청하기',
                width: 500,
              ),
            ],
          ),
        ),
      ),
    );
  }

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