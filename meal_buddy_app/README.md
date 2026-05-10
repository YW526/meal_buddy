# 밥친구 (Meal Buddy)

혼밥을 싫어하는 사람들을 위한 1:1 밥친구 매칭 앱입니다.

## 🍽️ 주요 기능

- **1km 반경 내 밥친구 검색**: 위치 기반으로 근처의 밥친구를 찾습니다
- **밥 취향 기반 매칭**: 회원가입 시 선택한 밥 취향으로 매칭합니다
- **실시간 채팅**: 밥친구와 실시간으로 대화할 수 있습니다
- **온도 시스템**: 밥친구와의 친밀도를 온도로 표시합니다 (0-100도)
- **레벨 시스템**: 밥친구 앱을 적게 사용할수록 혼밥 레벨이 100에서 시작하며 앱을 점점 사용하면 레벨이 낮아집니다
- **크로스 플랫폼**: 웹, 안드로이드, iOS에서 사용 가능합니다

## 🛠️ 기술 스택

- **Frontend**: Flutter, Dart
- **상태관리**: GetX
- **Backend**: Firebase
  - Authentication (인증)
  - Cloud Firestore (데이터베이스)
  - Cloud Storage (이미지 저장)
- **지도**: Google Maps API
- **플랫폼**: Web, Android, iOS

## 📱 앱 화면

1. **스플래시 화면**: 앱 시작 화면
2. **로그인/회원가입**: 이메일 기반 인증
3. **홈 화면**: 주변 밥친구 목록
4. **채팅 화면**: 실시간 1:1 채팅
5. **프로필 화면**: 내 정보 및 통계
6. **설정 화면**: 앱 설정 및 계정 관리

## 🚀 실행 방법

### 필수 요구사항
- Flutter SDK 3.5.0 이상
- Dart SDK 3.5.0 이상
- Firebase 프로젝트 설정

### 설치 및 실행

1. **의존성 설치**
   ```bash
   flutter pub get
   ```

2. **Firebase 설정**
   - Firebase Console에서 새 프로젝트 생성
   - Authentication, Firestore, Storage 활성화
   - 웹/앱 등록 및 설정 파일 추가

3. **앱 실행**
   ```bash
   # 웹에서 실행
   flutter run -d chrome
   
   # 안드로이드에서 실행
   flutter run -d android
   
   # iOS에서 실행
   flutter run -d ios
   ```

## 📁 프로젝트 구조

```
lib/
├── app/                    # 앱 설정
│   ├── app.dart           # 메인 앱 클래스
│   ├── routes.dart        # 라우트 정의
│   └── theme.dart         # 테마 설정
├── core/                  # 핵심 유틸리티
│   ├── constants/         # 상수 정의
│   ├── services/          # 서비스 클래스
|   |   ├── api_service.dart
|   |   ├── location_service.dart
|   |   └── mock_data_service.dart
│   └── utils/             # 유틸리티 함수
├── data/                  # 데이터 레이어
│   ├── models/            # 데이터 모델
|   |   └── home_models.dart
│   ├── repositories/      # 리포지토리
│   └── datasources/       # 데이터 소스
├── domain/                # 도메인 레이어
│   ├── entities/          # 엔티티
│   └── usecases/          # 유스케이스
└── presentation/          # 프레젠테이션 레이어
    ├── controllers/       # GetX 컨트롤러
    |   ├── auth_controller.dart
    |   ├── chat_controller.dart
    |   ├── home_controller.dart
    |   └── friendship_controller.dart
    ├── screens/           # 화면 위젯
    |   ├── auth/
    |   |   ├── login_screen.dart
    |   |   ├── password_screen.dart #비밀번호 변경
    |   |   └── signup_screen.dart
    |   ├── chat/
    |   ├── home/
    |   |   ├── home_screen.dart
    |   |   ├── home_tab.dart 
    |   |   ├── search_tab.dart 
    |   |   ├── chat_tab.dart 
    |   |   ├── setting_tab.dart 
    |   |   └── create_text.dart 
    |   └── profile/
    └── widgets/           # 재사용 가능한 위젯
```

## 🔥 온도 시스템

밥친구와의 친밀도를 0-100도의 온도로 표시합니다:

- **0도**: 관계 종료
- **1-20도**: 차가움 (새로운 관계)
- **21-40도**: 서툴음 (초기 단계)
- **41-60도**: 보통 (익숙해짐)
- **61-80도**: 친밀 (자주 만남)
- **81-100도**: 매우 친밀 (베스트 밥친구)

온도는 다음과 같은 행동에 따라 변화합니다:
- 밥 같이 먹기: +5도
- 대화 활발함: +3도
- 약속 지킴: +2도
- 약속 취소: -2도
- 무응답: -1도
- 부적절한 행동: -5도

## 📋 개발 계획

### Phase 1: 기본 구조 (완료)
- [x] 프로젝트 설정
- [x] 기본 화면 구조
- [x] 라우팅 설정
- [x] 테마 설정

### Phase 2: Firebase 연동
- [ ] Firebase 설정
- [ ] 인증 시스템 구현
- [ ] 데이터베이스 연동
- [ ] 이미지 업로드 기능

### Phase 3: 핵심 기능
- [ ] 위치 기반 검색
- [ ] 밥친구 매칭 시스템
- [ ] 실시간 채팅
- [ ] 온도 시스템

### Phase 4: 고급 기능
- [ ] 푸시 알림
- [ ] 지도 통합
- [ ] 프로필 관리
- [ ] 설정 기능

## 🤝 기여하기

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다.

## 👥 팀

- **개발자**: 2명의 초급 학생
- **프로젝트 기간**: 3개월
- **목표**: 혼밥을 싫어하는 사람들을 위한 실용적인 앱 개발

---

**밥친구**와 함께 혼밥을 이겨내세요! 🍽️
