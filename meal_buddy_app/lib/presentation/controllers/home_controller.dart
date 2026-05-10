import 'package:get/get.dart';
import '../../data/models/home_models.dart';
import '../../core/services/api_service.dart';
import '../controllers/auth_controller.dart';

class HomeController extends GetxController {
  // 반응형 상태 관리
  final RxList<MealBuddyItem> mealbuddyList = <MealBuddyItem>[].obs;
  final RxList<MealBuddyItem> searchResultList = <MealBuddyItem>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isFavorite = false.obs;

  final RxInt selectedIndex = 0.obs;
  void changeTab(int index) {
    selectedIndex.value = index;
  }

  // 카테고리 필터 상태
  final RxList<String> categories = ["전체", "한식", "중식", "양식", "일식", "분식"].obs;
  final RxString selectedCategory = "전체".obs;

  void changeCategory(String category) {
    selectedCategory.value = category;
  }

  //음식 카테고리 선택 라디오 버튼
  final RxString selectedFoodType = '한식'.obs;

  void changeFoodType(String value) {
    selectedFoodType.value = value;
  }

  //내 게시글만 필터링
  List<MealBuddyItem> get myPosts {
    final auth = Get.find<AuthController>();
    final myId = auth.userData['id'];

    return mealbuddyList.where((post) => post.userId == myId).toList();
  }

  @override
  void onInit() {
    super.onInit();

    // AuthController의 로그인 상태를 감시
    final authController = Get.find<AuthController>();

    // 이미 로그인되어 있으면 즉시 로드
    if (authController.isLoggedIn) {
      loadMealBuddys();
    }

    // 로그인 상태 변경을 감시하여 자동으로 게시글 로드
    ever(authController.isLoggedInRx, (isLoggedIn) {
      if (isLoggedIn) {
        print('로그인 완료 감지 - 게시글 로드 시작');
        loadMealBuddys();
      } else {
        print('로그아웃 감지 - 게시글 목록 초기화');
        mealbuddyList.clear();
        searchResultList.clear();
      }
    });
  }

  // API로부터 게시글 로드
  Future<void> loadMealBuddys() async {
    isLoading.value = true;

    try {
      // API 호출 (백엔드가 준비되면 실제 데이터를 받음)
      final posts = await ApiService.getPosts();

      // API 응답을 MealBuddyItem으로 변환
      mealbuddyList.value = posts.map((post) {
        return MealBuddyItem(
          postId: post['id'],
          title: post['title'] ?? '',
          content: post['content'] ?? '',
          place: post['place'] ?? '',
          menu: post['menu'] ?? '',
          time: post['time'] ?? '',
          foodType: post['food_type'] ?? '',
          userId: post['user']?['id'] ?? 0,
          authorName: post['user']?['nickname'] ?? '알 수 없음',
          authorAge: post['user']?['age'] ?? 0,
          authorGender: post['user']?['gender'] ?? '',
          authorProfileImage: post['user']?['profile_image_url'],
        );
      }).toList();

      searchResultList.assignAll(mealbuddyList);
    } catch (e) {
      // API 오류 시 목 데이터 사용 (임시)
      print('게시글 로드 실패, 목 데이터 사용: $e');
      _loadMockData();
    } finally {
      isLoading.value = false;
    }
  }

