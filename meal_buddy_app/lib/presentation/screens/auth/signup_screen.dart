import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/api_service.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> _selectedFoodPreferences = [];
  bool _isLoading = false;
  int _selectedValue = 1;

  final List<String> _foodOptions = [
    '한식',
    '중식',
    '일식',
    '양식',
    '분식',
    '카페',
    '디저트',
    '치킨',
    '피자',
    '햄버거'
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nicknameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
     if (!_formKey.currentState!.validate()) {
      return;
    }
    
    // gender 계산
    String gender = _selectedValue == 1 ? "남" : "여";

    if (_selectedFoodPreferences.isEmpty) {
      Get.snackbar(
        '오류',
        '음식 취향을 선택해주세요.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await ApiService.register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        nickname: _nicknameController.text.trim(),
        age: int.parse(_ageController.text.trim()),
        gender: gender,
        foodPreferences: _selectedFoodPreferences,
      );

      Get.snackbar(
        '회원가입 성공',
        '회원가입이 완료되었습니다.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // 로그인 화면으로 이동
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar(
        '회원가입 실패',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 0),
              // 닉네임 입력
              CustomTextField(
                controller: _nicknameController,
                label: '이름/닉네임',
                hint: '이름/닉네임을 입력해주세요.',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '닉네임을 입력해주세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // 이메일 입력
              CustomTextField(
                controller: _emailController,
                label: '학교 이메일',
                hint: 'example@email.com',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이메일을 입력해주세요.';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return '올바른 이메일 형식을 입력해주세요.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // 비밀번호 입력
              CustomTextField(
                controller: _passwordController,
                label: '비밀번호',
                hint: '6자 이상 입력해주세요.',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 입력해주세요.';
                  }
                  if (value.length < 6) {
                    return '비밀번호는 6자 이상이어야 합니다.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // 비밀번호 확인
              CustomTextField(
                controller: _confirmPasswordController,
                label: '비밀번호 확인',
                hint: '비밀번호를 다시 입력해주세요.',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 다시 입력해주세요.';
                  }
                  if (value != _passwordController.text) {
                    return '비밀번호가 일치하지 않습니다.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              //나이
              CustomTextField(
                controller: _ageController,
                label: '나이',
                hint: '한국 나이를 입력해주세요.',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '나이를 입력해주세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Text(
                    "성별", 
                    style: TextStyle(
                      fontSize: 16,

                    ),
                  ),
                  SizedBox(width: 50,),
                  Radio(
                    value: 1,
                    groupValue: _selectedValue,
                    onChanged: (int? value){
                      setState(() {
                        _selectedValue = value!;
                      });
                    },
                  ),
                  Text("남성", style: TextStyle(fontSize: 16),),
                  SizedBox(width: 50,),
                  Radio(
                    value: 2,
                    groupValue: _selectedValue,
                    onChanged: (int? value){
                      setState(() {
                        _selectedValue = value!;
                      });
                    },
                  ),
                  Text("여성", style: TextStyle(fontSize: 16),),
                ],
              ),
              Text(
                '음식 취향 (복수 선택 가능)',
                style: TextStyle(fontSize: 16,),
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _foodOptions.map((food) {
                  final isSelected = _selectedFoodPreferences.contains(food);
                  return FilterChip(
                    label: Text(food),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedFoodPreferences.add(food);
                        } else {
                          _selectedFoodPreferences.remove(food);
                        }
                      });
                    },
                    selectedColor: Colors.orange.shade200,
                    backgroundColor: Colors.grey.shade200,
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // 회원가입 버튼
              CustomButton(
                onPressed: _isLoading ? null : _signup,
                text: _isLoading ? '회원가입 중...' : '회원가입',
              ),

              const SizedBox(height: 10),

              // 로그인 화면으로 이동
              TextButton(
                onPressed: () => Get.offAllNamed('/login'),
                child: const Text('이미 계정이 있으신가요? 로그인하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
