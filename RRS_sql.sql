create database rrs_db;
use rrs_db;

CREATE TABLE `USERS` (
	`USER_ID` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '유저ID 기본키',
	`NAME` VARCHAR(50) NOT NULL COMMENT '유저 이름',
	`USERNAME` VARCHAR(50) UNIQUE NOT NULL COMMENT '유저 로그인 아이디(중복안됨)',
	`PASSWORD` VARCHAR(255) NOT NULL COMMENT '유저 로그인 비밀번호',
	`NICKNAME` VARCHAR(50) UNIQUE NOT NULL COMMENT '유저 닉네임(중복안됨)',
	`PHONE` VARCHAR(20) UNIQUE NOT NULL COMMENT '휴대폰 번호(중복안됨)',
	`ADDRESS` VARCHAR(255) NOT NULL COMMENT '주소',
	`ADDRESS_DETAIL` VARCHAR(255) NOT NULL COMMENT '주소 상세',
	`EMAIL` VARCHAR(255) UNIQUE NOT NULL COMMENT '유저 이메일 (중복안됨)',
	`PROFILE_IMAGE_URL` VARCHAR(255) NOT NULL DEFAULT 'exAMPLE.JPG' COMMENT '프로필 사진 주소',
    `ROLES` VARCHAR(255) NOT NULL COMMENT 'ROLE_USER, ROLE_PROVIDER',
    `PROVIDER_INTRODUCTION` TEXT
);

CREATE TABLE `PETS` (
	`PET_ID` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '반려동물ID 기본키',
	`USER_ID` BIGINT NOT NULL COMMENT '유저ID 기본키',
	`PET_NAME` VARCHAR(200) NOT NULL COMMENT '반려동물 이름',
	`PET_GENDER` CHAR(1) NOT NULL COMMENT '반려동물 성별 0: 수컷, 1: 암컷',
	`PET_BIRTH_DATE` VARCHAR(10) NOT NULL COMMENT '반려동물 생일',
	`PET_WEIGHT` SMALLINT NOT NULL COMMENT '반려동물 체중',
	`PET_IMAGE_URL` VARCHAR(255) NOT NULL DEFAULT 'petExample.jpG' COMMENT '반려동물 프로필 사진 주소',
	`PET_ADD_INFO` VARCHAR(255) COMMENT '추가 정보',
	`PET_NEUTRALITY_YN` CHAR(1) NOT NULL COMMENT '중성화 여부 0: 중성화 X, 1: 중성화 O',
	FOREIGN KEY (`USER_ID`) REFERENCES `USERS` (`USER_ID`)
);

CREATE TABLE `CUSTOMER_SUPPORTS` (
	`CUSTOMER_SUPPORT_ID` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '고객센터 ID 기본키',
	`USER_ID` BIGINT NOT NULL COMMENT '유저ID 기본키',
	`CUSTOMER_SUPPORT_TITLE` VARCHAR(100) NOT NULL COMMENT '제목',
	`CUSTOMER_SUPPORT_CONTENT` TEXT NOT NULL COMMENT '내용',
	`CUSTOMER_SUPPORT_STATUS` CHAR(1) DEFAULT 0 NOT NULL COMMENT '처리상태 0: 미처리, 1: 처리완료',
	`CUSTOMER_SUPPORT_CREATE_AT` DATETIME NOT NULL COMMENT '생성 시간',
	`CUSTOMER_SUPPORT_CATEGORY` CHAR(1) NOT NULL COMMENT '0: 신고 / 1:문의',
	FOREIGN KEY (`USER_ID`) REFERENCES `USERS` (`USER_ID`)
);

CREATE TABLE `CUSTOMER_SUPPORT_ATTACHMENTS` (
	`CUSTOMER_SUPPORT_ATTACHMENT_ID` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '고객센터 첨부파일ID 기본키',
    `CUSTOMER_SUPPORT_ID` BIGINT NOT NULL COMMENT '고객센터 ID 기본키',
    `CUSTOMER_SUPPORT_ATTACHMENT_FILE` VARCHAR(255) COMMENT '파일 주소',
    FOREIGN KEY (`CUSTOMER_SUPPORT_ID`) REFERENCES `CUSTOMER_SUPPORTS` (`CUSTOMER_SUPPORT_ID`)
);

