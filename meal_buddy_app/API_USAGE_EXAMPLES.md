# API 사용 예시

## 🔐 인증 관련

### 회원가입
```dart
import 'package:get/get.dart';
import 'presentation/controllers/auth_controller.dart';

class RegisterScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  
  Future<void> register() async {
    final success = await authController.register(
      email: 'user@example.com',
      password: 'password123',
      confirmPassword: 'password123',
      nickname: '밥친구',
      foodPreferences: ['한식', '중식'],
      profileImageUrl: 'https://example.com/image.jpg', // 선택사항
    );
    
    if (success) {
      Get.offAllNamed('/home'); // 홈 화면으로 이동
    }
  }
}
```

### 로그인
```dart
Future<void> login() async {
  final success = await authController.login(
    email: 'user@example.com',
    password: 'password123',
  );
  
  if (success) {
    Get.offAllNamed('/home');
  }
}
```

### 로그아웃
```dart
Future<void> logout() async {
  await authController.logout();
}
```

### 프로필 업데이트
```dart
Future<void> updateProfile() async {
  final success = await authController.updateProfile(
    nickname: '새로운닉네임',
    foodPreferences: ['한식', '양식', '일식'],
    profileImageUrl: 'https://example.com/new-image.jpg',
  );
  
  if (success) {
    Get.snackbar('성공', '프로필이 업데이트되었습니다.');
  }
}
```

## 👥 친구 관계

### 친구 목록 로드
```dart
import 'presentation/controllers/friendship_controller.dart';

class FriendsScreen extends StatelessWidget {
  final FriendshipController friendshipController = Get.put(FriendshipController());
  
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (friendshipController.isLoading) {
        return CircularProgressIndicator();
      }
      
      return ListView.builder(
        itemCount: friendshipController.friendships.length,
        itemBuilder: (context, index) {
          final friendship = friendshipController.friendships[index];
          return ListTile(
            title: Text(friendship['friend']['nickname']),
            subtitle: Text('온도: ${friendship['temperature']}°'),
          );
        },
      );
    });
  }
}
```

### 근처 사용자 조회
```dart
Future<void> loadNearbyUsers() async {
  await friendshipController.loadNearbyUsers(
    latitude: 37.5665,
    longitude: 126.9780,
    maxDistance: 1000, // 1km
  );
}
```

### 친구 요청 보내기
```dart
Future<void> sendFriendRequest(int userId) async {
  final success = await friendshipController.sendFriendRequest(userId);
  if (success) {
    // 요청 성공 처리
  }
}
```

### 친구 요청 수락/거절
```dart
Future<void> respondToRequest(int friendshipId, bool accept) async {
  final success = accept 
    ? await friendshipController.acceptFriendRequest(friendshipId)
    : await friendshipController.rejectFriendRequest(friendshipId);
    
  if (success) {
    // 응답 성공 처리
  }
}
```

## 💬 채팅

### 채팅방 입장
```dart
import 'presentation/controllers/chat_controller.dart';

class ChatScreen extends StatelessWidget {
  final ChatController chatController = Get.put(ChatController());
  
  @override
  void initState() {
    super.initState();
    // 채팅방 입장
    chatController.enterChatRoom(friendshipId);
  }
  
  @override
  void dispose() {
    // 채팅방 퇴장은 컨트롤러에서 자동 처리됨
    super.dispose();
  }
}
```

### 메시지 전송
```dart
Future<void> sendMessage() async {
  final success = await chatController.sendMessage(
    content: '안녕하세요!',
    messageType: 'text',
  );
  
  if (success) {
    // 메시지 전송 성공
  }
}

// 이미지 메시지 전송
Future<void> sendImageMessage() async {
  final imageUrl = await ImageService.uploadChatImage();
  if (imageUrl != null) {
    await chatController.sendMessage(
      content: '',
      messageType: 'image',
      imageUrl: imageUrl,
    );
  }
}
```

### 메시지 목록 표시
```dart
Widget buildMessageList() {
  return Obx(() {
    return ListView.builder(
      itemCount: chatController.messages.length,
      itemBuilder: (context, index) {
        final message = chatController.messages[index];
        return MessageBubble(
          content: message['content'],
          isMe: message['sender_id'] == currentUserId,
          messageType: message['message_type'],
          timestamp: message['created_at'],
        );
      },
    );
  });
}
```

