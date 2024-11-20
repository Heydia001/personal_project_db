create database if not exists rrs_db;
use rrs_db;
CREATE TABLE `USERS` (
	`ID` bigint unsigned PRIMARY KEY AUTO_INCREMENT COMMENT '유저ID 기본키',
	`USER_NAME` VARCHAR(50) NOT NULL COMMENT '유저 이름',
	`USER_ID` VARCHAR(50) UNIQUE NOT NULL COMMENT '유저 로그인 아이디(중복안됨)',
	`USER_PASSWORD` VARCHAR(255) NOT NULL COMMENT '유저 로그인 비밀번호',
	`USER_NICK_NAME` VARCHAR(50) UNIQUE NOT NULL COMMENT '유저 닉네임(중복안됨)',
	`USER_PHONE` CHAR(11) UNIQUE NOT NULL COMMENT '휴대폰 번호(중복안됨)',
	`USER_ADDRESS` VARCHAR(255) NOT NULL COMMENT '주소',
	`USER_ADDRESS_DETAIL` VARCHAR(255) NOT NULL COMMENT '주소 상세',
	`USER_EMAIL` VARCHAR(255) UNIQUE NOT NULL COMMENT '유저 이메일 (중복안됨)',
	`USER_PROFILE_IMAGE_URL` VARCHAR(255) COMMENT '프로필 사진 주소'
);

CREATE TABLE `PET_PROFILES` (
	`PET_PROFILE_ID` bigint unsigned PRIMARY KEY AUTO_INCREMENT COMMENT '반려동물ID 기본키',
	`ID` bigint unsigned NOT NULL COMMENT '유저ID 기본키',
	`PET_PROFILE_NAME` VARCHAR(200) NOT NULL COMMENT '반려동물 이름',
	`PET_PROFILE_GENDER` CHAR(1) NOT NULL COMMENT '반려동물 성별 0: 수컷, 1: 암컷',
	`PET_PROFILE_BIRTH_DATE` CHAR(6) NOT NULL COMMENT '반려동물 생일',
	`PET_PROFILE_WEIGHT` SMALLINT NOT NULL COMMENT '반려동물 체중',
	`PET_PROFILE_IMAGE_URL` VARCHAR(255) COMMENT '반려동물 프로필 사진 주소',
	`PET_PROFILE_ADD_INFO` VARCHAR(255) COMMENT '추가 정보',
	`PET_PROFILE_NEUTRALITY_YN` CHAR(1) NOT NULL COMMENT '중성화 여부 0: 중성화 X, 1: 중성화 O',
	FOREIGN KEY (`ID`) REFERENCES `USERS` (`ID`)
);

CREATE TABLE `CUSTOMER_SUPPORTS` (
	`CUSTOMER_SUPPORT_ID` bigint unsigned PRIMARY KEY AUTO_INCREMENT COMMENT '고객센터 ID 기본키',
	`ID` bigint unsigned NOT NULL COMMENT '유저ID 기본키',
	`CUSTOMER_SUPPORT_TITLE` VARCHAR(100) NOT NULL COMMENT '제목',
	`CUSTOMER_SUPPORT_CONTENT` VARCHAR(500) NOT NULL COMMENT '내용',
	`CUSTOMER_SUPPORT_STATUS` CHAR(1) DEFAULT 0 NOT NULL COMMENT '처리상태 0: 미처리, 1: 처리완료',
	`CUSTOMER_SUPPORT_CREATE_AT` DATETIME NOT NULL COMMENT '생성 시간',
	`CUSTOMER_SUPPORT_CATEGORY` CHAR(1) NOT NULL COMMENT '0: 신고 / 1:문의',
	FOREIGN KEY (`ID`) REFERENCES `USERS` (`ID`)
);

