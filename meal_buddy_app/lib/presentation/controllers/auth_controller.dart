import 'package:get/get.dart';
import 'package:email_validator/email_validator.dart';
import '../../core/services/api_service.dart';

class AuthController extends GetxController {
  final _isLoading = false.obs;
  final _isLoggedIn = false.obs;
  final _userData = <String, dynamic>{}.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  bool get isLoggedIn => _isLoggedIn.value;
  RxBool get isLoggedInRx => _isLoggedIn; // 로그인 상태를 감시할 수 있도록 RxBool 노출
  RxMap<String, dynamic> get userData => _userData; // Obx가 감지할 수 있도록 RxMap 반환

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  /// 인증 상태 확인
  Future<void> _checkAuthStatus() async {
    try {
      // 이미 로그인되어 있으면 스킵 (중복 호출 방지)
      if (_isLoggedIn.value) {
        print('⏭️ 이미 로그인되어 있어 _checkAuthStatus 스킵');
        return;
      }

      final tokenValid = await ApiService.isTokenValid();
      if (tokenValid) {
        // 토큰이 유효하면 API로 최신 프로필 가져오기
        final profileData = await ApiService.getProfile();
        print('🔍 _checkAuthStatus - 프로필 로드: $profileData');

        // RxMap을 완전히 새로 할당하여 Obx가 변화를 감지하도록 함
        _userData.value = Map<String, dynamic>.from(profileData);
        _isLoggedIn.value = true;
        print(
            '✅ _checkAuthStatus 완료: ${_userData['nickname']} (${_userData['email']})');
        print('📊 _userData 내용: ${_userData.toString()}');
      }
    } catch (e) {
      print('인증 상태 확인 실패: $e');
      // 토큰이 만료되었거나 에러 발생 시 로그아웃 상태로
      _userData.clear();
      _isLoggedIn.value = false;
    }
  }

