# 밥친구 (BapBuddy) - 개발 환경 설정 가이드

## 1. 개발 환경 요구사항

### 1.1 필수 소프트웨어
- **Node.js**: 18.x 이상
- **npm**: 9.x 이상 또는 **yarn**: 1.22.x 이상
- **PostgreSQL**: 14.x 이상
- **Git**: 2.x 이상

### 1.2 권장 개발 도구
- **IDE**: Visual Studio Code, WebStorm, IntelliJ IDEA
- **API 테스트**: Postman, Insomnia
- **데이터베이스 관리**: pgAdmin, DBeaver
- **버전 관리**: Git GUI (SourceTree, GitKraken)

## 2. 프로젝트 구조

### 2.1 전체 프로젝트 구조
```
밥친구/
├── meal_buddy_app/           # Flutter 프론트엔드
├── meal_buddy_server/        # NestJS 백엔드
├── doc/                      # 프로젝트 문서
└── README.md                 # 프로젝트 개요
```

### 2.2 백엔드 프로젝트 구조
```
meal_buddy_server/
├── src/
│   ├── main.ts               # 애플리케이션 진입점
│   ├── app.module.ts         # 루트 모듈
│   ├── app.controller.ts     # 루트 컨트롤러
│   ├── app.service.ts        # 루트 서비스
│   ├── config/               # 설정 파일
│   ├── modules/              # 기능별 모듈
│   ├── common/               # 공통 모듈
│   ├── database/             # 데이터베이스 관련
│   └── utils/                # 유틸리티
├── test/                     # 테스트 파일
├── dist/                     # 빌드 결과물
├── package.json              # 의존성 및 스크립트
├── tsconfig.json             # TypeScript 설정
├── nest-cli.json             # NestJS CLI 설정
├── ormconfig.ts              # TypeORM 설정
└── README.md                 # 백엔드 문서
```

## 3. 개발 환경 설정

### 3.1 Node.js 설치

#### macOS (Homebrew 사용)
```bash
# Homebrew 설치 (없는 경우)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Node.js 설치
brew install node

# 버전 확인
node --version
npm --version
```