CREATE TABLE `PROVIDERS` (
	`PROVIDER_ID` bigint unsigned PRIMARY KEY AUTO_INCREMENT COMMENT '댕시터(제공제)ID 기본키',
	`ID` bigint unsigned UNIQUE NOT NULL COMMENT '유저ID 기본키',
	`PROVIDER_INTRODUCTION` VARCHAR(255) NOT NULL COMMENT '댕시터 소개',
	`PROVIDER_PROVISION_YN` CHAR(1) DEFAULT 0 NOT NULL COMMENT '영업 여부 0: 영업중지, 1: 영업중',
	`MON` CHAR(1) NOT NULL COMMENT '월요일 0: 영업 X, 1: 영업 O',
	`TUE` CHAR(1) NOT NULL COMMENT '화요일 0: 영업 X, 1: 영업 O',
	`WED` CHAR(1) NOT NULL COMMENT '수요일 0: 영업 X, 1: 영업 O',
	`THU` CHAR(1) NOT NULL COMMENT '목요일 0: 영업 X, 1: 영업 O',
	`FRI` CHAR(1) NOT NULL COMMENT '금요일 0: 영업 X, 1: 영업 O', 
	`SAT` CHAR(1) NOT NULL COMMENT '토요일 0: 영업 X, 1: 영업 O',
	`SUN` CHAR(1) NOT NULL COMMENT '일요일 0: 영업 X, 1: 영업 O',
	`PROVIDER_PROVISION_OPTION` SET('WALK', 'BATH', 'FOOD', 'NONE') NOT NULL COMMENT '산책, 목욕, 밥주기, 선택안함',
	FOREIGN KEY (`ID`) REFERENCES `USERS` (`ID`)
);

CREATE TABLE `RESERVATIONS` (
	`RESERVATION_ID` bigint unsigned PRIMARY KEY AUTO_INCREMENT COMMENT '예약목록ID 기본키',
	`ID` bigint unsigned NOT NULL COMMENT '유저ID 기본키',
	`PROVIDER_ID` bigint unsigned NOT NULL COMMENT '댕시터(제공제)ID 기본키',
	`RESERVATION_START_DATE` DATE NOT NULL COMMENT '이용 시작일',
	`RESERVATION_END_DATE` DATE NOT NULL COMMENT '이용 종료일',
	`RESERVATION_CREATE_AT` DATETIME NOT NULL COMMENT '생성 시간',
	`RESERVATION_STATUS` CHAR(1) DEFAULT 0 COMMENT '예약 상태 0: 예약대기, 1: 예약수락(진행중), 2: 예약거절, 3: 예약취소, 4: 완료',
	FOREIGN KEY (`ID`) REFERENCES `USERS` (`ID`),
	FOREIGN KEY (`PROVIDER_ID`) REFERENCES `PROVIDERS` (`PROVIDER_ID`)
);

CREATE TABLE `REVIEWS` (
	`REVIEW_ID` bigint unsigned PRIMARY KEY AUTO_INCREMENT COMMENT '리뷰ID 기본키',
	`ID` bigint unsigned NOT NULL COMMENT '유저ID 기본키',
	`PROVIDER_ID` bigint unsigned NOT NULL COMMENT '댕시터(제공제)ID 기본키',
    `REVIEW_CREATE_AT` DATETIME NOT NULL COMMENT '리뷰 생성일',
	`REVIEW_SCORE` SMALLINT NOT NULL COMMENT '별점',
	`REVIEW_CONTENT` VARCHAR(500) NOT NULL COMMENT '리뷰 내용',
	FOREIGN KEY (`PROVIDER_ID`) REFERENCES `PROVIDERS` (`PROVIDER_ID`)
);

