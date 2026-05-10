import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class FoodItem {
  final String name;
  final String address;
  final String image;
  final String mapURL;

  FoodItem({
    required this.name,
    required this.address,
    required this.image,
    required this.mapURL,
  });
}

class FoodSushiScreen extends StatefulWidget {
  const FoodSushiScreen({super.key});

  @override
  State<FoodSushiScreen> createState() => _FoodSushiScreenn();
}

class _FoodSushiScreenn extends State<FoodSushiScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final List<FoodItem> _restaurants = [
    FoodItem(
      name: '상무초밥',
      address: '잠심본점 | 인천광역시 남동구 구월동 1147 2층',
      image: 'assets/images/food/sushi1.png',
      mapURL: 'https://naver.me/xnh0lICO',
    ),
    FoodItem(
      name: '으뜸스시',
      address: '인하대역점 | 인천 미추홀구 매소홀로 262 1층',
      image: 'assets/images/food/sushi2.png',
      mapURL: 'https://naver.me/5pwsrF2D',
    ),
    FoodItem(
      name: '미키도스시',
      address: '인천광역시 미추홀구 주안동 201동 지하2층',
      image: 'assets/images/food/sushi3.png',
      mapURL: 'https://naver.me/xCBQ8ytG',
    ),
  ];

  Future<void> _launchNaverMap(FoodItem restaurant) async {
    final uri = Uri.parse(restaurant.mapURL);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('네이버 지도를 열 수 없어요!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFD9B77C),
            Color(0xFFD9B77C),
            Color(0xFFF6DCAE),
            Color(0xFFFFFFFF),
            Color(0xFFFFFFFF),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              // 홈 화면으로 이동
              onPressed: () {
                Get.offAllNamed('/home');
              }),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9B77C),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Text(
                      '오늘의 메뉴 추천',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                // 초밥 이미지
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      'assets/images/food/sushi_white.png',
                      width: 250,
                      height: 200,
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
                const SizedBox(height: 10),

                // 초밥의 효능
                const Text(
                  '초밥의 효능',
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 24,
                    fontFamily: 'Ownglyph-Park',
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '단백질 가득',
                              style: TextStyle(
                                color: Color(0xFFD4AD69),
                                fontSize: 20,
                                fontFamily: 'Ownglyph-Park',
                              ),
                            ),
                            // SizedBox(height: 4),
                            Text(
                              '고단백 저지방인 생선',
                              style: TextStyle(
                                color: Color(0xFFD4AD69),
                                fontSize: 15,
                                fontFamily: 'Ownglyph-Park',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '오메가-3 풍부',
                              style: TextStyle(
                                color: Color(0xFFD4AD69),
                                fontSize: 20,
                                fontFamily: 'Ownglyph-Park',
                              ),
                            ),
                            // SizedBox(height: 4),
                            Text(
                              '집중력 향상, 기억력 유지',
                              style: TextStyle(
                                color: Color(0xFFD4AD69),
                                fontSize: 15,
                                fontFamily: 'Ownglyph-Park',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 추천 맛집
                const Text(
                  '추천 맛집',
                  style: TextStyle(
                    color: Color(0xFFD4AD69),
                    fontSize: 24,
                    fontFamily: 'Ownglyph-Park',
                  ),
                ),
                const SizedBox(height: 8),
                _buildRestaurantCardList(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 스크롤 카드
  Widget _buildRestaurantCard(FoodItem restaurant) {
    final borderStyle = Border.all(
      color: const Color(0xFFD4AD69),
    );

    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: borderStyle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.symmetric(
              horizontal: 15.0, // 좌우는 15 (정보 영역과 동일)
              vertical: 10.0, // 상하는 10 (기존 유지)
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Center(
              child: Image.asset(
                restaurant.image,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // 정보 영역
          Padding(
            padding:
                const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Color(0xFFD4AD69),
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        restaurant.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24.0, top: 4.0),
                  child: Text(
                    restaurant.address,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 가로 스크롤 카드 리스트를 구성하는 위젯
  Widget _buildRestaurantCardList() {
    return Column(
      children: [
        SizedBox(
          height: 190,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _restaurants.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _launchNaverMap(_restaurants[index]);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: _buildRestaurantCard(
                    _restaurants[index],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_restaurants.length, (index) {
            return _buildDot(index);
          }),
        ),
      ],
    );
  }

  Widget _buildDot(int index) {
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        height: 15.0,
        width: 15.0,
        decoration: BoxDecoration(
          color: index == _currentPage
              ? const Color(0xFFF6DCAE)
              : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
