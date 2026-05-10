import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../app/theme.dart';
import '../../controllers/auth_controller.dart';
import '../../../core/services/api_service.dart';

class SettingEditScreen extends StatefulWidget {
  const SettingEditScreen({super.key});

  @override
  State<SettingEditScreen> createState() => _SettingEditScreenState();
}

class _SettingEditScreenState extends State<SettingEditScreen> {
  final AuthController authController = Get.find<AuthController>();

  File? selectedImageFile;
  String? uploadedImageUrl;

  late TextEditingController nicknameController;

  @override
  void initState() {
    super.initState();
    nicknameController = TextEditingController(
      text: authController.userData['nickname'] ?? "",
    );
  }

  @override
  void dispose() {
    nicknameController.dispose();
    super.dispose();
  }

  /// 이미지 선택
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        selectedImageFile = File(picked.path);
      });

      // 서버 업로드
      uploadedImageUrl = await ApiService.uploadImage(File(picked.path));

      if (uploadedImageUrl != null) {
        Get.snackbar("성공", "이미지가 업로드되었습니다!");
      }
    }
  }

  /// 저장
  Future<void> saveProfile() async {
    String nickname = nicknameController.text.trim();

    if (nickname.isEmpty) {
      Get.snackbar("오류", "닉네임은 필수 입력 항목입니다.");
      return;
    }

    await authController.updateProfile(
      nickname: nickname,
      profileImageUrl: uploadedImageUrl,
    );
    Get.snackbar('수정 완료', '프로필이 성공적으로 수정되었습니다.');
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("프로필 수정"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Center(
              child: GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
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
              ),
            ),
            const SizedBox(height: 15),
            const Center(
              child: Text("사진 수정", style: TextStyle(fontSize: 14)),
            ),
            const SizedBox(height: 30),

            const Text("닉네임", style: TextStyle(fontSize: 16)),
            TextField(
              controller: nicknameController,
              decoration: const InputDecoration(hintText: "닉네임을 입력하세요"),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: saveProfile,
              child: const Text("저장하기"),
            ),
          ],
        ),
      ),
    );
  }
}
