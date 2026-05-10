import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/friendship_controller.dart';
import '../../controllers/chat_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatMapScreen extends StatelessWidget {
  final int friendshipId;
  final String friendName;
  final String? friendProfileImage;

  ChatMapScreen({
    super.key,
    required this.friendshipId,
    required this.friendName,
    this.friendProfileImage,
  });

  //final authController = Get.find<AuthController>();
  

  void _performNaverSearch(String query) async {
    final encodedQuery = Uri.encodeComponent(query);
    final url = 'https://m.map.naver.com/search.naver?query=$encodedQuery';

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print('X');
    }
  }

  Widget _buildImageMarker({
    required String label,
    String? imageUrl,
    required double pinWidth,
    required double imageRadius,
  }) {
    final labelWidget = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2C99F), width: 3),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 14,
        ),
      ),
    );

    final imageMarkerBody = SizedBox(
      width: pinWidth,
      height: pinWidth * 1.3,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: pinWidth * 0.05,
            child: Container(
              width: imageRadius * 2 + 6,
              height: imageRadius * 2 + 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFBF7EF),
                border: Border.all(color: const Color(0xFFE2C99F), width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 0,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: CircleAvatar(
                  radius: imageRadius,
                  backgroundColor: AppTheme.splash,
                  backgroundImage:
                      imageUrl != null && imageUrl.startsWith('http')
                          ? NetworkImage(imageUrl)
                          : null,
                  child: imageUrl == null || !imageUrl.startsWith('http')
                      ? Icon(Icons.person,
                          size: imageRadius * 1.2, color: Colors.white)
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        labelWidget,
        const SizedBox(height: 1),
        imageMarkerBody,
      ],
    );
  }

  Widget _buildLocationItem(String name, String distance, String? imagePath) {
    ImageProvider? imageProvider;
    Widget? childWidget;

    if (imagePath != null && imagePath.isNotEmpty) {
      if (imagePath.startsWith('http')) {
        imageProvider = NetworkImage(imagePath);
      } else {
        imageProvider = AssetImage(imagePath);
      }
    } else {
      childWidget = const Icon(Icons.person, size: 28, color: Colors.white);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppTheme.splash,
            backgroundImage: imageProvider,
            child: childWidget,
          ),
          const SizedBox(width: 16),
          Text(name, style: const TextStyle(fontSize: 18)),
          const Spacer(),
          Text(distance, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final friendshipController = Get.find<FriendshipController>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 3.0),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_ios,
                  color: Colors.black, size: 20),
            ),
          ),
        ),
        title: Text('위치공유'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/map.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// 나 마커
          Positioned(
            top: Get.height * 0.25,
            left: Get.width * 0.1,
            child: _buildImageMarker(
              label: "나의 위치",
              pinWidth: 60,
              imageRadius: 26,
              imageUrl: authController.userData['profile_image_url'] as String?,
            ),
          ),

          /// 친구 마커 (Obx로 반응형)
          Obx(() {
            if (friendshipController.friendships.isEmpty)
              return SizedBox.shrink();
            final friend = friendshipController.friendships.first['friend'];
            return Positioned(
              top: Get.height * 0.18,
              left: Get.width * 0.5,
              child: _buildImageMarker(
                label: friendName ?? '친구',
                pinWidth: 60,
                imageRadius: 26,
                imageUrl: friendProfileImage,
              ),
            );
          }),

          // 하단 드래그 시트
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.15,
            maxChildSize: 0.8,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: AppTheme.backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      Container(
                        width: 50,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.only(top: 15, bottom: 10),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Text('위치 공유',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Spacer(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Obx(() {
                          if (friendshipController.friendships.isEmpty) {
                            return const Text('친구가 없습니다.');
                          }
                          final friend =
                              friendshipController.friendships.first['friend'];
                          return Column(
                            children: [
                              _buildLocationItem(
                                "나",
                                "500m",
                                authController.userData['profile_image_url']
                                    as String?,
                              ),
                              Divider(color: Colors.grey[200]),
                              _buildLocationItem(
                                friendName ?? '친구',
                                "600m",
                                friendProfileImage,
                              ),
                              Divider(color: Colors.grey[200]),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
