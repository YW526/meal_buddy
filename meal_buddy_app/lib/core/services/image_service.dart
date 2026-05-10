import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'api_service.dart';

class ImageService {
  static final ImagePicker _picker = ImagePicker();

  /// 갤러리에서 이미지 선택
  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('갤러리에서 이미지 선택 실패: $e');
      return null;
    }
  }

  /// 카메라로 이미지 촬영
  static Future<File?> takePhotoWithCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('카메라 촬영 실패: $e');
      return null;
    }
  }

  /// 이미지 업로드
  static Future<String?> uploadImage(File imageFile) async {
    try {
      final imageUrl = await ApiService.uploadImage(imageFile);
      return imageUrl;
    } catch (e) {
      print('이미지 업로드 실패: $e');
      return null;
    }
  }

  /// 프로필 이미지 업로드
  static Future<String?> uploadProfileImage() async {
    try {
      final imageFile = await pickImageFromGallery();
      if (imageFile != null) {
        return await uploadImage(imageFile);
      }
      return null;
    } catch (e) {
      print('프로필 이미지 업로드 실패: $e');
      return null;
    }
  }

  /// 채팅 이미지 업로드
  static Future<String?> uploadChatImage() async {
    try {
      final imageFile = await pickImageFromGallery();
      if (imageFile != null) {
        return await uploadImage(imageFile);
      }
      return null;
    } catch (e) {
      print('채팅 이미지 업로드 실패: $e');
      return null;
    }
  }

  /// 이미지 크기 확인
  static Future<bool> isImageSizeValid(File imageFile) async {
    try {
      final fileSize = await imageFile.length();
      const maxSize = 5 * 1024 * 1024; // 5MB
      return fileSize <= maxSize;
    } catch (e) {
      print('이미지 크기 확인 실패: $e');
      return false;
    }
  }

  /// 이미지 형식 확인
  static bool isImageFormatValid(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    const validExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
    return validExtensions.contains(extension);
  }
}