CREATE TABLE `AVAILABLE_DATE_OF_WEEK` (
	`AVAILABLE_DATE_OF_WEEK_ID` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '댕시터 근무일',
    `PROVIDER_ID` BIGINT NOT NULL COMMENT 'USER_ID /  ROLE_PROVIDER',
    `AVAILABLE_DATE` DATE NOT NULL COMMENT '댕시터가 가능한 날짜',
    FOREIGN KEY (`PROVIDER_ID`) REFERENCES `USERS` (`USER_ID`)
);

CREATE TABLE `RESERVATIONS` (
	`RESERVATION_ID` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '예약목록ID 기본키',
	`USER_ID` BIGINT NOT NULL COMMENT '유저ID 기본키',
	`PROVIDER_ID` BIGINT NOT NULL COMMENT 'USER_ID /  ROLE_PROVIDER',
	`RESERVATION_START_DATE` DATE NOT NULL COMMENT '이용 시작일',
	`RESERVATION_END_DATE` DATE NOT NULL COMMENT '이용 종료일',
	`RESERVATION_STATUS` ENUM('예약대기', '예약 진행중', '거절', '취소', '완료') DEFAULt '예약대기' COMMENT '',
	FOREIGN KEY (`USER_ID`) REFERENCES `USERS` (`USER_ID`),
	FOREIGN KEY (`PROVIDER_ID`) REFERENCES `USERS` (`USER_ID`)
);

CREATE TABLE `REVIEWS` (
	`REVIEW_ID` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '리뷰ID 기본키',
	`USER_ID` BIGINT NOT NULL COMMENT '유저ID 기본키',
    `PROVIDER_ID` BIGINT NOT NULL COMMENT 'USER_ID /  ROLE_PROVIDER',
    `REVIEW_CREATE_AT` DATETIME NOT NULL COMMENT '리뷰 생성일',
	`REVIEW_SCORE` SMALLINT NOT NULL COMMENT '별점',
	`REVIEW_CONTENT` TEXT NOT NULL COMMENT '리뷰 내용',
	FOREIGN KEY (`USER_ID`) REFERENCES `USERS` (`USER_ID`),
	FOREIGN KEY (`PROVIDER_ID`) REFERENCES `USERS` (`USER_ID`)
);

CREATE TABLE `HEALTH_RECORDS` (
	`HEALTH_RECORD_ID` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '건강기록ID 기본키',
	`PET_ID` BIGINT NOT NULL COMMENT '반려동물ID 기본키',
	`HEALTH_RECORD_WEIGHT` SMALLINT NOT NULL COMMENT '펫 체중',
	`HEALTH_RECORD_PET_AGE` SMALLINT NOT NULL COMMENT '펫 나이',
	`HEALTH_RECORD_ABNORMAL_SYMPTOMS` VARCHAR(255) NOT NULL COMMENT '이상 증상',
	`HEALTH_RECORD_CREATE_AT` DATETIME NOT NULL COMMENT '생성 시간',
	`HEALTH_RECORD_MEMO` TEXT COMMENT '메모',
	FOREIGN KEY (`PET_ID`) REFERENCES `PETS` (`PET_ID`)
);

CREATE TABLE `HEALTH_RECORDS_ATTACHMENTS` (
	`HEALTH_RECORDS_ATTACHMENT_ID` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '건강기록 첨부파일ID 기본키',
    `HEALTH_RECORD_ID` BIGINT NOT NULL COMMENT '건강기록ID 기본키',
    `HEALTH_RECORDS_ATTACHMENT_FILE` VARCHAR(255) COMMENT '건강기록 URL',
    FOREIGN KEY (`HEALTH_RECORD_ID`) REFERENCES `HEALTH_RECORDS` (`HEALTH_RECORD_ID`)
);

CREATE TABLE `WALKING_RECORDS` (
	`WALKING_RECORD_ID` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '산책기록ID 기본키',
	`PET_ID` BIGINT NOT NULL COMMENT '반려동물ID 기본키',
	`WALKING_RECORD_WEATHER_STATE` ENUM ('맑음', '흐림', '비', '눈') DEFAULT '맑음' NOT NULL COMMENT '날씨 상태',
	`WALKING_RECORD_DISTANCE` INT UNSIGNED NOT NULL COMMENT '산책 거리',
	`WALKING_RECORD_WALKING_TIME` INT UNSIGNED NOT NULL COMMENT '산책 시간',
	`WALKING_RECORD_CREATE_AT` DATETIME NOT NULL COMMENT '생성 시간',
	`WALKING_RECORD_MEMO` TEXT COMMENT '메모',
	FOREIGN KEY (`PET_ID`) REFERENCES `PETS` (`PET_ID`)
);