#### Windows
1. [Node.js 공식 사이트](https://nodejs.org/)에서 LTS 버전 다운로드
2. 설치 프로그램 실행
3. 환경 변수 설정 확인

#### Linux (Ubuntu/Debian)
```bash
# NodeSource 저장소 추가
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -

# Node.js 설치
sudo apt-get install -y nodejs

# 버전 확인
node --version
npm --version
```

### 3.2 PostgreSQL 설치

#### macOS (Homebrew 사용)
```bash
# PostgreSQL 설치
brew install postgresql

# PostgreSQL 서비스 시작
brew services start postgresql

# 데이터베이스 생성
createdb bapbuddy_db
```

#### Windows
1. [PostgreSQL 공식 사이트](https://www.postgresql.org/download/windows/)에서 다운로드
2. 설치 프로그램 실행
3. 비밀번호 설정 및 포트 설정 (기본: 5432)
4. pgAdmin 설치 (선택사항)

#### Linux (Ubuntu/Debian)
```bash
# PostgreSQL 설치
sudo apt update
sudo apt install postgresql postgresql-contrib

# PostgreSQL 서비스 시작
sudo systemctl start postgresql
sudo systemctl enable postgresql

# 사용자 생성 및 데이터베이스 생성
sudo -u postgres psql
CREATE USER bapbuddy WITH PASSWORD 'password';
CREATE DATABASE bapbuddy_db OWNER bapbuddy;
GRANT ALL PRIVILEGES ON DATABASE bapbuddy_db TO bapbuddy;
\q
```

### 3.3 프로젝트 클론 및 설정

```bash
# 프로젝트 클론
git clone <repository-url>
cd 밥친구

# 백엔드 디렉토리로 이동
cd meal_buddy_server

# 의존성 설치
npm install

# 환경 변수 파일 생성
cp env.example .env

# 환경 변수 편집
nano .env
```

### 3.4 환경 변수 설정

`.env` 파일을 다음과 같이 설정하세요:

```env
# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=password
DB_DATABASE=bapbuddy_db

# JWT Configuration
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
JWT_EXPIRES_IN=7d

# Application Configuration
NODE_ENV=development
PORT=3000

# CORS Configuration
CORS_ORIGIN=http://localhost:3000

# File Upload Configuration
MAX_FILE_SIZE=5242880
UPLOAD_DEST=./uploads
```

## 4. 개발 서버 실행

### 4.1 데이터베이스 마이그레이션

```bash
# 마이그레이션 실행
npm run migration:run

# 마이그레이션 상태 확인
npm run typeorm -- migration:show
```

### 4.2 개발 서버 시작

```bash
# 개발 모드 (핫 리로드)
npm run start:dev

# 프로덕션 모드
npm run start:prod

# 디버그 모드
npm run start:debug
```

### 4.3 서버 상태 확인

서버가 정상적으로 실행되면 다음 URL에서 확인할 수 있습니다:

- **애플리케이션**: http://localhost:3000
- **API 문서 (Swagger)**: http://localhost:3000/api
- **헬스 체크**: http://localhost:3000/

## 5. 개발 도구 설정

### 5.1 Visual Studio Code 설정

#### 추천 확장 프로그램
- **ES7+ React/Redux/React-Native snippets**
- **TypeScript Importer**
- **Auto Rename Tag**
- **Bracket Pair Colorizer**
- **GitLens**
- **Thunder Client** (API 테스트)

#### 설정 파일 (.vscode/settings.json)
```json
{
  "typescript.preferences.importModuleSpecifier": "relative",
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "typescript.updateImportsOnFileMove.enabled": "always"
}
```

### 5.2 ESLint 및 Prettier 설정

프로젝트에 이미 설정되어 있지만, 필요시 다음과 같이 설정할 수 있습니다:

```bash
# ESLint 설정
npm install -D @typescript-eslint/eslint-plugin @typescript-eslint/parser

# Prettier 설정
npm install -D prettier eslint-config-prettier eslint-plugin-prettier
```

### 5.3 Git 설정

```bash
# Git 훅 설정 (선택사항)
npm install -D husky lint-staged

# package.json에 스크립트 추가
{
  "scripts": {
    "prepare": "husky install"
  },
  "lint-staged": {
    "*.ts": [
      "eslint --fix",
      "prettier --write"
    ]
  }
}
```

## 6. 테스트 환경

### 6.1 단위 테스트

```bash
# 모든 테스트 실행
npm run test

# 테스트 감시 모드
npm run test:watch

# 테스트 커버리지
npm run test:cov

# 특정 테스트 파일 실행
npm run test -- users.service.spec.ts
```

### 6.2 E2E 테스트

```bash
# E2E 테스트 실행
npm run test:e2e

# E2E 테스트 감시 모드
npm run test:e2e -- --watch
```

### 6.3 테스트 데이터베이스 설정

```bash
# 테스트용 데이터베이스 생성
createdb bapbuddy_test_db

# 테스트 환경 변수 설정
NODE_ENV=test DB_DATABASE=bapbuddy_test_db npm run test:e2e
```

## 7. API 개발 가이드

### 7.1 새로운 API 엔드포인트 추가

1. **엔티티 생성** (`src/modules/[module]/entities/`)
2. **DTO 생성** (`src/modules/[module]/dto/`)
3. **서비스 생성** (`src/modules/[module]/[module].service.ts`)
4. **컨트롤러 생성** (`src/modules/[module]/[module].controller.ts`)
5. **모듈에 등록** (`src/modules/[module]/[module].module.ts`)

### 7.2 API 문서화

Swagger 데코레이터를 사용하여 API 문서를 자동 생성합니다:

```typescript
@ApiTags('users')
@ApiOperation({ summary: '사용자 조회' })
@ApiResponse({ status: 200, description: '성공' })
@Get(':id')
async findOne(@Param('id') id: string) {
  return this.usersService.findOne(+id);
}
```

### 7.3 유효성 검사

DTO에 class-validator 데코레이터를 사용합니다:

```typescript
export class CreateUserDto {
  @IsEmail()
  @ApiProperty({ description: '사용자 이메일' })
  email: string;

  @IsString()
  @MinLength(6)
  @ApiProperty({ description: '비밀번호' })
  password: string;
}
```

## 8. 데이터베이스 관리

### 8.1 마이그레이션

```bash
# 마이그레이션 생성
npm run migration:generate -- src/database/migrations/CreateUsersTable

# 마이그레이션 실행
npm run migration:run

# 마이그레이션 되돌리기
npm run migration:revert
```

### 8.2 시드 데이터

```bash
# 시드 데이터 생성
npm run seed

# 특정 시드만 실행
npm run seed -- --seed=UserSeeder
```

### 8.3 데이터베이스 백업 및 복원

```bash
# 백업
pg_dump -h localhost -U postgres bapbuddy_db > backup.sql

# 복원
psql -h localhost -U postgres bapbuddy_db < backup.sql
```

## 9. 배포 준비

### 9.1 프로덕션 빌드

```bash
# 프로덕션 빌드
npm run build

# 빌드 결과물 확인
ls -la dist/
```

### 9.2 환경 변수 설정 (프로덕션)

```env
NODE_ENV=production
DB_HOST=your-production-db-host
DB_PASSWORD=your-production-db-password
JWT_SECRET=your-production-jwt-secret
```

### 9.3 Docker 설정

```dockerfile
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .
RUN npm run build

EXPOSE 3000

CMD ["npm", "run", "start:prod"]
```

## 10. 문제 해결

### 10.1 일반적인 문제들

#### 포트 충돌
```bash
# 포트 사용 중인 프로세스 확인
lsof -i :3000

# 프로세스 종료
kill -9 <PID>
```

#### 데이터베이스 연결 실패
```bash
# PostgreSQL 서비스 상태 확인
brew services list | grep postgresql

# PostgreSQL 재시작
brew services restart postgresql
```

#### 의존성 문제
```bash
# node_modules 삭제 후 재설치
rm -rf node_modules package-lock.json
npm install
```

### 10.2 로그 확인

```bash
# 애플리케이션 로그
npm run start:dev

# 데이터베이스 로그 (PostgreSQL)
tail -f /usr/local/var/log/postgres.log
```

## 11. 개발 워크플로우

### 11.1 기능 개발 과정

1. **브랜치 생성**: `git checkout -b feature/user-authentication`
2. **코드 작성**: 기능 구현 및 테스트
3. **커밋**: `git commit -m "feat: 사용자 인증 기능 추가"`
4. **푸시**: `git push origin feature/user-authentication`
5. **PR 생성**: GitHub에서 Pull Request 생성
6. **코드 리뷰**: 팀원과 코드 리뷰 진행
7. **머지**: 승인 후 main 브랜치로 머지

### 11.2 커밋 메시지 규칙

```
feat: 새로운 기능 추가
fix: 버그 수정
docs: 문서 수정
style: 코드 포맷팅
refactor: 코드 리팩토링
test: 테스트 추가
chore: 빌드 프로세스 또는 보조 도구 변경
```

## 12. 추가 리소스

### 12.1 공식 문서
- [NestJS 공식 문서](https://docs.nestjs.com/)
- [TypeORM 공식 문서](https://typeorm.io/)
- [PostgreSQL 공식 문서](https://www.postgresql.org/docs/)

### 12.2 유용한 도구
- [Postman](https://www.postman.com/) - API 테스트
- [DBeaver](https://dbeaver.io/) - 데이터베이스 관리
- [Insomnia](https://insomnia.rest/) - API 테스트

### 12.3 커뮤니티
- [NestJS Discord](https://discord.gg/G7Qnnhy)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/nestjs)