CREATE TABLE `HEALTH_RECORDS` (
	`HEALTH_ID` bigint unsigned PRIMARY KEY AUTO_INCREMENT COMMENT '건강기록ID 기본키',
	`PET_PROFILE_ID` bigint unsigned NOT NULL COMMENT '반려동물ID 기본키',
	`HEALTH_RECORD_WEIGHT` SMALLINT NOT NULL COMMENT '펫 체중',
	`HEALTH_RECORD_PET_AGE` SMALLINT NOT NULL COMMENT '펫 나이',
	`HEALTH_RECORD_ABNORMAL_SYMPTOMS` VARCHAR(255) NOT NULL COMMENT '이상 증상',
	`HEALTH_RECORD_MEDICAL_RECORD` VARCHAR(500) NOT NULL COMMENT '진료 내역',
	`HEALTH_RECORD_CREATE_TIME` DATETIME NOT NULL COMMENT '작성자가 설정한 생성시간',
	`HEALTH_RECORD_CREATE_AT` DATETIME NOT NULL COMMENT '생성 시간',
	`HEALTH_RECORD_ABNORMAL_SYMPTOMS_IMAGE_URL` VARCHAR(255) NULL COMMENT '이상 증상 사진 URL',
	`HEALTH_RECORD_MEMO` TEXT NULL COMMENT '메모',
	FOREIGN KEY (`PET_PROFILE_ID`) REFERENCES `PET_PROFILES` (`PET_PROFILE_ID`)
);

CREATE TABLE `WALKING_RECORDS` (
	`WALKING_RECORD_ID` bigint unsigned PRIMARY KEY AUTO_INCREMENT COMMENT '산책기록ID 기본키',
	`PET_PROFILE_ID` bigint unsigned NOT NULL COMMENT '반려동물ID 기본키',
	`WALKING_RECORD_WEATHER_STATE` CHAR(1) DEFAULT 0 NOT NULL COMMENT '날씨 상태 0: 맑음, 1: 흐림, 2: 비, 3: 눈',
	`WALKING_RECORD_DISTANCE` int unsigned NOT NULL COMMENT '산책 거리',
	`WALKING_RECORD_CREATE_TIME` DATETIME NOT NULL COMMENT '작성자가 설정한 생성시간',
	`WALKING_RECORD_WALKING_TIME` TIME NOT NULL COMMENT '산책 시간',
	`WALKING_RECORD_CREATE_AT` DATETIME NOT NULL COMMENT '생성 시간',
	`WALKING_RECORD_MEMO` TEXT NOT NULL COMMENT '메모',
	`WALKING_RECORD_IMAGE_URL` VARCHAR(255) NULL COMMENT '산책 기록 이미지 URL',
	FOREIGN KEY (`PET_PROFILE_ID`) REFERENCES `PET_PROFILES` (`PET_PROFILE_ID`)
);

CREATE TABLE `TODOS` (
	`TODO_ID` bigint unsigned PRIMARY KEY AUTO_INCREMENT COMMENT '오늘할일ID 기본키',
	`ID` bigint unsigned NOT NULL COMMENT '유저ID 기본키',
	`TODO_PREPARATION_CONTENT` VARCHAR(255) NOT NULL COMMENT '작성 내용',
	`TODO_CREATE_AT` DATETIME NOT NULL COMMENT '생성 시간',
	FOREIGN KEY (`ID`) REFERENCES `USERS` (`ID`)
);

CREATE TABLE `CERTIFICATION_NUMBERS` (
	`CERTIFICATION_NUMBER_ID` bigint unsigned PRIMARY KEY AUTO_INCREMENT COMMENT '인증번호ID 기본키',
	`USER_EMAIL` VARCHAR(200) NOT NULL COMMENT '이메일',
	`USER_CART_NUM` CHAR(6) NOT NULL COMMENT '인증번호',
	`USER_SEND_TIME` DATETIME NOT NULL COMMENT '발송 시간',
	`USER_ID` bigint unsigned COMMENT '회원정보가 없을 시에는 외래키를 가져올 수 없으므로 외래키로 잡지않았음'
);

