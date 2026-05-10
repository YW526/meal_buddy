# API 설계

## 📋 API 개요

밥친구 애플리케이션의 RESTful API 설계 문서입니다.

### 기본 정보
- **Base URL**: `http://localhost:3000/api`
- **Content-Type**: `application/json`
- **인증 방식**: JWT Bearer Token
- **문서**: Swagger UI (`/api`)

## 🔐 인증 API

### 회원가입
```http
POST /auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123",
  "nickname": "밥친구",
  "food_preferences": ["한식", "중식"],
  "profile_image_url": "https://example.com/image.jpg"
}
```

**응답**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "email": "user@example.com",
    "nickname": "밥친구",
    "food_preferences": ["한식", "중식"],
    "profile_image_url": "https://example.com/image.jpg"
  }
}
```

### 로그인
```http
POST /auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

**응답**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "email": "user@example.com",
    "nickname": "밥친구"
  }
}
```

## 👤 사용자 API

### 내 프로필 조회
```http
GET /users/profile
Authorization: Bearer {token}
```

### 프로필 수정
```http
PATCH /users/profile
Authorization: Bearer {token}
Content-Type: application/json

{
  "nickname": "새로운닉네임",
  "food_preferences": ["한식", "양식", "일식"]
}
```

### 위치 업데이트
```http
POST /users/location
Authorization: Bearer {token}
Content-Type: application/json

{
  "latitude": 37.5665,
  "longitude": 126.9780
}
```

### 근처 사용자 조회
```http
GET /users/nearby?latitude=37.5665&longitude=126.9780&maxDistance=1000
Authorization: Bearer {token}
```

**응답**
```json
[
  {
    "user": {
      "id": 2,
      "nickname": "다른사용자",
      "food_preferences": ["한식"],
      "profile_image_url": "https://example.com/image2.jpg"
    },
    "distance": 150.5
  }
]
```

## 👥 친구 관계 API

### 친구 요청
```http
POST /friendships/request
Authorization: Bearer {token}
Content-Type: application/json

{
  "friend_id": 2
}
```

### 친구 목록 조회
```http
GET /friendships
Authorization: Bearer {token}
```

**응답**
```json
[
  {
    "id": 1,
    "user_id": 1,
    "friend_id": 2,
    "status": "accepted",
    "temperature": 75,
    "user": {
      "id": 1,
      "nickname": "나"
    },
    "friend": {
      "id": 2,
      "nickname": "친구"
    }
  }
]
```

### 친구 요청 수락
```http
PUT /friendships/{id}/accept
Authorization: Bearer {token}
```

### 친구 요청 거절
```http
PUT /friendships/{id}/reject
Authorization: Bearer {token}
```

### 친구 관계 삭제
```http
DELETE /friendships/{id}
Authorization: Bearer {token}
```

## 💬 메시지 API

### 메시지 전송
```http
POST /messages/{friendshipId}
Authorization: Bearer {token}
Content-Type: application/json

{
  "content": "안녕하세요! 밥 같이 먹을까요?",
  "message_type": "text"
}
```

### 메시지 조회
```http
GET /messages/{friendshipId}?limit=50&offset=0
Authorization: Bearer {token}
```

**응답**
```json
[
  {
    "id": 1,
    "friendship_id": 1,
    "sender_id": 1,
    "content": "안녕하세요!",
    "message_type": "text",
    "is_read": false,
    "sender": {
      "id": 1,
      "nickname": "나"
    },
    "created_at": "2024-08-30T10:00:00Z"
  }
]
```

### 메시지 읽음 처리
```http
PUT /messages/{id}/read
Authorization: Bearer {token}
```

## 📍 위치 API

### 위치 기반 사용자 검색
```http
GET /users/nearby?latitude=37.5665&longitude=126.9780&maxDistance=1000
Authorization: Bearer {token}
```

## 🔌 Socket.io 이벤트

### 연결
```javascript
// 클라이언트 연결
socket.connect();

