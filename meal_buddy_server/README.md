# 밥친구 (BapBuddy) NestJS 백엔드

혼밥을 싫어하는 사람들을 위한 1:1 밥친구 매칭 앱의 백엔드 서버입니다.

## 🛠 기술 스택

- **Framework**: NestJS (Node.js)
- **Language**: TypeScript
- **Database**: SQLite (파일 기반, 설치 불필요)
- **ORM**: TypeORM
- **Authentication**: JWT (Passport)
- **API Documentation**: Swagger/OpenAPI
- **Real-time Communication**: Socket.io
- **Validation**: class-validator, class-transformer
- **Password Hashing**: bcrypt

## 📁 프로젝트 구조

```
src/
├── config/                 # 설정 파일
│   ├── database.config.ts  # 데이터베이스 설정
│   ├── jwt.config.ts       # JWT 설정
│   └── swagger.config.ts   # Swagger 설정
├── common/                 # 공통 모듈
│   └── entities/           # 기본 엔티티
├── modules/                # 기능별 모듈
│   ├── auth/              # 인증 모듈
│   ├── users/             # 사용자 모듈
│   ├── friendships/       # 친구 관계 모듈
│   └── messages/          # 메시지 모듈
├── main.ts                # 애플리케이션 진입점
└── app.module.ts          # 루트 모듈
```

## 🚀 설치 및 실행

### 1. 의존성 설치

```bash
npm install
```

### 2. 환경 변수 설정

`.env` 파일을 생성하고 다음 내용을 추가하세요:

```env
# Database Configuration (SQLite)
DB_DATABASE=database.sqlite

# JWT Configuration
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
JWT_EXPIRES_IN=7d

# Application Configuration
PORT=3000
NODE_ENV=development

# CORS Configuration
CORS_ORIGIN=http://localhost:3000

# File Upload Configuration
UPLOAD_DEST=./uploads
MAX_FILE_SIZE=5242880
```

### 3. 개발 서버 실행

```bash
npm run start:dev
```

서버가 `http://localhost:3000`에서 실행됩니다.

### 4. API 문서 확인

Swagger UI: `http://localhost:3000/api`

## 📊 데이터베이스

### SQLite 특징
- **설치 불필요**: 파일 기반 데이터베이스
- **자동 생성**: `database.sqlite` 파일이 자동으로 생성됨
- **개발 친화적**: 별도 서버 설정 없이 바로 사용 가능

### 데이터베이스 초기화
개발 환경에서는 `synchronize: true`로 설정되어 있어 서버 시작 시 자동으로 테이블이 생성됩니다.

### 마이그레이션 (선택사항)
```bash
# 마이그레이션 생성
npm run migration:generate -- src/migrations/InitialMigration

# 마이그레이션 실행
npm run migration:run

# 마이그레이션 되돌리기
npm run migration:revert
```

## 🔑 주요 API 엔드포인트

### 인증 (Authentication)
- `POST /api/auth/register` - 회원가입
- `POST /api/auth/login` - 로그인

### 사용자 (Users)
- `GET /api/users/profile` - 내 프로필 조회
- `PATCH /api/users/profile` - 프로필 수정
- `POST /api/users/location` - 위치 업데이트
- `GET /api/users/nearby` - 근처 사용자 조회

### 친구 관계 (Friendships)
- `POST /api/friendships/request` - 친구 요청
- `GET /api/friendships` - 친구 목록 조회
- `PUT /api/friendships/:id/accept` - 친구 요청 수락
- `PUT /api/friendships/:id/reject` - 친구 요청 거절
- `DELETE /api/friendships/:id` - 친구 관계 삭제

### 메시지 (Messages)
- `GET /api/messages/:friendshipId` - 메시지 목록 조회
- `POST /api/messages/:friendshipId` - 메시지 전송
- `PUT /api/messages/:id/read` - 메시지 읽음 처리

## 🔌 Socket.io 이벤트

### 클라이언트 → 서버
- `join_room` - 채팅방 입장
- `leave_room` - 채팅방 퇴장
- `send_message` - 메시지 전송
- `typing` - 타이핑 상태 전송

### 서버 → 클라이언트
- `receive_message` - 메시지 수신
- `user_typing` - 상대방 타이핑 상태

## 🗄 데이터베이스 스키마

### Users (사용자)
- `id`: 기본 키
- `email`: 이메일 (고유)
- `password_hash`: 해시된 비밀번호
- `nickname`: 닉네임
- `food_preferences`: 음식 취향 (JSON 문자열)
- `profile_image_url`: 프로필 이미지 URL
- `latitude`, `longitude`: 위치 정보
- `last_active`: 마지막 활동 시간
- `is_online`: 온라인 상태

### Friendships (친구 관계)
- `id`: 기본 키
- `user_id`: 사용자 ID
- `friend_id`: 친구 ID
- `status`: 상태 (pending/accepted/rejected/blocked)
- `temperature`: 온도 (0-100)

### Messages (메시지)
- `id`: 기본 키
- `friendship_id`: 친구 관계 ID
- `sender_id`: 발신자 ID
- `content`: 메시지 내용
- `message_type`: 메시지 타입 (text/image/location)
- `image_url`: 이미지 URL
- `is_read`: 읽음 상태

### Temperature History (온도 기록)
- `id`: 기본 키
- `friendship_id`: 친구 관계 ID
- `old_temperature`: 이전 온도
- `new_temperature`: 새로운 온도
- `reason`: 변화 이유
- `description`: 설명

## 🔧 개발 가이드

### 새로운 모듈 추가
1. `src/modules/` 디렉토리에 새 모듈 생성
2. 엔티티, DTO, 서비스, 컨트롤러 파일 생성
3. `app.module.ts`에 모듈 등록

### 환경별 설정
- **Development**: `NODE_ENV=development`
- **Production**: `NODE_ENV=production`

### 로깅
개발 환경에서는 SQL 쿼리와 애플리케이션 로그가 콘솔에 출력됩니다.

## 🧪 테스트

```bash
# 단위 테스트
npm run test

# E2E 테스트
npm run test:e2e

# 테스트 커버리지
npm run test:cov
```

## 📦 빌드 및 배포

```bash
# 프로덕션 빌드
npm run build

# 프로덕션 실행
npm run start:prod
```

## 🔒 보안 고려사항

- JWT 시크릿 키를 프로덕션에서 변경하세요
- CORS 설정을 프로덕션 환경에 맞게 조정하세요
- 파일 업로드 크기 제한을 적절히 설정하세요

## 🐛 문제 해결

### SQLite 관련
- 데이터베이스 파일 권한 확인
- 디스크 공간 확인
- 동시 접근 제한 (SQLite는 단일 쓰기)

### 일반적인 문제
- 포트 충돌: 다른 포트 사용
- 의존성 문제: `node_modules` 삭제 후 재설치
- 환경 변수: `.env` 파일 확인

## 📞 지원

문제가 발생하면 이슈를 생성해 주세요.
