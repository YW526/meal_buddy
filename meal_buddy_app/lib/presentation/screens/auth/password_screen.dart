import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meal_buddy_app/presentation/screens/auth/login_screen.dart';
import '../../../core/services/api_service.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreen();
}

class _PasswordScreen extends State<PasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _password() async{
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
    });
    try{
      final result = await ApiService.password(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      Get.snackbar(
        '비밀번호 변경 성공',
        '비밀번호가 변경되었습니다!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.offAllNamed('/login');
    }catch (e){
      Get.snackbar(
        '비밀번호 변경 실패',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.offAllNamed('/login'),
          icon: Icon(Icons.arrow_back_outlined),
        ),
        title: const Text("비밀번호 재설정"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //이메일 확인
              CustomTextField(
                controller: _emailController,
                label: '이메일',
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
              SizedBox(height: 16,),

              //새 비밀번호
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                label: '새 비밀번호',
                hint: '6자 이상 입력해주세요.',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 입력해주세요.';
                  }
                  if (value.length < 6) {
                    return '비밀번호를 6자리 이상 입력해주세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              //비밀번호 확인
              CustomTextField(
                controller: _confirmPasswordController,
                label: '비밀번호 확인',
                hint: '비밀번호를 다시 입력해주세요.',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 확인 입력해주세요.';
                  }
                  if (_confirmPasswordController.text != _passwordController.text) {
                    return '비밀번호가 같지않습니다.';
                  } 
                  return null;
                },
              ),
              const SizedBox(height: 24),

              CustomButton(
                onPressed: _isLoading ? null : _password,
                text: _isLoading ? '비밀번호 변경 중...' : '비밀번호 변경',
              ),
            ],
          ),
        ),
      ),
    );
  }
}