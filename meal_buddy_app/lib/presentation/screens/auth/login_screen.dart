import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // AuthController를 통해 로그인 (userData 자동 업데이트)
      final authController = Get.find<AuthController>();
      final success = await authController.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (success) {
        Get.snackbar(
          '로그인 성공',
          '밥친구에 오신 것을 환영합니다!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // 메인 화면으로 이동
        Get.offAllNamed('/home');
      }
    } catch (e) {
      Get.snackbar(
        '로그인 실패',
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
        title: const Text('로그인'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              // 앱 로고 및 제목
              /*
              const Icon(
                Icons.restaurant,
                size: 80,
                color: Colors.blue,
              ),*/

              //const SizedBox(height: 16),
              Container(
                width: 150,
                height: 180,
                child: Image.asset(
                  'assets/images/boblogo_txt.png',
                ),
              ),
              /*
              const Text(
                '밥친구',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ), */

              const SizedBox(height: 8),

              const Text(
                '혼밥을 싫어하는 사람들을 위한 밥친구 매칭',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // 이메일 입력
              CustomTextField(
                controller: _emailController,
                label: '이메일',
                hint: 'example@email.com',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이메일을 입력해주세요.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // 비밀번호 입력
              CustomTextField(
                //border: Border.all(),
                controller: _passwordController,
                label: '비밀번호',
                hint: '비밀번호를 입력해주세요',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 입력해주세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // 비밀번호 재설정 화면 이동
              TextButton(
                onPressed: () => Get.offAllNamed('/password'),
                child: const Text(
                  "비밀번호를 잊으셨나요? 비밀번호 재설정",
                  textAlign: TextAlign.end,
                ),
                //style: ButtonStyle(alignment: Alignment(left)),
              ),

              const SizedBox(height: 15),

              // 로그인 버튼
              CustomButton(
                onPressed: _isLoading ? null : _login,
                text: _isLoading ? '로그인 중...' : '로그인',
              ),

              const SizedBox(height: 16),

              // 회원가입 화면으로 이동
              TextButton(
                onPressed: () => Get.offAllNamed('/signup'),
                child: const Text(
                  '계정이 없으신가요? 회원가입',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
