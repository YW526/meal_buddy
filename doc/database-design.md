# 밥친구 (BapBuddy) - 데이터베이스 설계 (NestJS + TypeORM + PostgreSQL)

## 1. 데이터베이스 개요

### 1.1 기술 스택
- **Database**: PostgreSQL 14+
- **ORM**: TypeORM
- **Migration**: TypeORM CLI
- **Connection Pool**: TypeORM connection pooling

### 1.2 데이터베이스 특징
- 관계형 데이터베이스로 데이터 무결성 보장
- 트랜잭션 지원으로 데이터 일관성 유지
- 인덱싱을 통한 빠른 검색 성능
- 외래키 제약조건으로 참조 무결성 보장

## 2. 데이터베이스 스키마

### 2.1 테이블 구조

#### users 테이블 (사용자 정보)
```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    nickname VARCHAR(100) NOT NULL,
    food_preferences TEXT[], -- 배열 형태로 저장 (한식, 중식, 일식, 양식, 분식 등)
    profile_image_url VARCHAR(500),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    last_active TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_online BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 인덱스 생성
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_location ON users(latitude, longitude);
CREATE INDEX idx_users_last_active ON users(last_active);
```

#### friendships 테이블 (친구 관계)
```sql
CREATE TABLE friendships (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    friend_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    status VARCHAR(20) DEFAULT 'pending', -- pending, accepted, rejected, blocked
    temperature INTEGER DEFAULT 50, -- 0-100 (밥친구 온도)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, friend_id)
);

-- 인덱스 생성
CREATE INDEX idx_friendships_user_id ON friendships(user_id);
CREATE INDEX idx_friendships_friend_id ON friendships(friend_id);
CREATE INDEX idx_friendships_status ON friendships(status);
```

#### messages 테이블 (메시지)
```sql
CREATE TABLE messages (
    id SERIAL PRIMARY KEY,
    friendship_id INTEGER REFERENCES friendships(id) ON DELETE CASCADE,
    sender_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    message_type VARCHAR(20) DEFAULT 'text', -- text, image, location
    image_url VARCHAR(500), -- 이미지 메시지인 경우
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 인덱스 생성
CREATE INDEX idx_messages_friendship_id ON messages(friendship_id);
CREATE INDEX idx_messages_sender_id ON messages(sender_id);
CREATE INDEX idx_messages_created_at ON messages(created_at);
```

#### temperature_history 테이블 (온도 변화 기록)
```sql
CREATE TABLE temperature_history (
    id SERIAL PRIMARY KEY,
    friendship_id INTEGER REFERENCES friendships(id) ON DELETE CASCADE,
    old_temperature INTEGER,
    new_temperature INTEGER,
    reason VARCHAR(100), -- accept, reject, chat, negative, positive
    description TEXT, -- 온도 변화 이유 설명
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 인덱스 생성
CREATE INDEX idx_temperature_history_friendship_id ON temperature_history(friendship_id);
CREATE INDEX idx_temperature_history_created_at ON temperature_history(created_at);
```

#### user_settings 테이블 (사용자 설정)
```sql
CREATE TABLE user_settings (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    notification_enabled BOOLEAN DEFAULT TRUE,
    location_sharing_enabled BOOLEAN DEFAULT TRUE,
    temperature_alert_enabled BOOLEAN DEFAULT TRUE,
    max_distance INTEGER DEFAULT 1000, -- 최대 검색 거리 (미터)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id)
);

-- 인덱스 생성
CREATE INDEX idx_user_settings_user_id ON user_settings(user_id);
```

## 3. TypeORM 엔티티 정의

### 3.1 기본 엔티티 클래스
```typescript
// src/common/entities/base.entity.ts
import { 
  PrimaryGeneratedColumn, 
  CreateDateColumn, 
  UpdateDateColumn 
} from 'typeorm';

export abstract class BaseEntity {
  @PrimaryGeneratedColumn()
  id: number;

  @CreateDateColumn()
  created_at: Date;

  @UpdateDateColumn()
  updated_at: Date;
}
```

