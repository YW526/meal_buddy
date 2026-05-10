import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../../core/services/api_service.dart';

class SettingsTab extends GetView<HomeController> {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final HomeController homeController = Get.find<HomeController>();
    //final myPosts = homeController.myPosts;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Image.asset('assets/images/boblogo.png'),
        ),
        title: Text('사용자 설정 화면'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note),
            onPressed: () => Get.toNamed('/settings-edit'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Get.toNamed('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          // Obx 내부에서 authController.userData를 직접 참조하여 변화 감지
          // 디버깅: 현재 표시되는 사용자 데이터 확인
          final myPosts = homeController.myPosts;
          print(
              '🔍 SettingsTab - 현재 사용자: ${authController.userData['nickname']} (${authController.userData['email']})');
          print(
              '🔍 SettingsTab - userData 타입: ${authController.userData.runtimeType}');
          print(
              '🔍 SettingsTab - userData isEmpty: ${authController.userData.isEmpty}');

          if (authController.userData.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding( 
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20,),
                Container(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: AppTheme.splash,
                        backgroundImage:
                            authController.userData['profile_image_url'] != null
                                ? NetworkImage(
                                    authController.userData['profile_image_url'])
                                : null,
                        child: authController.userData['profile_image_url'] == null
                            ? const Icon(Icons.person, size: 40, color: Colors.white)
                            : null,
                      ),
                      SizedBox(height: 10,),
                      Text(
                        authController.userData['nickname'] ?? '닉네임 없음',
                        style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text(
                        '나이: ${authController.userData['settings']?['age']?.toString() ?? '-'} | '
                        '성별: ${authController.userData['settings']?['gender'] ?? '-'} | '
                        //'친구수: ${authController.userData['friend_count']?.toString() ?? '0'} | '
                        '혼밥 레벨: ${authController.userData['solo_level']?.toString() ?? '99'}',
                      ),
                      SizedBox(height: 20,),
                    ],
                  ),
                ),
                Divider (
                  color: AppTheme.primaryColor,
                  thickness: 1,
                  height: 1,
                ),
                SizedBox(height: 20,),
                Text(
                  '내 업로드',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (myPosts.isEmpty)
                  const Text("작성한 게시물이 없습니다.")
                else
                  Column(
                    children: myPosts.map((item) {
                      return _myUploadCard(item);
                    }).toList(),
                  ),

                const SizedBox(height: 40),

                SizedBox(height: 24),
              ],
            ),
          );
        }),
      ),
    );
  }
  Widget _myUploadCard(item) {
    return Card(
      color: AppTheme.backgroundColor,
      margin: const EdgeInsets.symmetric(vertical: 8),
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
            // 작성자 정보
            Row(
              children: [
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

                // 이름 + 나이 + 성별
                Text(
                  '${item.authorName}  ${item.authorAge}세 ${item.authorGender}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const Spacer(),
                OutlinedButton(
                  onPressed: () {
                    //내 게시글 삭제 
                    _deleteMyPost(item);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.errorColor,
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
                    '삭제',
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
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            // 장소, 메뉴, 시간
            Row(
              children: [
                Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(item.place, style: TextStyle(color: Colors.grey[700])),
                const SizedBox(width: 8),
                Text('|', style: TextStyle(color: Colors.grey[400])),
                const SizedBox(width: 8),

                Icon(Icons.restaurant, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(item.menu, style: TextStyle(color: Colors.grey[700])),
                const SizedBox(width: 8),
                Text('|', style: TextStyle(color: Colors.grey[400])),
                const SizedBox(width: 8),

                Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(item.time, style: TextStyle(color: Colors.grey[700])),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteMyPost(item) async {
    //내 게시물 삭제 버튼 구현
    print("🧨 삭제하려는 postId = ${item.postId}");
    final HomeController homeController = Get.find<HomeController>();
    final bool? confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text("삭제 확인"),
        content: const Text("정말로 이 게시물을 삭제하시겠습니까?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("취소"),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text("삭제"),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      // 2) 서버 삭제 요청
      await ApiService.deletePost(item.postId);

      // 3) HomeController 리스트에서 제거
      homeController.mealbuddyList.remove(item);
      homeController.searchResultList.remove(item);

      Get.snackbar("삭제 완료", "게시물이 삭제되었습니다.",
          backgroundColor: Colors.white, colorText: Colors.black);
          print("🧨 삭제하려는 postId = ${item.postId}");
    } catch (e) {
      Get.snackbar("삭제 실패", "게시물 삭제 중 오류가 발생했습니다.",
          backgroundColor: Colors.white, colorText: Colors.black);
    }
  }
}