  // 백엔드가 준비될 때까지 사용할 목 데이터
  void _loadMockData() {
    /*mealbuddyList.addAll([
      MealBuddyItem(
        title: '오늘 나랑 밥 먹을 사람?',
        place: '인하대후문',
        menu: '떡복이',
        time: '오후7시',
        foodType: '분식',
        userId: 1,
        authorName: '김밥친',
        authorAge: 23,
        authorGender: '여',
      ),
      MealBuddyItem(
        title: '혼자 초밥 먹기 싫어요',
        place: '인하대후문',
        menu: '초밥',
        time: '오후1시',
        foodType: '일식',
        userId: 2,
        authorName: '이밥친',
        authorAge: 25,
        authorGender: '남',
      ),
      MealBuddyItem(
        title: '피자 같이 시켜먹어요!',
        place: '인하대후문',
        menu: '피자',
        time: '오후10시',
        foodType: '양식',
        userId: 3,
        authorName: '박친구',
        authorAge: 22,
        authorGender: '여',
      ),
      MealBuddyItem(
        title: '오늘 밥 먹을 사람?',
        place: '강의실',
        menu: '한식',
        time: '오후12시',
        foodType: '한식',
        userId: 4,
        authorName: '최밥',
        authorAge: 24,
        authorGender: '남',
      ),
      MealBuddyItem(
        title: '떡볶이 맛집 알려드려요',
        place: '인하대후문',
        menu: '떡복이',
        time: '오후7시',
        foodType: '분식',
        userId: 5,
        authorName: '정친구',
        authorAge: 21,
        authorGender: '여',
      ),
      MealBuddyItem(
        title: '회 좋아하시는 분!',
        place: '송도',
        menu: '초밥',
        time: '오후6시',
        foodType: '일식',
        userId: 6,
        authorName: '강밥친',
        authorAge: 26,
        authorGender: '남',
      ),
      MealBuddyItem(
        title: '파스타 먹고싶어요',
        place: '인하대정문',
        menu: '파스타',
        time: '오후8시',
        foodType: '양식',
        userId: 7,
        authorName: '윤친구',
        authorAge: 23,
        authorGender: '여',
      ),
      MealBuddyItem(
        title: '중식 맛집 같이 가요',
        place: '구월동',
        menu: '짜장면',
        time: '오후1시',
        foodType: '중식',
        userId: 8,
        authorName: '임밥',
        authorAge: 27,
        authorGender: '남',
      ),
      MealBuddyItem(
        title: '라면 끓여먹을 사람?',
        place: '기숙사',
        menu: '라면',
        time: '밤11시',
        foodType: '분식',
        userId: 9,
        authorName: '한친구',
        authorAge: 20,
        authorGender: '여',
      ),
    ]);*/
    searchResultList.assignAll(mealbuddyList);
  }

  // 게시글 추가 (API 호출)
  Future<void> addMealBuddy(
      String title, String content, String place, String menu, String time) async {
    try {
      // 현재 사용자 정보 가져오기
      final authController = Get.find<AuthController>();
      final currentUser = authController.userData;

      // API로 게시글 생성
      final newPost = await ApiService.createPost(
        title: title,
        content: content,
        place: place,
        menu: menu,
        time: time,
        foodType: selectedFoodType.value,
      );

      // 새 게시글을 리스트에 추가
      final newItem = MealBuddyItem(
        postId: newPost['id'],
        title: title,
        content: content,
        place: place,
        menu: menu,
        time: time,
        foodType: selectedFoodType.value,
        userId: newPost['user']?['id'] ?? currentUser['id'] ?? 0,
        authorName:
            newPost['user']?['nickname'] ?? currentUser['nickname'] ?? '나',
        authorAge: newPost['user']?['age'] ?? currentUser['age'] ?? 0,
        authorGender: newPost['user']?['gender'] ?? currentUser['gender'] ?? '',
        authorProfileImage: newPost['user']?['profile_image_url'],
      );

      mealbuddyList.insert(0, newItem); // 맨 위에 추가
      searchResultList.insert(0, newItem);

      Get.snackbar('성공', '게시글이 등록되었습니다!');
    } catch (e) {
      print('게시글 추가 실패: $e');

      // API 오류 시 로컬에만 추가 (임시)
      final authController = Get.find<AuthController>();
      final currentUser = authController.userData;

      final newItem = MealBuddyItem(
        postId: 0, 
        title: title,
        content: content,
        place: place,
        menu: menu,
        time: time,
        foodType: selectedFoodType.value,
        userId: currentUser['id'] ?? 999,
        authorName: currentUser['nickname'] ?? '나',
        authorAge: currentUser['age'] ?? 25,
        authorGender: currentUser['gender'] ?? '',
      );

      mealbuddyList.insert(0, newItem);
      searchResultList.insert(0, newItem);

      Get.snackbar('알림', '게시글이 임시 저장되었습니다 (서버 연결 필요)');
    }
  }

  List<MealBuddyItem> get filteredMeals {
    if (selectedCategory.value == "전체") {
      return mealbuddyList;
    } else {
      return mealbuddyList
          .where((meal) => meal.foodType == selectedCategory.value)
          .toList();
    }
  }

  void heartMealBuddy(MealBuddyItem item) {
    item.isFavorite.value = !item.isFavorite.value;
  }

  void navigateToSignin() {
    Get.toNamed('/signin');
  }

  //검색 기능 구현
  void searchMealBuddies(String keyword) {
    if (keyword.isEmpty) {
      searchResultList.assignAll(mealbuddyList);
    } else {
      searchResultList.assignAll(
        mealbuddyList
            .where((item) =>
                item.title.contains(keyword) ||
                item.place.contains(keyword) ||
                item.menu.contains(keyword) ||
                item.time.contains(keyword))
            .toList(),
      );
    }
  }
}
