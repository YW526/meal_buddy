# 🌟 밥친구 프로그램 초보자 가이드

## 📋 목차
1. [프로그램 소개](#프로그램-소개)
2. [시스템 요구사항](#시스템-요구사항)
3. [설치 가이드](#설치-가이드)
4. [실행 방법](#실행-방법)
5. [사용법](#사용법)
6. [문제 해결](#문제-해결)
7. [자주 묻는 질문](#자주-묻는-질문)

---

## 🍽️ 프로그램 소개

**밥친구**는 혼밥을 싫어하는 사람들을 위한 1:1 밥친구 매칭 앱입니다.

### 주요 기능
- 👤 **회원가입/로그인**: 간단한 이메일 인증
- 🗺️ **위치 기반 매칭**: 근처의 밥친구 찾기
- 👥 **친구 요청**: 관심 있는 사용자에게 친구 신청
- 💬 **실시간 채팅**: 매칭된 친구와 대화
- 🍕 **음식 취향 설정**: 한식, 중식, 일식, 양식 등 선택
- 📱 **모바일 앱**: iOS, Android, 웹 브라우저 지원

### 기술 스택
- **프론트엔드**: Flutter (모바일 앱)
- **백엔드**: NestJS (Node.js)
- **데이터베이스**: SQLite (파일 기반, 설치 불필요)
- **실시간 통신**: Socket.io

---

## 💻 시스템 요구사항

### 개발 환경
- **운영체제**: macOS, Windows, Linux
- **Node.js**: 18.x 이상
- **Flutter**: 3.24.0 이상
- **메모리**: 최소 8GB RAM
- **저장공간**: 최소 2GB 여유 공간

### 사용자 환경
- **모바일**: iOS 12.0+ / Android 8.0+
- **웹 브라우저**: Chrome, Safari, Firefox 최신 버전
- **인터넷**: 안정적인 인터넷 연결

---

## 🔧 설치 가이드

### 1단계: 개발 도구 설치

#### Node.js 설치
```bash
# macOS (Homebrew 사용)
brew install node

# Windows
# https://nodejs.org 에서 LTS 버전 다운로드

# Linux
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
```

#### Flutter 설치
```bash
# macOS
brew install --cask flutter

# Windows/Linux
# https://flutter.dev/docs/get-started/install 에서 다운로드
```

### 2단계: 프로젝트 다운로드
```bash
# 프로젝트 폴더로 이동
cd /Users/pcfriend/Desktop/freePro/학습/밥친구

# 현재 위치 확인
pwd
```

### 3단계: 백엔드 서버 설정

```bash
# 백엔드 폴더로 이동
cd meal_buddy_server

# 의존성 설치
npm install

# 환경 설정 파일 생성
cp env.example .env

# 환경 설정 파일 편집 (선택사항)
# .env 파일에서 데이터베이스 설정 확인
```

### 4단계: 모바일 앱 설정

```bash
# 앱 폴더로 이동
cd ../meal_buddy_app

# Flutter 의존성 설치
flutter pub get

# iOS 시뮬레이터 실행 (macOS만)
open -a Simulator

# 안드로이드 에뮬레이터 실행
# Android Studio에서 AVD Manager 실행
```

---

## 🚀 실행 방법

### 백엔드 서버 실행
```bash
# 백엔드 폴더에서
cd meal_buddy_server

# 개발 모드로 서버 실행
npm run start:dev
```

**성공 메시지:**
```
[Nest] 12345  - 2025. 08. 31. 오후 6:24:11     LOG [NestApplication] Nest application successfully started +1ms
Application is running on: http://localhost:3000
Swagger documentation is available at: http://localhost:3000/api
```

### 모바일 앱 실행

#### iOS 시뮬레이터
```bash
# 사용 가능한 디바이스 확인
flutter devices

# iOS 시뮬레이터에서 실행
flutter run -d [디바이스_ID]
```

#### 안드로이드 폰/에뮬레이터
```bash
# 안드로이드 디바이스에서 실행
flutter run -d [디바이스_ID]
```

#### 웹 브라우저
```bash
# 웹 브라우저에서 실행
flutter run -d chrome
```

---

## 📱 사용법

### 1. 회원가입
1. 앱 실행 후 "회원가입" 버튼 클릭
2. 다음 정보 입력:
   - **이메일**: 실제 사용하는 이메일 주소
   - **비밀번호**: 6자 이상
   - **닉네임**: 다른 사용자에게 보여질 이름
   - **음식 취향**: 원하는 음식 종류 선택 (복수 선택 가능)
3. "회원가입" 버튼 클릭

### 2. 로그인
1. "로그인" 화면에서 이메일과 비밀번호 입력
2. "로그인" 버튼 클릭
3. 성공 시 메인 화면으로 이동

### 3. 프로필 설정
1. 메인 화면에서 프로필 아이콘 클릭
2. 다음 정보 수정 가능:
   - 프로필 이미지
   - 닉네임
   - 음식 취향
   - 위치 정보

### 4. 친구 찾기
1. "친구 찾기" 메뉴 클릭
2. 근처의 사용자 목록 확인
3. 관심 있는 사용자에게 친구 요청

### 5. 채팅
1. 친구 목록에서 대화하고 싶은 친구 선택
2. 메시지 입력 후 전송
3. 실시간으로 대화 가능

---

## 🔍 문제 해결

### 백엔드 서버 문제

#### 포트 3000이 이미 사용 중
```bash
# 포트 사용 확인
lsof -i :3000

# 프로세스 종료
kill -9 [프로세스_ID]
```

#### 데이터베이스 오류
```bash
# 데이터베이스 파일 삭제 후 재생성
rm database.sqlite
npm run start:dev
```

#### 의존성 설치 오류
```bash
# node_modules 삭제 후 재설치
rm -rf node_modules package-lock.json
npm install
```

### 모바일 앱 문제

#### 빌드 오류
```bash
# Flutter 캐시 정리
flutter clean
flutter pub get
```

#### 시뮬레이터 연결 문제
```bash
# 사용 가능한 디바이스 확인
flutter devices

# 시뮬레이터 재시작
# iOS: Simulator 앱에서 Device > Erase All Content and Settings
# Android: AVD Manager에서 에뮬레이터 재시작
```

#### API 연결 오류
- 백엔드 서버가 실행 중인지 확인
- `http://127.0.0.1:3000`에서 서버 응답 확인
- 방화벽 설정 확인

### 일반적인 오류

#### "요청한 리소스를 찾을 수 없습니다"
- 백엔드 서버가 실행 중인지 확인
- API baseUrl이 올바른지 확인 (`http://127.0.0.1:3000`)

#### "이미 존재하는 이메일입니다"
- 다른 이메일 주소로 회원가입
- 기존 계정으로 로그인

#### "이메일 또는 비밀번호가 잘못되었습니다"
- 이메일과 비밀번호를 정확히 입력했는지 확인
- 회원가입을 먼저 완료했는지 확인

---

## ❓ 자주 묻는 질문

### Q: 밥친구 앱은 무료인가요?
A: 네, 현재 개발 버전은 완전 무료입니다.

### Q: 실제 위치 기반 매칭이 가능한가요?
A: 현재는 개발 버전으로 위치 서비스가 임시 비활성화되어 있습니다. 추후 업데이트 예정입니다.

### Q: 안전한가요?
A: 개발 버전이므로 실제 사용 시 주의가 필요합니다. 개인정보 보호를 위해 테스트용 이메일을 사용하세요.

### Q: 여러 기기에서 사용할 수 있나요?
A: 네, 웹 브라우저, iOS, Android 모든 플랫폼에서 사용 가능합니다.

### Q: 친구 요청을 거절할 수 있나요?
A: 네, 친구 요청을 받으면 수락하거나 거절할 수 있습니다.

### Q: 채팅 기록이 저장되나요?
A: 현재는 앱을 종료하면 채팅 기록이 사라집니다. 추후 업데이트 예정입니다.

### Q: 음식 취향을 나중에 변경할 수 있나요?
A: 네, 프로필 설정에서 언제든지 음식 취향을 변경할 수 있습니다.

### Q: 계정을 삭제할 수 있나요?
A: 현재는 계정 삭제 기능이 제공되지 않습니다. 추후 업데이트 예정입니다.

---

## 📞 지원 및 문의

### 개발자 정보
- **프로젝트**: 밥친구 (Meal Buddy)
- **버전**: 1.0.0
- **개발 언어**: TypeScript, Dart
- **프레임워크**: NestJS, Flutter

### 문서 및 리소스
- **API 문서**: http://localhost:3000/api (서버 실행 시)
- **Flutter 문서**: https://flutter.dev/docs
- **NestJS 문서**: https://nestjs.com

### 문제 신고
개발 중 문제가 발생하면 다음 정보와 함께 신고해주세요:
- 오류 메시지
- 사용 중인 기기/브라우저
- 실행한 명령어
- 오류 발생 시점

---

## 🎉 축하합니다!

이제 밥친구 프로그램을 성공적으로 설치하고 사용할 수 있습니다! 

혼밥을 싫어하는 사람들과 함께 맛있는 식사를 즐겨보세요! 🍜🍕🍣

**즐거운 밥친구 매칭 되세요!** 🎊