CREATE TABLE `WALKING_RECORD_ATTACHMENTS` (
	`WALKING_RECORD_ATTACHMENT_ID` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '산책기록 첨부파일ID 기본키',
    `WALKING_RECORD_ID` BIGINT NOT NULL COMMENT '산책기록ID 기본키',
    `WALKING_RECORD_ATTACHMENT_FILE` VARCHAR(255) COMMENT '산책기록 이미지 URL',
    FOREIGN KEY (`WALKING_RECORD_ID`) REFERENCES `WALKING_RECORDS` (`WALKING_RECORD_ID`)
);

CREATE TABLE `TODOS` (
	`TODO_ID` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '오늘할일ID 기본키',
	`USER_ID` BIGINT NOT NULL COMMENT '유저ID 기본키',
	`TODO_PREPARATION_CONTENT` VARCHAR(255) NOT NULL COMMENT '작성 내용',
	`TODO_CREATE_AT` DATETIME NOT NULL COMMENT '생성 시간',
	FOREIGN KEY (`USER_ID`) REFERENCES `USERS` (`USER_ID`)
);

CREATE TABLE `CERTIFICATION_NUMBERS` (
	`CERTIFICATION_NUMBER_ID` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '인증번호ID 기본키',
	`USER_EMAIL` VARCHAR(200) NOT NULL COMMENT '이메일',
	`USER_CART_NUM` CHAR(6) NOT NULL COMMENT '인증번호',
	`USER_SEND_TIME` DATETIME NOT NULL COMMENT '발송 시간',
	`USER_ID` BIGINT UNSIGNED COMMENT '회원정보가 없을 시에는 외래키를 가져올 수 없으므로 외래키로 잡지않았음'
);

CREATE TABLE `COMMUNITIES` (
	`COMMUNITY_ID` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '커뮤니티ID 기본키',
	`USER_ID` BIGINT NOT NULL COMMENT '유저ID 기본키',
	`COMMUNITY_TITLE` VARCHAR(255) NOT NULL COMMENT '커뮤니티 제목',
	`COMMUNITY_LIKE_COUNT` INT NOT NULL DEFAULT 0 COMMENT '좋아요 수',
	`COMMUNITY_CREATE_AT` DATETIME NOT NULL COMMENT '생성 시간',
	`COMMUNITY_UPDATE_AT` DATETIME NULL COMMENT '수정 시간',
	`COMMUNITY_CONTENTS` TEXT NOT NULL COMMENT '내용',
	`COMMUNITY_THUMBNAIL_URL` VARCHAR(255) NOT NULL DEFAULT 'exampLe.jpg' COMMENT '썸네일 URL',
	FOREIGN KEY (`USER_ID`) REFERENCES `USERS` (`USER_ID`) ON DELETE CASCADE
);
CREATE TABLE `COMMUNITY_ATTACHMENTS` (
	`COMMUNITY_ATTACHMENT_ID` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '커뮤니티 첨부파일ID 기본키',
	`COMMUNITY_ID` BIGINT NOT NULL COMMENT '커뮤니티ID 기본키',
	`COMMUNITY_ATTACHMENT_FILE` VARCHAR(255) COMMENT '첨부 파일',
	FOREIGN KEY (`COMMUNITY_ID`) REFERENCES `COMMUNITIES` (`COMMUNITY_ID`)
);

CREATE TABLE `COMMUNITY_COMMENTS` (
	`COMMUNITY_COMMENTS_ID` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '커뮤니티 댓글ID 기본키',
	`COMMUNITY_ID` BIGINT NOT NULL COMMENT '커뮤니티ID 기본키',
	`COMMUNITY_COMMENTS_CONTENTS` VARCHAR(255) NOT NULL COMMENT '댓글 내용',
	FOREIGN KEY (`COMMUNITY_ID`) REFERENCES `COMMUNITIES` (`COMMUNITY_ID`)
);

CREATE TABLE `ANNOUNCEMENTS` (
	`ANNOUNCEMENT_ID` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '공지사항ID기본키',
	`ANNOUNCEMENT_TITLE` VARCHAR(255) NOT NULL COMMENT '공지사항제목',
	`ANNOUNCEMENT_CONTENT` VARCHAR(255) NOT NULL COMMENT '공지사항내용',
	`ANNOUNCEMENT_CREATE_AT` DATETIME NOT NULL COMMENT '생성시간'
);