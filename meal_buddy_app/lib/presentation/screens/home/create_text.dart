import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meal_buddy_app/app/theme.dart';
import 'package:meal_buddy_app/presentation/screens/auth/login_screen.dart';
import '../../../core/services/api_service.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../controllers/home_controller.dart';

class Create extends StatelessWidget {
  const Create({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final titleController = TextEditingController();
    final placeController = TextEditingController();
    final menuController = TextEditingController();
    final timeController = TextEditingController();
    final contentController = TextEditingController(); //이후 게시글 내용 확인할 때 필요

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.offAllNamed('/home'),
          icon: Icon(Icons.arrow_back_outlined),
        ),
        title: const Text("작성 화면"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          //key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: titleController,
                label: '제목',
                hint: '오늘 나랑 밥 먹을 사람?',
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '제목을 입력해주세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: placeController,
                label: '장소',
                hint: '인하대후문',
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '장소를 입력해주세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: menuController,
                label: '메뉴',
                hint: '떡볶이',
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '메뉴를 입력해주세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: timeController,
                label: '시간',
                hint: '오후 7시',
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '시간을 입력해주세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                '음식 종류 선택',
                style: TextStyle(fontSize: 16),
              ),
              Obx(() => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['한식', '중식', '양식', '일식', '분식'].map((type) {
                        final isSelected =
                            controller.selectedFoodType.value == type;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              Radio<String>(
                                value: type,
                                groupValue: controller.selectedFoodType.value,
                                onChanged: (value) =>
                                    controller.changeFoodType(value!),
                                activeColor: AppTheme.primaryColor,
                              ),
                              Text(type),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  )),
              const SizedBox(height: 16),
              CustomTextField(
                controller: contentController,
                label: '내용',
                //height: 30,
                hint: '맛있는 떡볶이 먹을 사람 찾아요.',
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '내용을 입력해주세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),
              CustomButton(
                onPressed: () async {
                  // 유효성 검사
                  if (titleController.text.isEmpty) {
                    Get.snackbar('오류', '제목을 입력해주세요.');
                    return;
                  }
                  if (placeController.text.isEmpty) {
                    Get.snackbar('오류', '장소를 입력해주세요.');
                    return;
                  }
                  if (menuController.text.isEmpty) {
                    Get.snackbar('오류', '메뉴를 입력해주세요.');
                    return;
                  }
                  if (timeController.text.isEmpty) {
                    Get.snackbar('오류', '시간을 입력해주세요.');
                    return;
                  }

                  // API 호출 (await 추가)
                  await controller.addMealBuddy(
                    titleController.text,
                    contentController.text,
                    placeController.text,
                    menuController.text,
                    timeController.text,
                  );

                  // API 호출 완료 후 화면 이동
                  Get.offAllNamed('/home');
                },
                text: '작성하기',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
