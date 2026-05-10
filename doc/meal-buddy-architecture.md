# 밥친구 (BapBuddy) - NestJS 백엔드 아키텍처

## 1. 프로젝트 개요

### 1.1 프로젝트 목적
- 혼밥을 하기 싫어하는 사람들을 위한 밥친구 매칭 앱
- 근방 1km 이내의 사용자를 찾아 밥 취향에 따라 매칭
- 실시간 채팅과 밥친구 온도 시스템을 통한 관계 관리

### 1.2 기술 스택
- **Frontend**: Flutter (Dart)
- **Backend**: NestJS (Node.js)
- **Database**: PostgreSQL
- **ORM**: TypeORM
- **Real-time Communication**: Socket.io
- **API Documentation**: Swagger/OpenAPI
- **File Storage**: Local Storage / AWS S3
- **Maps API**: Naver Map API / Google Maps API
- **State Management**: GetX (Flutter)

## 2. 시스템 아키텍처

### 2.1 전체 시스템 구조
```
┌─────────────────┐    HTTP/WebSocket    ┌─────────────────┐
│   Flutter App   │ ◄──────────────────► │   NestJS Backend│
│   (Mobile/Web)  │                      │   (Node.js)     │
└─────────────────┘                      └─────────────────┘
                                                │
                                                ▼
                                        ┌─────────────────┐
                                        │   PostgreSQL    │
                                        │   Database      │
                                        └─────────────────┘
                                                │
                                                ▼
                                        ┌─────────────────┐
                                        │   File Storage  │
                                        │   (Local/S3)    │
                                        └─────────────────┘
```

### 2.2 백엔드 구조 (NestJS)
```
meal_buddy_server/
├── src/
│   ├── main.ts                    # 애플리케이션 진입점
│   ├── app.module.ts              # 루트 모듈
│   ├── app.controller.ts          # 루트 컨트롤러
│   ├── app.service.ts             # 루트 서비스
│   ├── config/                    # 설정 파일
│   │   ├── database.config.ts     # 데이터베이스 설정
│   │   ├── jwt.config.ts          # JWT 설정
│   │   └── swagger.config.ts      # Swagger 설정
│   ├── modules/                   # 기능별 모듈
│   │   ├── auth/                  # 인증 모듈
│   │   │   ├── auth.module.ts
│   │   │   ├── auth.controller.ts
│   │   │   ├── auth.service.ts
│   │   │   ├── guards/
│   │   │   │   └── jwt-auth.guard.ts
│   │   │   └── strategies/
│   │   │       └── jwt.strategy.ts
│   │   ├── users/                 # 사용자 모듈
│   │   │   ├── users.module.ts
│   │   │   ├── users.controller.ts
│   │   │   ├── users.service.ts
│   │   │   ├── entities/
│   │   │   │   └── user.entity.ts
│   │   │   └── dto/
│   │   │       ├── create-user.dto.ts
│   │   │       └── update-user.dto.ts
│   │   ├── friendships/           # 친구 관계 모듈
│   │   │   ├── friendships.module.ts
│   │   │   ├── friendships.controller.ts
│   │   │   ├── friendships.service.ts
│   │   │   ├── entities/
│   │   │   │   └── friendship.entity.ts
│   │   │   └── dto/
│   │   │       ├── create-friendship.dto.ts
│   │   │       └── update-friendship.dto.ts
│   │   ├── messages/              # 메시지 모듈
│   │   │   ├── messages.module.ts
│   │   │   ├── messages.controller.ts
│   │   │   ├── messages.service.ts
│   │   │   ├── entities/
│   │   │   │   └── message.entity.ts
│   │   │   └── dto/
│   │   │       ├── create-message.dto.ts
│   │   │       └── update-message.dto.ts
│   │   └── locations/             # 위치 모듈
│   │       ├── locations.module.ts
│   │       ├── locations.controller.ts
│   │       ├── locations.service.ts
│   │       └── dto/
│   │           └── update-location.dto.ts
│   ├── common/                    # 공통 모듈
│   │   ├── decorators/            # 커스텀 데코레이터
│   │   ├── filters/               # 예외 필터
│   │   ├── guards/                # 가드
│   │   ├── interceptors/          # 인터셉터
│   │   └── pipes/                 # 파이프
│   ├── database/                  # 데이터베이스 관련
│   │   ├── migrations/            # 마이그레이션
│   │   └── seeds/                 # 시드 데이터
│   └── utils/                     # 유틸리티
│       ├── helpers.ts
│       └── validators.ts
├── test/                          # 테스트 파일
├── dist/                          # 빌드 결과물
├── package.json                   # 의존성 및 스크립트
├── tsconfig.json                  # TypeScript 설정
├── nest-cli.json                  # NestJS CLI 설정
├── ormconfig.ts                   # TypeORM 설정
└── README.md                      # 백엔드 문서
```

### 2.3 프론트엔드 구조 (Flutter)
```
meal_buddy_app/
├── lib/
│   ├── main.dart                # 앱 진입점
│   ├── app/
│   │   ├── app.dart             # 앱 설정
│   │   ├── theme.dart           # 테마 설정
│   │   └── routes.dart          # 라우트 설정
│   ├── core/
│   │   ├── constants/           # 상수 정의
│   │   ├── services/            # 서비스 클래스
│   │   │   ├── api_service.dart # API 통신 서비스
│   │   │   ├── auth_service.dart # 인증 서비스
│   │   │   ├── location_service.dart # 위치 서비스
│   │   │   └── socket_service.dart # Socket.io 서비스
│   │   ├── models/              # 데이터 모델
│   │   └── utils/               # 유틸리티
│   ├── presentation/
│   │   ├── screens/             # 화면 위젯
│   │   ├── widgets/             # 재사용 위젯
│   │   └── controllers/         # GetX 컨트롤러
│   └── data/
│       ├── repositories/        # 데이터 저장소
│       └── datasources/         # 데이터 소스
├── assets/                      # 리소스 파일
└── pubspec.yaml                 # Flutter 의존성
```

