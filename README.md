# 🍽️ 밥친구 (Meal Buddy)

혼밥을 싫어하는 사람들을 위한 1:1 밥친구 매칭 앱

[![Flutter](https://img.shields.io/badge/Flutter-3.24.0-blue.svg)](https://flutter.dev/)
[![NestJS](https://img.shields.io/badge/NestJS-10.0.0-red.svg)](https://nestjs.com/)
[![SQLite](https://img.shields.io/badge/SQLite-3.0-green.svg)](https://www.sqlite.org/)

## 📋 목차

- [프로젝트 소개](#프로젝트-소개)
- [주요 기능](#주요-기능)
- [기술 스택](#기술-스택)
- [빠른 시작](#빠른-시작)
- [설치 가이드](#설치-가이드)
- [사용법](#사용법)
- [API 문서](#api-문서)
- [개발 가이드](#개발-가이드)
- [문제 해결](#문제-해결)
- [기여하기](#기여하기)

---

## 🎯 프로젝트 소개

**밥친구**는 혼밥을 싫어하는 사람들이 근처의 밥친구를 찾아 함께 식사를 즐길 수 있도록 도와주는 모바일 앱입니다.

### 🌟 핵심 가치
- **연결**: 혼밥을 싫어하는 사람들을 연결
- **편의성**: 간단하고 직관적인 사용자 인터페이스
- **안전성**: 사용자 인증 및 프로필 관리
- **실시간성**: 실시간 채팅 및 위치 기반 매칭

---

## ✨ 주요 기능

### 👤 사용자 관리
- 간단한 이메일 회원가입/로그인
- 프로필 설정 및 관리
- 음식 취향 설정 (한식, 중식, 일식, 양식 등)

### 🗺️ 위치 기반 매칭
- GPS 기반 근처 사용자 검색
- 거리 기반 필터링
- 실시간 위치 업데이트

### 👥 친구 관리
- 친구 요청 및 수락/거절
- 친구 목록 관리
- 온라인 상태 확인

### 💬 실시간 채팅
- 1:1 실시간 메시지
- 타이핑 상태 표시
- 메시지 읽음 확인

### 📱 크로스 플랫폼
- iOS 앱
- Android 앱
- 웹 브라우저 지원

---

## 🛠️ 기술 스택

### Frontend
- **Flutter 3.24.0** - 크로스 플랫폼 모바일 앱
- **Dart** - 프로그래밍 언어
- **GetX** - 상태 관리
- **Dio** - HTTP 클라이언트
- **Socket.io** - 실시간 통신

### Backend
- **NestJS 10.0.0** - Node.js 프레임워크
- **TypeScript** - 프로그래밍 언어
- **TypeORM** - ORM
- **SQLite** - 데이터베이스
- **JWT** - 인증
- **Socket.io** - 실시간 통신

### Development Tools
- **Swagger** - API 문서화
- **ESLint** - 코드 품질
- **Prettier** - 코드 포맷팅

---

## 🚀 빠른 시작

### 백엔드 서버 실행
```bash
# 백엔드 서버 실행
cd meal_buddy_server
npm install
npm run start:dev
```

### 모바일 앱 실행
```bash
# 모바일 앱 실행 (새 터미널에서)
cd meal_buddy_app
flutter pub get
flutter run
```

---

## 📖 설치 가이드

### 시스템 요구사항
- **Node.js**: 18.x 이상
- **Flutter**: 3.24.0 이상
- **메모리**: 최소 8GB RAM
- **저장공간**: 최소 2GB 여유 공간

### 상세 설치 가이드
📖 [초보자 가이드](doc/beginner-guide.md) - 완전한 설치 및 사용 가이드

---

## 📱 사용법

### 회원가입
1. 앱 실행 후 "회원가입" 버튼 클릭
2. 이메일, 비밀번호, 닉네임 입력
3. 음식 취향 선택
4. 회원가입 완료

### 로그인
1. 이메일과 비밀번호 입력
2. 로그인 버튼 클릭
3. 메인 화면으로 이동

### 친구 찾기
1. "친구 찾기" 메뉴 클릭
2. 근처의 사용자 목록 확인
3. 관심 있는 사용자에게 친구 요청

### 채팅
1. 친구 목록에서 대화할 친구 선택
2. 메시지 입력 후 전송
3. 실시간으로 대화

---

## 📚 API 문서

### Swagger UI
서버 실행 후 다음 주소에서 API 문서를 확인할 수 있습니다:
```
http://localhost:3000/api
```

### 주요 API 엔드포인트

#### 인증
- `POST /auth/register` - 회원가입
- `POST /auth/login` - 로그인

#### 사용자
- `GET /users/profile` - 프로필 조회
- `PATCH /users/profile` - 프로필 수정
- `POST /users/location` - 위치 업데이트
- `GET /users/nearby` - 근처 사용자 검색

#### 친구
- `POST /friendships/request` - 친구 요청
- `GET /friendships` - 친구 목록
- `PUT /friendships/:id/accept` - 친구 요청 수락
- `PUT /friendships/:id/reject` - 친구 요청 거절

#### 메시지
- `POST /messages/:friendshipId` - 메시지 전송
- `GET /messages/:friendshipId` - 메시지 목록
- `PUT /messages/:id/read` - 메시지 읽음 처리

---

## 👨‍💻 개발 가이드

### 프로젝트 구조
```
밥친구/
├── meal_buddy_server/     # 백엔드 서버 (NestJS)
├── meal_buddy_app/        # 모바일 앱 (Flutter)
├── doc/                   # 문서
└── README.md             # 프로젝트 설명
```

### 개발 환경 설정
```bash
# 백엔드 개발
cd meal_buddy_server
npm run start:dev

# 프론트엔드 개발
cd meal_buddy_app
flutter run
```

### 데이터베이스 마이그레이션
```bash
cd meal_buddy_server
npm run migration:generate
npm run migration:run
```

---

## 🔧 문제 해결

### 일반적인 문제

#### 백엔드 서버 실행 오류
```bash
# 포트 3000 사용 확인
lsof -i :3000

# 프로세스 종료
pkill -f "npm run start:dev"
```

#### Flutter 빌드 오류
```bash
# 캐시 정리
flutter clean
flutter pub get
```

#### API 연결 오류
- 백엔드 서버가 실행 중인지 확인
- `http://localhost:3000`에서 서버 응답 확인

### 자세한 문제 해결
📖 [초보자 가이드 - 문제 해결](doc/beginner-guide.md#문제-해결) 섹션 참조

---

## 🤝 기여하기

### 기여 방법
1. 이 저장소를 Fork
2. 새로운 브랜치 생성 (`git checkout -b feature/amazing-feature`)
3. 변경사항 커밋 (`git commit -m 'Add amazing feature'`)
4. 브랜치에 Push (`git push origin feature/amazing-feature`)
5. Pull Request 생성

### 개발 가이드라인
- 코드 스타일 가이드 준수
- 테스트 코드 작성
- 문서 업데이트

---

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.

---

## 📞 지원 및 문의

### 개발자 정보
- **프로젝트**: 밥친구 (Meal Buddy)
- **버전**: 1.0.0
- **개발 언어**: TypeScript, Dart
- **프레임워크**: NestJS, Flutter

### 문서 및 리소스
- **초보자 가이드**: [doc/beginner-guide.md](doc/beginner-guide.md)
- **API 문서**: http://localhost:3000/api (서버 실행 시)
- **Flutter 문서**: https://flutter.dev/docs
- **NestJS 문서**: https://nestjs.com

### 문제 신고
개발 중 문제가 발생하면 다음 정보와 함께 이슈를 생성해주세요:
- 오류 메시지
- 사용 중인 기기/브라우저
- 실행한 명령어
- 오류 발생 시점

---

## 🎉 감사의 말

이 프로젝트는 혼밥을 싫어하는 모든 분들을 위해 만들어졌습니다.

**즐거운 밥친구 매칭 되세요!** 🍜🍕🍣

---

<div align="center">

**Made with ❤️ for food lovers**

[![Flutter](https://img.shields.io/badge/Flutter-3.24.0-blue.svg)](https://flutter.dev/)
[![NestJS](https://img.shields.io/badge/NestJS-10.0.0-red.svg)](https://nestjs.com/)
[![SQLite](https://img.shields.io/badge/SQLite-3.0-green.svg)](https://www.sqlite.org/)

</div>