### 3.2 User 엔티티
```typescript
// src/modules/users/entities/user.entity.ts
import { 
  Entity, 
  Column, 
  OneToMany, 
  OneToOne,
  Index 
} from 'typeorm';
import { BaseEntity } from '../../../common/entities/base.entity';
import { Friendship } from '../../friendships/entities/friendship.entity';
import { Message } from '../../messages/entities/message.entity';
import { UserSettings } from './user-settings.entity';

export enum UserStatus {
  ONLINE = 'online',
  OFFLINE = 'offline'
}

@Entity('users')
@Index(['latitude', 'longitude'])
@Index(['last_active'])
export class User extends BaseEntity {
  @Column({ unique: true })
  @Index()
  email: string;

  @Column()
  password_hash: string;

  @Column({ length: 100 })
  nickname: string;

  @Column('text', { array: true, nullable: true })
  food_preferences: string[];

  @Column({ nullable: true })
  profile_image_url: string;

  @Column('decimal', { precision: 10, scale: 8, nullable: true })
  latitude: number;

  @Column('decimal', { precision: 11, scale: 8, nullable: true })
  longitude: number;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  last_active: Date;

  @Column({ default: false })
  is_online: boolean;

  // 관계 정의
  @OneToMany(() => Friendship, friendship => friendship.user)
  friendships_as_user: Friendship[];

  @OneToMany(() => Friendship, friendship => friendship.friend)
  friendships_as_friend: Friendship[];

  @OneToMany(() => Message, message => message.sender)
  sent_messages: Message[];

  @OneToOne(() => UserSettings, settings => settings.user)
  settings: UserSettings;

  // 메서드
  toResponseObject(): Partial<User> {
    const { password_hash, ...responseObject } = this;
    return responseObject;
  }

  updateLocation(latitude: number, longitude: number): void {
    this.latitude = latitude;
    this.longitude = longitude;
    this.last_active = new Date();
  }

  updateOnlineStatus(isOnline: boolean): void {
    this.is_online = isOnline;
    this.last_active = new Date();
  }
}
```

### 3.3 Friendship 엔티티
```typescript
// src/modules/friendships/entities/friendship.entity.ts
import { 
  Entity, 
  Column, 
  ManyToOne, 
  OneToMany,
  JoinColumn,
  Index 
} from 'typeorm';
import { BaseEntity } from '../../../common/entities/base.entity';
import { User } from '../../users/entities/user.entity';
import { Message } from '../../messages/entities/message.entity';
import { TemperatureHistory } from './temperature-history.entity';

export enum FriendshipStatus {
  PENDING = 'pending',
  ACCEPTED = 'accepted',
  REJECTED = 'rejected',
  BLOCKED = 'blocked'
}

@Entity('friendships')
@Index(['user_id'])
@Index(['friend_id'])
@Index(['status'])
export class Friendship extends BaseEntity {
  @Column()
  user_id: number;

  @Column()
  friend_id: number;

  @Column({
    type: 'enum',
    enum: FriendshipStatus,
    default: FriendshipStatus.PENDING
  })
  status: FriendshipStatus;

  @Column({ default: 50 })
  temperature: number;

  // 관계 정의
  @ManyToOne(() => User, user => user.friendships_as_user)
  @JoinColumn({ name: 'user_id' })
  user: User;

  @ManyToOne(() => User, user => user.friendships_as_friend)
  @JoinColumn({ name: 'friend_id' })
  friend: User;

  @OneToMany(() => Message, message => message.friendship)
  messages: Message[];

  @OneToMany(() => TemperatureHistory, history => history.friendship)
  temperature_history: TemperatureHistory[];

  // 메서드
  toResponseObject(): Partial<Friendship> {
    return {
      id: this.id,
      user_id: this.user_id,
      friend_id: this.friend_id,
      status: this.status,
      temperature: this.temperature,
      user: this.user?.toResponseObject(),
      friend: this.friend?.toResponseObject(),
      created_at: this.created_at
    };
  }

  updateTemperature(newTemperature: number, reason: string, description?: string): void {
    const oldTemperature = this.temperature;
    this.temperature = Math.max(0, Math.min(100, newTemperature));
    
    // 온도 변화 기록 생성
    const history = new TemperatureHistory();
    history.friendship_id = this.id;
    history.old_temperature = oldTemperature;
    history.new_temperature = this.temperature;
    history.reason = reason;
    history.description = description;
    
    this.temperature_history = this.temperature_history || [];
    this.temperature_history.push(history);
  }
}
```

