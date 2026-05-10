# 밥친구 (BapBuddy) 프로젝트 문서

## 📚 문서 목록

### 🏗 전체 시스템
- [프로젝트 개요](project-overview.md) - 프로젝트 전체 개요 및 목표
- [시스템 아키텍처](system-architecture.md) - 전체 시스템 구조 및 기술 스택
- [개발 환경 설정](development-setup.md) - 개발 환경 구축 가이드

### 🗄 데이터베이스
- [데이터베이스 설계](database-design.md) - 데이터베이스 스키마 및 관계
- [데이터 모델](data-models.md) - 엔티티 및 데이터 구조

### 🔧 시스템 구성
- [백엔드 아키텍처](backend-architecture.md) - NestJS 백엔드 구조
- [API 설계](api-design.md) - RESTful API 설계 및 엔드포인트
- [인증 시스템](authentication.md) - JWT 기반 인증 시스템

### 🎨 UI 구성
- [UI/UX 설계](ui-ux-design.md) - 사용자 인터페이스 및 경험 설계
- [화면 구성](screen-layout.md) - 앱 화면별 구성 및 기능

### 📋 개발 가이드
- [코딩 컨벤션](coding-conventions.md) - 코드 작성 규칙 및 스타일
- [테스트 가이드](testing-guide.md) - 테스트 작성 및 실행 방법
- [배포 가이드](deployment-guide.md) - 배포 환경 설정 및 방법

## 🚀 빠른 시작

### 1. 개발 환경 설정
```bash
# 백엔드 설정
cd meal_buddy_server
npm install
cp env.example .env
npm run start:dev

# 프론트엔드 설정
cd meal_buddy_app
flutter pub get
flutter run
```

### 2. 주요 문서 확인 순서
1. [프로젝트 개요](project-overview.md) - 프로젝트 이해
2. [시스템 아키텍처](system-architecture.md) - 전체 구조 파악
3. [개발 환경 설정](development-setup.md) - 환경 구축
4. [API 설계](api-design.md) - API 이해
5. [UI/UX 설계](ui-ux-design.md) - 프론트엔드 이해

## 📖 문서 작성 규칙

### 문서 구조
- **목적**: 문서의 목적과 범위 명시
- **개요**: 핵심 내용 요약
- **상세 내용**: 구체적인 설명과 예시
- **참고 자료**: 관련 링크 및 추가 정보

### 코드 예시
```typescript
// TypeScript 코드 예시
@Controller('users')
export class UsersController {
  @Get()
  findAll(): User[] {
    return this.usersService.findAll();
  }
}
```

### 다이어그램
- 시스템 구조도는 Mermaid 형식 사용
- 화면 구성은 ASCII 아트 또는 이미지 사용

## 🔄 문서 업데이트

### 버전 관리
- 문서 변경 시 날짜와 버전 기록
- 주요 변경사항은 변경 로그에 기록

### 리뷰 프로세스
1. 문서 작성/수정
2. 팀원 리뷰
3. 피드백 반영
4. 최종 승인 및 배포

## 📞 문의사항

문서에 대한 문의사항이나 개선 제안이 있으시면 이슈를 생성해 주세요.
