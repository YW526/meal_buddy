// import 'package:geolocator/geolocator.dart';  // 임시로 비활성화
import 'dart:math';
import 'package:permission_handler/permission_handler.dart';
import 'api_service.dart';

// 임시로 위치 서비스를 비활성화
class LocationService {
  // static Position? _currentPosition;

  /// 위치 권한 요청
  static Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  /// 위치 권한 확인
  static Future<bool> hasLocationPermission() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  /// 현재 위치 가져오기 (임시로 비활성화)
  static Future<dynamic> getCurrentLocation() async {
    // TODO: geolocator 패키지 문제 해결 후 활성화
    print('위치 서비스가 임시로 비활성화되어 있습니다.');
    return null;
  }

  /// 마지막으로 알려진 위치 가져오기 (임시로 비활성화)
  static Future<dynamic> getLastKnownLocation() async {
    // TODO: geolocator 패키지 문제 해결 후 활성화
    return null;
  }

  /// 위치 변경 감지 (임시로 비활성화)
  static Stream<dynamic> getLocationStream() {
    // TODO: geolocator 패키지 문제 해결 후 활성화
    return Stream.empty();
  }

  /// 두 지점 간 거리 계산 (미터) - 임시 구현
  static double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    // 간단한 유클리드 거리 계산 (임시)
    const double earthRadius = 6371000; // 지구 반지름 (미터)
    final double lat1 = startLatitude * (pi / 180);
    final double lat2 = endLatitude * (pi / 180);
    final double deltaLat = (endLatitude - startLatitude) * (pi / 180);
    final double deltaLon = (endLongitude - startLongitude) * (pi / 180);

    final double a = sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(lat1) * cos(lat2) * sin(deltaLon / 2) * sin(deltaLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  /// 현재 위치 반환 (임시로 비활성화)
  static dynamic get currentPosition => null;

  /// 위치를 주소로 변환 (나중에 구현)
  static Future<String> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    // TODO: Google Geocoding API 또는 다른 서비스 사용
    return '$latitude, $longitude';
  }

  /// 주소를 좌표로 변환 (나중에 구현)
  static Future<Map<String, double>> getCoordinatesFromAddress(
    String address,
  ) async {
    // TODO: Google Geocoding API 또는 다른 서비스 사용
    return {'latitude': 37.5665, 'longitude': 126.9780}; // 서울 시청 좌표
  }
}