// 서버 연결 확인
socket.on('connect', () => {
  console.log('Connected to server');
});
```

### 채팅방 입장
```javascript
// 채팅방 입장
socket.emit('join_room', { friendship_id: 1 });

// 채팅방 입장 확인
socket.on('joined_room', (data) => {
  console.log('Joined room:', data.room);
});
```

### 메시지 전송
```javascript
// 메시지 전송
socket.emit('send_message', {
  friendship_id: 1,
  content: '안녕하세요!',
  message_type: 'text'
});

// 메시지 수신
socket.on('receive_message', (message) => {
  console.log('New message:', message);
});
```

### 타이핑 상태
```javascript
// 타이핑 시작
socket.emit('typing', { friendship_id: 1, is_typing: true });

// 타이핑 상태 수신
socket.on('user_typing', (data) => {
  console.log('User typing:', data);
});
```

### 온라인 상태
```javascript
// 온라인 상태 업데이트
socket.emit('user_online', { user_id: 1 });

// 사용자 온라인 상태 수신
socket.on('user_status_change', (data) => {
  console.log('User status:', data);
});
```

## 📊 응답 코드

### 성공 응답
- `200 OK`: 요청 성공
- `201 Created`: 리소스 생성 성공
- `204 No Content`: 요청 성공 (응답 본문 없음)

### 클라이언트 오류
- `400 Bad Request`: 잘못된 요청
- `401 Unauthorized`: 인증 실패
- `403 Forbidden`: 권한 없음
- `404 Not Found`: 리소스 없음
- `409 Conflict`: 리소스 충돌

### 서버 오류
- `500 Internal Server Error`: 서버 내부 오류
- `502 Bad Gateway`: 게이트웨이 오류
- `503 Service Unavailable`: 서비스 불가

## 🔍 에러 응답 형식

```json
{
  "statusCode": 400,
  "message": "잘못된 요청입니다.",
  "error": "Bad Request",
  "details": [
    {
      "field": "email",
      "message": "이메일 형식이 올바르지 않습니다."
    }
  ]
}
```

## 📝 API 사용 예시

### Flutter에서 API 호출
```dart
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();
  
  Future<void> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      
      // 토큰 저장
      final token = response.data['access_token'];
      _dio.options.headers['Authorization'] = 'Bearer $token';
      
    } catch (e) {
      print('Login failed: $e');
    }
  }
  
  Future<List<dynamic>> getNearbyUsers(double lat, double lng) async {
    try {
      final response = await _dio.get('/users/nearby', queryParameters: {
        'latitude': lat,
        'longitude': lng,
        'maxDistance': 1000,
      });
      
      return response.data;
    } catch (e) {
      print('Get nearby users failed: $e');
      return [];
    }
  }
}
```

### JavaScript에서 Socket.io 사용
```javascript
import io from 'socket.io-client';

const socket = io('http://localhost:3000', {
  auth: {
    token: 'your-jwt-token'
  }
});

// 메시지 전송
function sendMessage(friendshipId, content) {
  socket.emit('send_message', {
    friendship_id: friendshipId,
    content: content,
    message_type: 'text'
  });
}

// 메시지 수신
socket.on('receive_message', (message) => {
  console.log('New message:', message);
  // UI 업데이트
});
```

## 🔧 API 테스트

### Swagger UI
- URL: `http://localhost:3000/api`
- 기능: API 문서 확인 및 테스트

### Postman Collection
```json
{
  "info": {
    "name": "밥친구 API",
    "description": "밥친구 애플리케이션 API"
  },
  "item": [
    {
      "name": "인증",
      "item": [
        {
          "name": "회원가입",
          "request": {
            "method": "POST",
            "url": "{{baseUrl}}/auth/register"
          }
        }
      ]
    }
  ]
}
```

---

**버전**: 1.0.0  
**최종 업데이트**: 2024-08-30  
**작성자**: 개발팀