### 3.4 Message 엔티티
```typescript
// src/modules/messages/entities/message.entity.ts
import { 
  Entity, 
  Column, 
  ManyToOne, 
  JoinColumn,
  Index 
} from 'typeorm';
import { BaseEntity } from '../../../common/entities/base.entity';
import { Friendship } from '../../friendships/entities/friendship.entity';
import { User } from '../../users/entities/user.entity';

export enum MessageType {
  TEXT = 'text',
  IMAGE = 'image',
  LOCATION = 'location'
}

@Entity('messages')
@Index(['friendship_id'])
@Index(['sender_id'])
@Index(['created_at'])
export class Message extends BaseEntity {
  @Column()
  friendship_id: number;

  @Column()
  sender_id: number;

  @Column('text')
  content: string;

  @Column({
    type: 'enum',
    enum: MessageType,
    default: MessageType.TEXT
  })
  message_type: MessageType;

  @Column({ nullable: true })
  image_url: string;

  @Column({ default: false })
  is_read: boolean;

  // 관계 정의
  @ManyToOne(() => Friendship, friendship => friendship.messages)
  @JoinColumn({ name: 'friendship_id' })
  friendship: Friendship;

  @ManyToOne(() => User, user => user.sent_messages)
  @JoinColumn({ name: 'sender_id' })
  sender: User;

  // 메서드
  toResponseObject(): Partial<Message> {
    return {
      id: this.id,
      friendship_id: this.friendship_id,
      sender_id: this.sender_id,
      content: this.content,
      message_type: this.message_type,
      image_url: this.image_url,
      is_read: this.is_read,
      sender: this.sender?.toResponseObject(),
      created_at: this.created_at
    };
  }

  markAsRead(): void {
    this.is_read = true;
  }
}
```

### 3.5 TemperatureHistory 엔티티
```typescript
// src/modules/friendships/entities/temperature-history.entity.ts
import { 
  Entity, 
  Column, 
  ManyToOne, 
  JoinColumn,
  Index 
} from 'typeorm';
import { BaseEntity } from '../../../common/entities/base.entity';
import { Friendship } from './friendship.entity';

export enum TemperatureReason {
  ACCEPT = 'accept',
  REJECT = 'reject',
  CHAT = 'chat',
  NEGATIVE = 'negative',
  POSITIVE = 'positive'
}

@Entity('temperature_history')
@Index(['friendship_id'])
@Index(['created_at'])
export class TemperatureHistory extends BaseEntity {
  @Column()
  friendship_id: number;

  @Column({ nullable: true })
  old_temperature: number;

  @Column({ nullable: true })
  new_temperature: number;

  @Column({
    type: 'enum',
    enum: TemperatureReason
  })
  reason: TemperatureReason;

  @Column('text', { nullable: true })
  description: string;

  // 관계 정의
  @ManyToOne(() => Friendship, friendship => friendship.temperature_history)
  @JoinColumn({ name: 'friendship_id' })
  friendship: Friendship;

  // 메서드
  toResponseObject(): Partial<TemperatureHistory> {
    return {
      id: this.id,
      friendship_id: this.friendship_id,
      old_temperature: this.old_temperature,
      new_temperature: this.new_temperature,
      reason: this.reason,
      description: this.description,
      created_at: this.created_at
    };
  }
}
```