### 타이핑 상태 처리
```dart
// 타이핑 시작
void onTypingStart() {
  chatController.sendTypingStatus(true);
}

// 타이핑 종료
void onTypingEnd() {
  chatController.sendTypingStatus(false);
}

// 상대방 타이핑 상태 표시
Widget buildTypingIndicator() {
  return Obx(() {
    if (chatController.otherUserTyping) {
      return Text('상대방이 입력 중...');
    }
    return SizedBox.shrink();
  });
}
```

## 📍 위치 서비스

### 현재 위치 가져오기
```dart
import 'core/services/location_service.dart';

Future<void> getCurrentLocation() async {
  final position = await LocationService.getCurrentLocation();
  if (position != null) {
    print('위도: ${position.latitude}, 경도: ${position.longitude}');
  }
}
```

### 위치 권한 요청
```dart
Future<void> requestLocationPermission() async {
  final granted = await LocationService.requestLocationPermission();
  if (granted) {
    // 위치 권한 허용됨
  } else {
    // 위치 권한 거부됨
  }
}
```

### 위치 변경 감지
```dart
void listenToLocationChanges() {
  LocationService.getLocationStream().listen((position) {
    // 위치가 변경될 때마다 호출됨
    print('새로운 위치: ${position.latitude}, ${position.longitude}');
  });
}
```

## 🖼️ 이미지 업로드

### 프로필 이미지 업로드
```dart
import 'core/services/image_service.dart';

Future<void> uploadProfileImage() async {
  final imageUrl = await ImageService.uploadProfileImage();
  if (imageUrl != null) {
    // 프로필 업데이트
    await authController.updateProfile(profileImageUrl: imageUrl);
  }
}
```

### 갤러리에서 이미지 선택
```dart
Future<void> pickImageFromGallery() async {
  final imageFile = await ImageService.pickImageFromGallery();
  if (imageFile != null) {
    // 이미지 처리
  }
}
```

### 카메라로 사진 촬영
```dart
Future<void> takePhoto() async {
  final imageFile = await ImageService.takePhotoWithCamera();
  if (imageFile != null) {
    // 사진 처리
  }
}
```

## 🔧 직접 API 호출

### API 서비스 직접 사용
```dart
import 'core/services/api_service.dart';

// 사용자 프로필 조회
Future<void> getProfile() async {
  try {
    final profile = await ApiService.getProfile();
    print('프로필: $profile');
  } catch (e) {
    print('오류: $e');
  }
}

// 근처 사용자 조회
Future<void> getNearbyUsers() async {
  try {
    final users = await ApiService.getNearbyUsers(
      latitude: 37.5665,
      longitude: 126.9780,
      maxDistance: 1000,
    );
    print('근처 사용자: $users');
  } catch (e) {
    print('오류: $e');
  }
}

// Socket.io 연결
void connectToSocket() {
  ApiService.connectSocket();
}

// 실시간 메시지 전송
void sendRealtimeMessage() {
  ApiService.sendRealtimeMessage(
    friendshipId: 1,
    content: '실시간 메시지',
    messageType: 'text',
  );
}
```

## 📱 상태 관리

### GetX 컨트롤러 사용
```dart
class MyScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final FriendshipController friendshipController = Get.find<FriendshipController>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(authController.userData['nickname'] ?? '밥친구')),
      ),
      body: Obx(() {
        if (friendshipController.isLoading) {
          return Center(child: CircularProgressIndicator());
        }
        
        return ListView.builder(
          itemCount: friendshipController.friendships.length,
          itemBuilder: (context, index) {
            final friendship = friendshipController.friendships[index];
            return ListTile(
              title: Text(friendship['friend']['nickname']),
              subtitle: Text('온도: ${friendship['temperature']}°'),
            );
          },
        );
      }),
    );
  }
}
```

## 🚀 초기화

### 앱 시작 시 초기화
```dart
// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // API 서비스 초기화
  await ApiService.initialize();
  
  runApp(MyApp());
}
```

### 컨트롤러 초기화
```dart
// app.dart 또는 라우트 설정
void setupControllers() {
  Get.put(AuthController());
  Get.put(FriendshipController());
  Get.put(ChatController());
}
```

이제 NestJS 백엔드와 완전히 연동된 Flutter 앱이 준비되었습니다! 🎉