  /// 회원가입
  Future<bool> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String nickname,
    required int age,
    required String gender,
    required List<String> foodPreferences,
    String? profileImageUrl,
  }) async {
    // 유효성 검사
    if (!_validateEmail(email)) {
      Get.snackbar('오류', '올바른 이메일 형식을 입력해주세요.');
      return false;
    }

    if (!_validatePassword(password)) {
      Get.snackbar('오류', '비밀번호는 6자 이상이어야 합니다.');
      return false;
    }

    if (password != confirmPassword) {
      Get.snackbar('오류', '비밀번호가 일치하지 않습니다.');
      return false;
    }

    if (nickname.trim().isEmpty) {
      Get.snackbar('오류', '닉네임을 입력해주세요.');
      return false;
    }

    if (foodPreferences.isEmpty) {
      Get.snackbar('오류', '음식 취향을 선택해주세요.');
      return false;
    }

    _isLoading.value = true;

    try {
      final result = await ApiService.register(
        email: email.trim(),
        password: password,
        nickname: nickname.trim(),
        foodPreferences: foodPreferences,
        age: age,
        gender: gender,
        profileImageUrl: profileImageUrl,
      );

      // RxMap을 완전히 새로 할당하여 Obx가 변화를 감지하도록 함
      _userData.value = Map<String, dynamic>.from(result['user']);
      _isLoggedIn.value = true;

      print('✅ 회원가입 완료: ${_userData['nickname']} (${_userData['email']})');

      Get.snackbar('성공', '회원가입이 완료되었습니다.');
      return true;
    } catch (e) {
      Get.snackbar('오류', e.toString());
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  /// 로그인
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    print('🚀 AuthController.login() 호출됨: $email');

    if (!_validateEmail(email)) {
      Get.snackbar('오류', '올바른 이메일 형식을 입력해주세요.');
      return false;
    }

    if (password.isEmpty) {
      Get.snackbar('오류', '비밀번호를 입력해주세요.');
      return false;
    }

    _isLoading.value = true;

    try {
      final result = await ApiService.login(
        email: email.trim(),
        password: password,
      );

      // API 응답 구조 확인
      print('🔍 API 응답 전체: $result');
      print('🔍 result[\'user\']: ${result['user']}');
      print('🔍 result[\'user\'] 타입: ${result['user'].runtimeType}');

      // API 응답에서 받은 사용자 데이터를 AuthController에 저장
      final userDataFromApi = result['user'] as Map<String, dynamic>;
      print('🔍 userDataFromApi: $userDataFromApi');
      print('🔍 userDataFromApi[\'nickname\']: ${userDataFromApi['nickname']}');
      print('🔍 userDataFromApi[\'email\']: ${userDataFromApi['email']}');

      // RxMap을 완전히 새로 할당하여 Obx가 변화를 감지하도록 함
      _userData.value = Map<String, dynamic>.from(userDataFromApi);
      _isLoggedIn.value = true;

      print('✅ 로그인 완료: ${_userData['nickname']} (${_userData['email']})');
      print('📊 _userData 내용: ${_userData.toString()}');
      print('📊 _userData[\'nickname\']: ${_userData['nickname']}');
      print('📊 _userData[\'email\']: ${_userData['email']}');

      Get.snackbar('성공', '로그인되었습니다.');
      return true;
    } catch (e) {
      Get.snackbar('오류', e.toString());
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  /// 로그아웃
  Future<void> logout() async {
    try {
      // 먼저 UI 상태 초기화
      _userData.clear();
      _isLoggedIn.value = false;

      print('🚪 로그아웃 시작...');

      // API 호출 및 데이터 삭제 (완료될 때까지 대기)
      await ApiService.logout();

      print('✅ 로그아웃 완료');

      // 데이터 삭제가 완전히 끝난 후 화면 이동
      Get.snackbar('성공', '로그아웃되었습니다.');
      Get.offAllNamed('/login'); // 로그인 화면으로 이동
    } catch (e) {
      Get.snackbar('오류', '로그아웃 중 오류가 발생했습니다.');
    }
  }

  /// 프로필 업데이트
  Future<bool> updateProfile({
    String? nickname,
    List<String>? foodPreferences,
    String? profileImageUrl,
    String? age,
    String? intro,
  }) async {
    if (nickname != null && nickname.trim().isEmpty) {
      Get.snackbar('오류', '닉네임을 입력해주세요.');
      return false;
    }

    if (foodPreferences != null && foodPreferences.isEmpty) {
      Get.snackbar('오류', '음식 취향을 선택해주세요.');
      return false;
    }
    if (age != null && age.isEmpty) {
      Get.snackbar('오류', '나이를 입력해주세요.');
      return false;
    }
    _isLoading.value = true;

    try {
      final result = await ApiService.updateProfile(
        nickname: nickname?.trim(),
        age: age?.trim(),
        foodPreferences: foodPreferences,
        profileImageUrl: profileImageUrl,
      );

      // RxMap을 완전히 새로 할당하여 Obx가 변화를 감지하도록 함
      _userData.value = Map<String, dynamic>.from(result);

      print('✅ 프로필 업데이트 완료: ${_userData['nickname']}');

      Get.snackbar('성공', '프로필이 업데이트되었습니다.');
      return true;
    } catch (e) {
      Get.snackbar('오류', e.toString());
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  /// 이메일 유효성 검사
  bool _validateEmail(String email) {
    return EmailValidator.validate(email);
  }

  /// 비밀번호 유효성 검사
  bool _validatePassword(String password) {
    return password.length >= 6;
  }

  /// 사용자 데이터 새로고침
  Future<void> refreshUserData() async {
    try {
      final userData = await ApiService.getProfile();
      // RxMap을 완전히 새로 할당하여 Obx가 변화를 감지하도록 함
      _userData.value = Map<String, dynamic>.from(userData);
      print('✅ 사용자 데이터 새로고침 완료: ${_userData['nickname']}');
    } catch (e) {
      print('사용자 데이터 새로고침 실패: $e');
    }
  }
}