### 3.6 UserSettings 엔티티
```typescript
// src/modules/users/entities/user-settings.entity.ts
import { 
  Entity, 
  Column, 
  OneToOne, 
  JoinColumn 
} from 'typeorm';
import { BaseEntity } from '../../../common/entities/base.entity';
import { User } from './user.entity';

@Entity('user_settings')
export class UserSettings extends BaseEntity {
  @Column({ unique: true })
  user_id: number;

  @Column({ default: true })
  notification_enabled: boolean;

  @Column({ default: true })
  location_sharing_enabled: boolean;

  @Column({ default: true })
  temperature_alert_enabled: boolean;

  @Column({ default: 1000 })
  max_distance: number;

  // 관계 정의
  @OneToOne(() => User, user => user.settings)
  @JoinColumn({ name: 'user_id' })
  user: User;

  // 메서드
  toResponseObject(): Partial<UserSettings> {
    return {
      id: this.id,
      user_id: this.user_id,
      notification_enabled: this.notification_enabled,
      location_sharing_enabled: this.location_sharing_enabled,
      temperature_alert_enabled: this.temperature_alert_enabled,
      max_distance: this.max_distance,
      created_at: this.created_at,
      updated_at: this.updated_at
    };
  }
}
```

## 4. TypeORM 쿼리 예시

### 4.1 사용자 관련 쿼리

#### 근처 사용자 검색 (1km 이내)
```typescript
// src/modules/users/users.service.ts
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './entities/user.entity';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private usersRepository: Repository<User>
  ) {}

  async findNearbyUsers(
    userId: number, 
    latitude: number, 
    longitude: number, 
    maxDistance: number = 1000
  ): Promise<Array<{ user: User; distance: number }>> {
    // Haversine 공식을 이용한 거리 계산
    const query = this.usersRepository
      .createQueryBuilder('user')
      .select([
        'user.*',
        `(
          6371000 * acos(
            cos(radians(:latitude)) * cos(radians(user.latitude)) *
            cos(radians(user.longitude) - radians(:longitude)) +
            sin(radians(:latitude)) * sin(radians(user.latitude))
          )
        ) as distance`
      ])
      .where('user.id != :userId', { userId })
      .andWhere('user.latitude IS NOT NULL')
      .andWhere('user.longitude IS NOT NULL')
      .andWhere(
        `(
          6371000 * acos(
            cos(radians(:latitude)) * cos(radians(user.latitude)) *
            cos(radians(user.longitude) - radians(:longitude)) +
            sin(radians(:latitude)) * sin(radians(user.latitude))
          )
        ) <= :maxDistance`,
        { maxDistance }
      )
      .orderBy('distance', 'ASC')
      .setParameters({ latitude, longitude, userId, maxDistance });

    const results = await query.getRawAndEntities();
    
    return results.entities.map((user, index) => ({
      user,
      distance: Math.round(results.raw[index].distance * 100) / 100
    }));
  }

  async updateUserOnlineStatus(userId: number, isOnline: boolean): Promise<void> {
    await this.usersRepository.update(userId, {
      is_online: isOnline,
      last_active: new Date()
    });
  }
}
```

### 4.2 친구 관계 관련 쿼리

#### 친구 요청 생성
```typescript
// src/modules/friendships/friendships.service.ts
import { Injectable, ConflictException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Friendship, FriendshipStatus } from './entities/friendship.entity';

@Injectable()
export class FriendshipsService {
  constructor(
    @InjectRepository(Friendship)
    private friendshipsRepository: Repository<Friendship>
  ) {}

  async createFriendRequest(userId: number, friendId: number): Promise<Friendship> {
    // 이미 존재하는 관계인지 확인
    const existingFriendship = await this.friendshipsRepository.findOne({
      where: [
        { user_id: userId, friend_id: friendId },
        { user_id: friendId, friend_id: userId }
      ]
    });

    if (existingFriendship) {
      throw new ConflictException('이미 친구 요청이 존재합니다.');
    }

    // 새로운 친구 관계 생성
    const friendship = this.friendshipsRepository.create({
      user_id: userId,
      friend_id: friendId,
      status: FriendshipStatus.PENDING,
      temperature: 50
    });

    return await this.friendshipsRepository.save(friendship);
  }

  async respondToFriendRequest(
    friendshipId: number, 
    userId: number, 
    action: 'accept' | 'reject'
  ): Promise<Friendship> {
    const friendship = await this.friendshipsRepository.findOne({
      where: { id: friendshipId, friend_id: userId }
    });

    if (!friendship) {
      throw new ConflictException('친구 요청을 찾을 수 없습니다.');
    }

    if (friendship.status !== FriendshipStatus.PENDING) {
      throw new ConflictException('이미 처리된 친구 요청입니다.');
    }

    if (action === 'accept') {
      friendship.status = FriendshipStatus.ACCEPTED;
      friendship.updateTemperature(friendship.temperature + 10, 'accept', '친구 요청 수락');
    } else {
      friendship.status = FriendshipStatus.REJECTED;
      friendship.updateTemperature(friendship.temperature - 10, 'reject', '친구 요청 거절');
    }

    return await this.friendshipsRepository.save(friendship);
  }
}
```