## 3. 데이터베이스 설계

### 3.1 PostgreSQL 테이블 구조

#### users 테이블
```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    nickname VARCHAR(100) NOT NULL,
    food_preferences TEXT[], -- 배열 형태로 저장
    profile_image_url VARCHAR(500),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    last_active TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_online BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### friendships 테이블
```sql
CREATE TABLE friendships (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    friend_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    status VARCHAR(20) DEFAULT 'pending', -- pending, accepted, rejected, blocked
    temperature INTEGER DEFAULT 50, -- 0-100
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, friend_id)
);
```

#### messages 테이블
```sql
CREATE TABLE messages (
    id SERIAL PRIMARY KEY,
    friendship_id INTEGER REFERENCES friendships(id) ON DELETE CASCADE,
    sender_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    message_type VARCHAR(20) DEFAULT 'text', -- text, image, location
    image_url VARCHAR(500),
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### temperature_history 테이블
```sql
CREATE TABLE temperature_history (
    id SERIAL PRIMARY KEY,
    friendship_id INTEGER REFERENCES friendships(id) ON DELETE CASCADE,
    old_temperature INTEGER,
    new_temperature INTEGER,
    reason VARCHAR(100), -- accept, reject, chat, negative, positive
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 4. API 설계

### 4.1 인증 API
```
POST /api/auth/register          # 회원가입
POST /api/auth/login             # 로그인
POST /api/auth/logout            # 로그아웃
POST /api/auth/refresh           # 토큰 갱신
```

### 4.2 사용자 API
```
GET    /api/users/profile        # 내 프로필 조회
PUT    /api/users/profile        # 프로필 수정
GET    /api/users/nearby         # 근처 사용자 조회
POST   /api/users/location       # 위치 업데이트
```

### 4.3 친구 API
```
GET    /api/friendships          # 친구 목록 조회
POST   /api/friendships/request  # 친구 요청
PUT    /api/friendships/accept   # 친구 요청 수락
PUT    /api/friendships/reject   # 친구 요청 거절
DELETE /api/friendships/:id      # 친구 관계 삭제
```

### 4.4 메시지 API
```
GET    /api/messages/:friendship_id  # 메시지 조회
POST   /api/messages             # 메시지 전송
PUT    /api/messages/read        # 메시지 읽음 처리
```

### 4.5 Socket.io 이벤트
```
connect                          # 연결
disconnect                       # 연결 해제
join_room                        # 채팅방 입장
leave_room                       # 채팅방 퇴장
send_message                     # 메시지 전송
typing                           # 타이핑 상태
user_online                      # 온라인 상태
user_offline                     # 오프라인 상태
```

## 5. 개발 단계별 계획

### 5.1 1단계: 환경 설정 및 기본 구조 (1주)
- NestJS 백엔드 프로젝트 생성
- PostgreSQL 데이터베이스 설정
- TypeORM 설정 및 엔티티 정의
- Swagger API 문서화 설정

### 5.2 2단계: 인증 시스템 (1주)
- JWT 기반 인증 구현
- 사용자 등록/로그인 API 구현
- 가드 및 전략 구현
- Flutter에서 API 통신 구현

### 5.3 3단계: 사용자 관리 (1주)
- 사용자 프로필 관리 API
- 위치 기반 사용자 검색
- Flutter UI 구현

### 5.4 4단계: 친구 시스템 (2주)
- 친구 요청/수락/거절 API
- 밥친구 온도 시스템 구현
- Flutter 친구 목록 UI

### 5.5 5단계: 실시간 채팅 (2주)
- Socket.io를 이용한 WebSocket 구현
- 실시간 메시지 전송
- Flutter 채팅 UI 구현

### 5.6 6단계: 테스트 및 최적화 (1주)
- 단위 테스트 작성
- 통합 테스트
- 성능 최적화

## 6. 팀 구성 및 역할

### 6.1 팀 구성 (4명)
- **팀장**: 전체 프로젝트 관리 및 백엔드 개발
- **백엔드 개발자**: NestJS API 및 데이터베이스 개발
- **프론트엔드 개발자 1**: Flutter UI/UX 개발
- **프론트엔드 개발자 2**: Flutter 기능 개발

### 6.2 역할 분담
- **백엔드**: NestJS API, PostgreSQL, Socket.io
- **프론트엔드**: Flutter UI, 상태 관리, API 통신
- **공통**: 테스트, 문서화, 배포

## 7. 기술적 고려사항

### 7.1 보안
- JWT 토큰 기반 인증
- 비밀번호 해싱 (bcrypt)
- API 요청 검증
- CORS 설정

### 7.2 성능
- 데이터베이스 인덱싱
- API 응답 캐싱
- 이미지 압축 및 최적화
- Socket.io 연결 관리

### 7.3 확장성
- 모듈화된 코드 구조
- 환경별 설정 분리
- 로깅 및 모니터링
- 에러 핸들링

## 8. 배포 및 운영

### 8.1 개발 환경
- NestJS 개발 서버
- PostgreSQL 로컬 설치
- Flutter 개발 모드

### 8.2 테스트 환경
- Docker를 이용한 환경 구성
- 자동화된 테스트 실행
- API 문서화 (Swagger)

### 8.3 운영 환경 (선택사항)
- AWS EC2 또는 Heroku 배포
- PostgreSQL 클라우드 서비스
- 도메인 및 SSL 인증서 설정