CREATE TABLE `COMMUNITIES` (
	`COMMUNITY_ID` bigint unsigned PRIMARY KEY AUTO_INCREMENT COMMENT '커뮤니티ID 기본키',
	`ID` bigint unsigned NOT NULL COMMENT '유저ID 기본키',
	`COMMUNITY_TITLE` VARCHAR(255) NOT NULL COMMENT '커뮤니티 제목',
	`COMMUNITY_LIKE_COUNT` int unsigned NOT NULL DEFAULT 0 COMMENT '좋아요 수',
	`COMMUNITY_CREATE_AT` DATETIME NOT NULL COMMENT '생성 시간',
	`COMMUNITY_UPDATE_AT` DATETIME NULL COMMENT '수정 시간',
	`COMMUNITY_CONTENTS` TEXT NOT NULL COMMENT '내용',
	`COMMUNITY_THUMB_NAIL_IMG_URL` VARCHAR(255) NULL COMMENT '썸네일 이미지 URL',
	FOREIGN KEY (`ID`) REFERENCES `USERS` (`ID`)
);

CREATE TABLE `COMMUNITY_ATTACHMENTS` (
	`COMMUNITY_ATTACHMENT_ID` bigint unsigned PRIMARY KEY AUTO_INCREMENT COMMENT '커뮤니티 첨부파일ID 기본키',
	`COMMUNITY_ID` bigint unsigned NOT NULL COMMENT '커뮤니티ID 기본키',
	`COMMUNITY_ATTACHMENT_IMAGE_URL` VARCHAR(255) NULL COMMENT '첨부 이미지 URL',
	FOREIGN KEY (`COMMUNITY_ID`) REFERENCES `COMMUNITIES` (`COMMUNITY_ID`)
);

CREATE TABLE `CUSTOMER_SUPPORT_ATTACHMENTS` (
	`CUSTOMER_SUPPORT_ATTACHMENT_ID` bigint unsigned PRIMARY KEY AUTO_INCREMENT COMMENT '고객센터 첨부파일ID 기본키',
	`CUSTOMER_SUPPORT_ID` bigint unsigned NOT NULL COMMENT '고객센터 ID 기본키',
	`CUSTOMER_SUPPORT_ATTACHMENT_FILE_URL` VARCHAR(255) NULL COMMENT '파일 주소',
	FOREIGN KEY (`CUSTOMER_SUPPORT_ID`) REFERENCES `CUSTOMER_SUPPORTS` (`CUSTOMER_SUPPORT_ID`)
);

CREATE TABLE `COMMUNITY_COMMENTS` (
	`COMMUNITY_COMMENTS_ID` bigint unsigned PRIMARY KEY AUTO_INCREMENT COMMENT '커뮤니티 댓글ID 기본키',
	`COMMUNITY_ID` bigint unsigned NOT NULL COMMENT '커뮤니티ID 기본키',
	`ID` bigint unsigned NOT NULL COMMENT '유저ID 기본키',
	`COMMUNITY_COMMENTS_PARENT_REPLY` CHAR(1) NOT NULL COMMENT '원댓글 여부 0: 원댓글, 1: 대댓글',
	`COMMUNITY_COMMENTS_CONTENTS` VARCHAR(255) NOT NULL COMMENT '댓글 내용',
	FOREIGN KEY (`COMMUNITY_ID`) REFERENCES `COMMUNITIES` (`COMMUNITY_ID`),
	FOREIGN KEY (`ID`) REFERENCES `USERS` (`ID`)
);

CREATE TABLE `ANNOUNCEMENTS` (
	`ANNOUNCEMENT_ID` bigint unsigned PRIMARY KEY AUTO_INCREMENT COMMENT '공지사항ID기본키',
	`ANNOUNCEMENT_TITLE` VARCHAR(255) NOT NULL COMMENT '공지사항제목',
	`ANNOUNCEMENT_CONTENT` VARCHAR(255) NOT NULL COMMENT '공지사항내용',
	`ANNOUNCEMENT_CREATE_AT` DATETIME NOT NULL COMMENT '생성시간'
);
