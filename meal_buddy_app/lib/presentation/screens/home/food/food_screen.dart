import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class BannerItem {
  final String title;
  final String imagePath;
  final String routeName;

  BannerItem({
    required this.title,
    required this.imagePath,
    required this.routeName,
  });
}

final List<BannerItem> bannerItems = [
  BannerItem(
    title: '인생 날로먹고 싶을 땐 초밥',
    imagePath: 'assets/images/food/sushi.png',
    routeName: '/food-sushi',
  ),
  BannerItem(
    title: '피자 먹고 얼굴 피자 :)',
    imagePath: 'assets/images/food/pizza.png',
    routeName: '/food-pizza',
  ),
  BannerItem(
    title: '치킨은 살 안쪄 살은 너가 쪄',
    imagePath: 'assets/images/food/chicken.png',
    routeName: '/food-chicken',
  ),
  BannerItem(
    title: '버거울 땐 버거를 먹어..',
    imagePath: 'assets/images/food/burger.png',
    routeName: '/food-burger',
  ),
];

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  State<FoodScreen> createState() => _FoodScreen();
}

class _FoodScreen extends State<FoodScreen> {
  int _currentPage = 0;
  Timer? _timer;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.positions.isNotEmpty) {
        int nextPage = (_currentPage + 1) % bannerItems.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });

    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _currentPage = next;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 146,
      child: PageView.builder(
        controller: _pageController,
        itemCount: bannerItems.length,
        itemBuilder: (context, index) {
          final item = bannerItems[index];
          return _buildBannerItem(context, item, index);
        },
      ),
    );
  }

  Widget _buildBannerItem(BuildContext context, BannerItem item, int index) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(item.routeName);
      },
      child: Container(
        width: double.infinity,
        height: 146,
        // margin: const EdgeInsets.symmetric(horizontal: 10.0),
        decoration: const BoxDecoration(
          color: Color(0xFFFFEFD3),
          // borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            // 상단 '오늘의 메뉴 추천' 배지
            Positioned(
              left: 30,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide.none,
                    left: BorderSide(color: Colors.black87, width: 1),
                    right: BorderSide(color: Colors.black87, width: 1),
                    bottom: BorderSide(color: Colors.black87, width: 1),
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(6),
                    bottomRight: Radius.circular(6),
                  ),
                ),
                child: const Text(
                  '오늘의 메뉴 추천',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'BlackHanSans',
                  ),
                ),
              ),
            ),

            // 중앙 내용
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 25,
                      fontFamily: 'Ownglyph-Park',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Image.asset(
                    item.imagePath,
                    width: 84,
                    height: 75,
                  ),
                ],
              ),
            ),

            // 오른쪽 하단 인덱스 표시
            Positioned(
              right: 8,
              bottom: 8,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6DCAE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_currentPage + 1} / ${bannerItems.length}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