### 4.3 메시지 관련 쿼리

#### 메시지 전송
```typescript
// src/modules/messages/messages.service.ts
import { Injectable, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Message, MessageType } from './entities/message.entity';
import { Friendship, FriendshipStatus } from '../friendships/entities/friendship.entity';

@Injectable()
export class MessagesService {
  constructor(
    @InjectRepository(Message)
    private messagesRepository: Repository<Message>,
    @InjectRepository(Friendship)
    private friendshipsRepository: Repository<Friendship>
  ) {}

  async sendMessage(
    friendshipId: number,
    senderId: number,
    content: string,
    messageType: MessageType = MessageType.TEXT,
    imageUrl?: string
  ): Promise<Message> {
    // 친구 관계 확인
    const friendship = await this.friendshipsRepository.findOne({
      where: { id: friendshipId, status: FriendshipStatus.ACCEPTED }
    });

    if (!friendship) {
      throw new ForbiddenException('유효하지 않은 친구 관계입니다.');
    }

    // 메시지 생성
    const message = this.messagesRepository.create({
      friendship_id: friendshipId,
      sender_id: senderId,
      content,
      message_type: messageType,
      image_url: imageUrl
    });

    const savedMessage = await this.messagesRepository.save(message);

    // 온도 증가 (채팅 시)
    friendship.updateTemperature(friendship.temperature + 1, 'chat', '채팅 활동');
    await this.friendshipsRepository.save(friendship);

    return savedMessage;
  }

  async getMessages(friendshipId: number, limit: number = 50, offset: number = 0): Promise<Message[]> {
    return await this.messagesRepository.find({
      where: { friendship_id: friendshipId },
      relations: ['sender'],
      order: { created_at: 'DESC' },
      take: limit,
      skip: offset
    });
  }
}
```

## 5. TypeORM 마이그레이션

### 5.1 마이그레이션 설정
```typescript
// ormconfig.ts
import { DataSource } from 'typeorm';
import { config } from 'dotenv';

config();

export default new DataSource({
  type: 'postgres',
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT) || 5432,
  username: process.env.DB_USERNAME || 'postgres',
  password: process.env.DB_PASSWORD || 'password',
  database: process.env.DB_DATABASE || 'bapbuddy_db',
  entities: ['src/**/*.entity.ts'],
  migrations: ['src/database/migrations/*.ts'],
  synchronize: false,
  logging: process.env.NODE_ENV === 'development'
});
```

