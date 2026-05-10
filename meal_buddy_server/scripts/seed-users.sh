#!/bin/bash

# 밥친구 테스트 사용자 등록 스크립트
# 실행 방법: chmod +x scripts/seed-users.sh && ./scripts/seed-users.sh

API_URL="http://localhost:3000"

echo "🚀 테스트 사용자 등록을 시작합니다..."
echo ""

# 1. 김너굴 - 20살 남자
echo "👤 김너굴 등록 중..."
curl -X POST "${API_URL}/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "a@abc.com",
    "password": "12341234",
    "nickname": "김너굴",
    "age": 20,
    "gender": "남",
    "food_preferences": ["한식", "분식"]
  }' \
  -s -o /dev/null -w "Status: %{http_code}\n"
echo ""

# 2. 마로니에 - 21살 여자
echo "👤 마로니에 등록 중..."
curl -X POST "${API_URL}/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "b@abc.com",
    "password": "12341234",
    "nickname": "마로니에",
    "age": 21,
    "gender": "여",
    "food_preferences": ["일식", "양식"]
  }' \
  -s -o /dev/null -w "Status: %{http_code}\n"
echo ""

# 3. 우렁 - 25살 여자
echo "👤 우렁 등록 중..."
curl -X POST "${API_URL}/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "c@abc.com",
    "password": "12341234",
    "nickname": "우렁",
    "age": 25,
    "gender": "여",
    "food_preferences": ["중식", "한식"]
  }' \
  -s -o /dev/null -w "Status: %{http_code}\n"
echo ""

# 4. 나머지 - 19살 남자
echo "👤 나머지 등록 중..."
curl -X POST "${API_URL}/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "d@abc.com",
    "password": "12341234",
    "nickname": "나머지",
    "age": 19,
    "gender": "남",
    "food_preferences": ["분식", "양식"]
  }' \
  -s -o /dev/null -w "Status: %{http_code}\n"
echo ""

# 5. 이인하 - 25살 남자
echo "👤 이인하 등록 중..."
curl -X POST "${API_URL}/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "e@abc.com",
    "password": "12341234",
    "nickname": "이인하",
    "age": 25,
    "gender": "남",
    "food_preferences": ["한식", "일식"]
  }' \
  -s -o /dev/null -w "Status: %{http_code}\n"
echo ""

# 6. 예은 - 22살 여자
echo "👤 예은 등록 중..."
curl -X POST "${API_URL}/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "f@abc.com",
    "password": "12341234",
    "nickname": "예은",
    "age": 22,
    "gender": "여",
    "food_preferences": ["일식", "중식"]
  }' \
  -s -o /dev/null -w "Status: %{http_code}\n"
echo ""

echo "✅ 모든 테스트 사용자 등록 완료!"
echo ""
echo "📋 등록된 사용자 목록:"
echo "  1. 김너굴 (a@abc.com) - 20살 남자"
echo "  2. 마로니에 (b@abc.com) - 21살 여자"
echo "  3. 우렁 (c@abc.com) - 25살 여자"
echo "  4. 나머지 (d@abc.com) - 19살 남자"
echo "  5. 이인하 (e@abc.com) - 25살 남자"
echo "  6. 예은 (f@abc.com) - 22살 여자"
echo ""
echo "🔑 모든 계정의 비밀번호: 12341234"