### 5.2 마이그레이션 파일 예시
```typescript
// src/database/migrations/1704067200000-CreateInitialTables.ts
import { MigrationInterface, QueryRunner } from 'typeorm';

export class CreateInitialTables1704067200000 implements MigrationInterface {
  name = 'CreateInitialTables1704067200000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    // users 테이블 생성
    await queryRunner.query(`
      CREATE TABLE "users" (
        "id" SERIAL NOT NULL,
        "email" character varying(255) NOT NULL,
        "password_hash" character varying(255) NOT NULL,
        "nickname" character varying(100) NOT NULL,
        "food_preferences" text array,
        "profile_image_url" character varying(500),
        "latitude" decimal(10,8),
        "longitude" decimal(11,8),
        "last_active" TIMESTAMP NOT NULL DEFAULT now(),
        "is_online" boolean NOT NULL DEFAULT false,
        "created_at" TIMESTAMP NOT NULL DEFAULT now(),
        "updated_at" TIMESTAMP NOT NULL DEFAULT now(),
        CONSTRAINT "UQ_97672ac88f789774dd47f7c8be3" UNIQUE ("email"),
        CONSTRAINT "PK_a3ffb1c0c8416b9fc6f907b7433" PRIMARY KEY ("id")
      )
    `);

    // 인덱스 생성
    await queryRunner.query(`CREATE INDEX "IDX_97672ac88f789774dd47f7c8be3" ON "users" ("email")`);
    await queryRunner.query(`CREATE INDEX "IDX_users_location" ON "users" ("latitude", "longitude")`);
    await queryRunner.query(`CREATE INDEX "IDX_users_last_active" ON "users" ("last_active")`);

    // friendships 테이블 생성
    await queryRunner.query(`
      CREATE TABLE "friendships" (
        "id" SERIAL NOT NULL,
        "user_id" integer NOT NULL,
        "friend_id" integer NOT NULL,
        "status" character varying(20) NOT NULL DEFAULT 'pending',
        "temperature" integer NOT NULL DEFAULT '50',
        "created_at" TIMESTAMP NOT NULL DEFAULT now(),
        "updated_at" TIMESTAMP NOT NULL DEFAULT now(),
        CONSTRAINT "UQ_friendships_user_friend" UNIQUE ("user_id", "friend_id"),
        CONSTRAINT "PK_friendships" PRIMARY KEY ("id")
      )
    `);

    // 외래키 제약조건 추가
    await queryRunner.query(`
      ALTER TABLE "friendships" 
      ADD CONSTRAINT "FK_friendships_user" 
      FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE NO ACTION
    `);

    await queryRunner.query(`
      ALTER TABLE "friendships" 
      ADD CONSTRAINT "FK_friendships_friend" 
      FOREIGN KEY ("friend_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE NO ACTION
    `);

    // 나머지 테이블들도 동일하게 생성...
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP TABLE "temperature_history"`);
    await queryRunner.query(`DROP TABLE "messages"`);
    await queryRunner.query(`DROP TABLE "friendships"`);
    await queryRunner.query(`DROP TABLE "user_settings"`);
    await queryRunner.query(`DROP TABLE "users"`);
  }
}
```

## 6. 성능 최적화

### 6.1 인덱스 전략
- **사용자 검색**: 위치 기반 검색을 위한 복합 인덱스
- **친구 관계**: 사용자별 친구 목록 조회를 위한 인덱스
- **메시지**: 시간순 정렬을 위한 인덱스
- **온도 기록**: 친구 관계별 온도 변화 추적을 위한 인덱스

### 6.2 쿼리 최적화
- **N+1 문제 해결**: relations 옵션 사용
- **페이지네이션**: take/skip 또는 커서 기반 페이지네이션
- **캐싱**: Redis를 이용한 자주 조회되는 데이터 캐싱

### 6.3 연결 풀 관리
```typescript
// src/config/database.config.ts
export const databaseConfig = {
  type: 'postgres',
  host: process.env.DB_HOST,
  port: parseInt(process.env.DB_PORT),
  username: process.env.DB_USERNAME,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_DATABASE,
  entities: ['dist/**/*.entity{.ts,.js}'],
  migrations: ['dist/database/migrations/*{.ts,.js}'],
  synchronize: false,
  logging: process.env.NODE_ENV === 'development',
  extra: {
    max: 20,
    connectionTimeoutMillis: 5000,
    idleTimeoutMillis: 30000,
  }
};
```

## 7. 보안 고려사항

### 7.1 데이터 암호화
- 비밀번호: bcrypt를 이용한 해싱
- 민감한 데이터: 필요시 암호화 저장

### 7.2 접근 제어
- 사용자별 데이터 접근 권한 확인
- SQL Injection 방지를 위한 TypeORM 파라미터화된 쿼리 사용

### 7.3 데이터 백업
- 정기적인 데이터베이스 백업
- 트랜잭션 로그 관리
