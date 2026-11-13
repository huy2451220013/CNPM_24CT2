-- ========================================================
-- CƠ SỞ DỮ LIỆU DỰ ÁN PICKLEPRO - WEBSITE ĐẶT SÂN PICKLEBALL
-- Thời gian xuất: 2026-11-06 08:52:20
-- Sinh viên: Trần Quốc Huy - Lớp: 24CT2 - MSSV: 2451220013
-- Giảng viên hướng dẫn: ThS. Phạm Thị Dung
-- Hệ quản trị CSDL: MySQL / MariaDB (XAMPP)
-- ========================================================

CREATE DATABASE IF NOT EXISTS `picklepro` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `picklepro`;

SET FOREIGN_KEY_CHECKS=0;

-- --------------------------------------------------------
-- Cấu trúc bảng cho `auth_user`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `auth_user`;
CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dữ liệu mẫu cho bảng `auth_user` (4 bản ghi)
INSERT INTO `auth_user` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`) VALUES
(1, 'pbkdf2_sha256$600000$yAfJaUf2o4TEIB1UKi04GL$Wi2OqR/M3qE7y0pOrpon5qTZEBGDLQ+PfjQAyajdZsc=', '2026-11-06 00:54:30.150090', 1, 'admin', '', '', 'admin@gmail.com', 1, 1, '2026-10-09 01:16:44.875385'),
(2, 'pbkdf2_sha256$600000$2G3KXO7U9swr2UXyDKmHRG$UmR0CGW45Bw+8sZmLcvvSqTJKJU+Rd0z6nldCwDu23U=', NULL, 0, 'khachhang', 'Nguyễn', 'Văn An', 'an.nguyen@gmail.com', 0, 1, '2026-10-09 01:37:38.167624'),
(3, 'pbkdf2_sha256$600000$odtvIb2WkyBOQP2dEwpuPF$I8QXV+bD8PehzUWSXJdHIw5q2m4QzUf843OFPawmCRs=', '2026-10-09 02:24:47', 0, 'Huy132', 'Trần', 'Huy', 'tranquochuy1322006@gmail.com', 0, 1, '2026-10-09 02:07:18'),
(4, 'pbkdf2_sha256$600000$zyCw9Ow1Rzx8RR3fTOntxr$BNedA+jVAoTn9lJu+GRyKy2loUk1KRSDt1mYxN4We54=', NULL, 0, 'Hin132', '', '', '', 0, 1, '2026-10-09 02:32:53.567084');

-- --------------------------------------------------------
-- Cấu trúc bảng cho `accounts_userprofile`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `accounts_userprofile`;
CREATE TABLE `accounts_userprofile` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `phone_number` varchar(20) NOT NULL,
  `address` varchar(255) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `accounts_userprofile_user_id_92240672_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dữ liệu mẫu cho bảng `accounts_userprofile` (3 bản ghi)
INSERT INTO `accounts_userprofile` (`id`, `phone_number`, `address`, `user_id`) VALUES
(1, '0901234567', 'Quận 1, TP. Hồ Chí Minh', 1),
(2, '0987654321', 'Quận 7, TP. Hồ Chí Minh', 2),
(3, '0948262522', '', 3);

-- --------------------------------------------------------
-- Cấu trúc bảng cho `courts_court`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `courts_court`;
CREATE TABLE `courts_court` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `code` varchar(20) NOT NULL,
  `location` varchar(255) NOT NULL,
  `price_per_hour` decimal(10,0) NOT NULL,
  `status` varchar(20) NOT NULL,
  `description` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `court_type` varchar(20) NOT NULL,
  `features` varchar(255) NOT NULL,
  `image_url` varchar(500) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dữ liệu mẫu cho bảng `courts_court` (6 bản ghi)
INSERT INTO `courts_court` (`id`, `name`, `code`, `location`, `price_per_hour`, `status`, `description`, `created_at`, `updated_at`, `court_type`, `features`, `image_url`) VALUES
(2, 'Sân PicklePro 01 (Tiêu Chuẩn)', 'PK-01', 'Khu A - Tầng 1 (Sân trung tâm)', '120000', 'available', 'Sân Pickleball trong nhà tiêu chuẩn thi đấu quốc tế, mặt sân sơn acrylic 5 lớp giảm chấn thương, trang bị hệ thống chiếu sáng không chói mắt.', '2026-10-09 01:37:38.421593', '2026-10-09 01:37:38.421593', 'indoor', 'Mặt sân USAPA, Đèn LED 500 Lux, Điều hòa trung tâm, Ghế nghỉ cao cấp, Nước uống miễn phí', 'https://images.unsplash.com/photo-1595435934249-5df7ed86e1c0?w=800&auto=format&fit=crop&q=80'),
(3, 'Sân PicklePro 02 (VIP Máy Lạnh)', 'PK-02', 'Khu VIP - Tầng 2 (View toàn cảnh)', '180000', 'available', 'Sân VIP đẳng cấp sang trọng, dành riêng cho người chơi yêu cầu sự riêng tư tuyệt đối, dịch vụ phục vụ đồ uống và khăn lạnh tận nơi.', '2026-10-09 01:37:38.423366', '2026-10-09 01:37:38.423366', 'vip', 'Không gian riêng tư, Điều hòa 22°C, Thảm đệm giảm chấn, Tủ locker bảo mật, Khăn lạnh & Nước khoáng', 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800&auto=format&fit=crop&q=80'),
(4, 'Sân PicklePro 03 (Ngoài Trời Xanh)', 'PK-03', 'Khu B - Sân trời mở (Khuôn viên công viên)', '90000', 'available', 'Sân ngoài trời thoáng đãng, lý tưởng cho những trận đấu buổi sáng sớm hoặc chiều tối đầy năng lượng cùng bạn bè và câu lạc bộ.', '2026-10-09 01:37:38.428851', '2026-10-09 01:37:38.428851', 'outdoor', 'Không khí tự nhiên thoáng đãng, Đèn cao áp ban đêm, Lưới thi đấu USAPA, Bãi đỗ xe ô tô rộng', 'https://images.unsplash.com/photo-1622163642998-1ea32b0bbc67?w=800&auto=format&fit=crop&q=80'),
(5, 'Sân PicklePro 04 (Khán Đài Thi Đấu)', 'PK-04', 'Khu A - Sân Khán đài trung tâm', '150000', 'available', 'Sân chuyên dụng cho các trận chung kết, giải đấu phong trào và giao lưu mở rộng với khán đài cho cổ động viên theo dõi.', '2026-10-09 01:37:38.431862', '2026-10-09 01:37:38.431862', 'indoor', 'Khán đài 100 chỗ ngồi, Camera quay chậm VAR, Bảng điểm điện tử LED, Hệ thống âm thanh sôi động', 'https://images.unsplash.com/photo-1554068865-24cecd4e34b8?w=800&auto=format&fit=crop&q=80'),
(6, 'Sân PicklePro 05 (Sân Đôi Chuyên Nghiệp)', 'PK-05', 'Khu B - Sân đôi 2', '100000', 'maintenance', 'Sân đang trong lịch bảo dưỡng định kỳ thay lưới và kẻ lại vạch thi đấu. Dự kiến mở lại vào đầu tuần tới.', '2026-10-09 01:37:38.433520', '2026-10-09 01:37:38.433520', 'outdoor', 'Mặt sân chống trượt, Lưới chống gió, Hệ thống thoát nước nhanh', 'https://images.unsplash.com/photo-1587280501635-68a0e82cd5ff?w=800&auto=format&fit=crop&q=80'),
(7, 'Sân PicklePro 06 (Lounge Club VIP)', 'PK-06', 'Khu VIP - Tầng 2 Cạnh Coffee Lounge', '200000', 'available', 'Trải nghiệm thể thao phong cách sống thời thượng kết hợp giữa thể thao rèn luyện sức khỏe và thư giãn giao lưu tại khu Lounge.', '2026-10-09 01:37:38.435532', '2026-10-09 01:37:38.435532', 'vip', 'Liền kề quầy Lounge phục vụ nước ép sinh tố, Ghế massage thư giãn, HLV tư vấn kỹ thuật', 'https://images.unsplash.com/photo-1540497077202-7c8a3999166f?w=800&auto=format&fit=crop&q=80');

-- --------------------------------------------------------
-- Cấu trúc bảng cho `bookings_booking`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `bookings_booking`;
CREATE TABLE `bookings_booking` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `booking_code` varchar(30) NOT NULL,
  `customer_name` varchar(100) NOT NULL,
  `customer_phone` varchar(20) NOT NULL,
  `customer_email` varchar(254) NOT NULL,
  `booking_date` date NOT NULL,
  `start_time` time(6) NOT NULL,
  `end_time` time(6) NOT NULL,
  `total_price` decimal(12,0) NOT NULL,
  `status` varchar(20) NOT NULL,
  `payment_status` varchar(20) NOT NULL,
  `payment_method` varchar(20) NOT NULL,
  `notes` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `court_id` bigint(20) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `booking_code` (`booking_code`),
  KEY `bookings_booking_court_id_ca2f87fe_fk_courts_court_id` (`court_id`),
  KEY `bookings_booking_user_id_834dfc23_fk_auth_user_id` (`user_id`),
  CONSTRAINT `bookings_booking_court_id_ca2f87fe_fk_courts_court_id` FOREIGN KEY (`court_id`) REFERENCES `courts_court` (`id`),
  CONSTRAINT `bookings_booking_user_id_834dfc23_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dữ liệu mẫu cho bảng `bookings_booking` (11 bản ghi)
INSERT INTO `bookings_booking` (`id`, `booking_code`, `customer_name`, `customer_phone`, `customer_email`, `booking_date`, `start_time`, `end_time`, `total_price`, `status`, `payment_status`, `payment_method`, `notes`, `created_at`, `updated_at`, `court_id`, `user_id`) VALUES
(1, 'PKB-753C82F9', 'Nguyễn Văn An', '0987654321', 'an.nguyen@gmail.com', '2026-10-09', '7:00:00', '9:00:00', '240000', 'confirmed', 'paid', 'banking', 'Cần chuẩn bị thêm 2 vợt cho người mới chơi', '2026-10-09 01:37:38.446817', '2026-10-09 01:37:38.446817', 2, 2),
(2, 'PKB-316C9F52', 'Trần Thị Mai', '0912345678', 'mai.tran@gmail.com', '2026-10-09', '17:00:00', '19:00:00', '360000', 'confirmed', 'paid', 'banking', 'Đặt sân VIP công ty giao lưu', '2026-10-09 01:37:38.449825', '2026-10-09 01:37:38.449825', 3, NULL),
(3, 'PKB-08609F00', 'Lê Hoàng Quân', '0933221100', 'quan.le@gmail.com', '2026-10-09', '19:00:00', '21:00:00', '180000', 'confirmed', 'unpaid', 'cash', 'Thanh toán tiền mặt khi tới nhận sân', '2026-10-09 01:37:38.451788', '2026-10-09 02:12:22.143944', 4, NULL),
(4, 'PKB-24B41796', 'Nguyễn Văn An', '0987654321', 'an.nguyen@gmail.com', '2026-10-10', '8:00:00', '10:00:00', '300000', 'confirmed', 'paid', 'banking', 'Trận đấu giao lưu nội bộ câu lạc bộ', '2026-10-09 01:37:38.453066', '2026-10-09 01:37:38.453066', 5, 2),
(6, 'PKB-6461A8AA', 'Trần Huy', '0948262522', 'tranquochuy1322006@gmail.com', '2026-10-09', '12:00:00', '22:00:00', '1200000', 'confirmed', 'paid', 'banking', '', '2026-10-09 02:07:50.640877', '2026-10-09 02:12:36.078543', 2, 3),
(7, 'PKB-B7FA0473', 'admin', '0901234567', 'admin@gmail.com', '2026-10-11', '15:00:00', '21:00:00', '1080000', 'pending', 'unpaid', 'banking', 'a huy', '2026-10-09 02:19:25.134125', '2026-10-09 02:19:25.134125', 3, 1),
(8, 'PKB-DBD0E662', 'huy', '0901234568', 'huy@gmail.com', '2026-10-16', '7:00:00', '14:00:00', '840000', 'completed', 'unpaid', 'cash', '', '2026-10-16 00:43:14.079291', '2026-10-16 00:43:47.906170', 2, 1),
(9, 'PKB-313614E6', 'admin', '0901234567', 'admin@gmail.com', '2026-10-16', '8:00:00', '12:00:00', '720000', 'pending', 'unpaid', 'banking', '', '2026-10-16 00:55:36.322959', '2026-10-16 00:55:36.322959', 3, 1),
(10, 'PKB-051A8579', 'huy', '0948262522', 'huy@gmail.com', '2026-10-16', '18:00:00', '21:00:00', '360000', 'pending', 'unpaid', 'banking', '', '2026-10-16 01:11:21.838918', '2026-10-16 01:11:21.838918', 2, NULL),
(11, 'PKB-25DDFE28', 'Trần Quốc Huy', '123123', 'tranquochuy1322006@gmail.com', '2026-10-23', '19:00:00', '22:00:00', '360000', 'pending', 'unpaid', 'banking', '', '2026-10-16 15:26:04.871945', '2026-10-16 15:26:04.871945', 2, NULL),
(12, 'PKB-354F75C5', 'Trần Quốc Huy', '123123', 'tranquochuy1322006@gmail.com', '2026-11-04', '6:00:00', '7:00:00', '90000', 'pending', 'unpaid', 'banking', '', '2026-11-04 07:30:06.385665', '2026-11-04 07:30:06.385665', 4, NULL);

-- --------------------------------------------------------
-- Cấu trúc bảng cho `auth_group`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `auth_group`;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Cấu trúc bảng cho `auth_group_permissions`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `auth_group_permissions`;
CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Cấu trúc bảng cho `auth_permission`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `auth_permission`;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dữ liệu mẫu cho bảng `auth_permission` (36 bản ghi)
INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add log entry', 1, 'add_logentry'),
(2, 'Can change log entry', 1, 'change_logentry'),
(3, 'Can delete log entry', 1, 'delete_logentry'),
(4, 'Can view log entry', 1, 'view_logentry'),
(5, 'Can add permission', 2, 'add_permission'),
(6, 'Can change permission', 2, 'change_permission'),
(7, 'Can delete permission', 2, 'delete_permission'),
(8, 'Can view permission', 2, 'view_permission'),
(9, 'Can add group', 3, 'add_group'),
(10, 'Can change group', 3, 'change_group'),
(11, 'Can delete group', 3, 'delete_group'),
(12, 'Can view group', 3, 'view_group'),
(13, 'Can add user', 4, 'add_user'),
(14, 'Can change user', 4, 'change_user'),
(15, 'Can delete user', 4, 'delete_user'),
(16, 'Can view user', 4, 'view_user'),
(17, 'Can add content type', 5, 'add_contenttype'),
(18, 'Can change content type', 5, 'change_contenttype'),
(19, 'Can delete content type', 5, 'delete_contenttype'),
(20, 'Can view content type', 5, 'view_contenttype'),
(21, 'Can add session', 6, 'add_session'),
(22, 'Can change session', 6, 'change_session'),
(23, 'Can delete session', 6, 'delete_session'),
(24, 'Can view session', 6, 'view_session'),
(25, 'Can add Sân', 7, 'add_court'),
(26, 'Can change Sân', 7, 'change_court'),
(27, 'Can delete Sân', 7, 'delete_court'),
(28, 'Can view Sân', 7, 'view_court'),
(29, 'Can add Hồ sơ người dùng', 8, 'add_userprofile'),
(30, 'Can change Hồ sơ người dùng', 8, 'change_userprofile'),
(31, 'Can delete Hồ sơ người dùng', 8, 'delete_userprofile'),
(32, 'Can view Hồ sơ người dùng', 8, 'view_userprofile'),
(33, 'Can add Lịch đặt sân', 9, 'add_booking'),
(34, 'Can change Lịch đặt sân', 9, 'change_booking'),
(35, 'Can delete Lịch đặt sân', 9, 'delete_booking'),
(36, 'Can view Lịch đặt sân', 9, 'view_booking');

-- --------------------------------------------------------
-- Cấu trúc bảng cho `auth_user_groups`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `auth_user_groups`;
CREATE TABLE `auth_user_groups` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Cấu trúc bảng cho `auth_user_user_permissions`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `auth_user_user_permissions`;
CREATE TABLE `auth_user_user_permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Cấu trúc bảng cho `django_admin_log`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `django_admin_log`;
CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dữ liệu mẫu cho bảng `django_admin_log` (6 bản ghi)
INSERT INTO `django_admin_log` (`id`, `action_time`, `object_id`, `object_repr`, `action_flag`, `change_message`, `content_type_id`, `user_id`) VALUES
(1, '2026-10-09 01:20:43.642718', '1', 'Sân PicklePro 3 (S03)', 1, '[{"added": {}}]', 7, 1),
(2, '2026-10-09 02:31:19.599341', '3', 'Huy132206', 2, '[{"changed": {"fields": ["Username"]}}]', 4, 1),
(3, '2026-10-09 02:31:40.039528', '3', 'Huy132206', 2, '[]', 4, 1),
(4, '2026-10-09 02:31:50.371659', '3', 'Huy132', 2, '[{"changed": {"fields": ["Username"]}}]', 4, 1),
(5, '2026-10-09 02:31:52.786716', '3', 'Huy132 (0948262522)', 2, '[]', 8, 1),
(6, '2026-10-09 02:32:54.171244', '4', 'Hin132', 1, '[{"added": {}}]', 4, 1);

-- --------------------------------------------------------
-- Cấu trúc bảng cho `django_content_type`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `django_content_type`;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dữ liệu mẫu cho bảng `django_content_type` (9 bản ghi)
INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(8, 'accounts', 'userprofile'),
(1, 'admin', 'logentry'),
(3, 'auth', 'group'),
(2, 'auth', 'permission'),
(4, 'auth', 'user'),
(9, 'bookings', 'booking'),
(5, 'contenttypes', 'contenttype'),
(7, 'courts', 'court'),
(6, 'sessions', 'session');

-- --------------------------------------------------------
-- Cấu trúc bảng cho `django_migrations`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `django_migrations`;
CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dữ liệu mẫu cho bảng `django_migrations` (22 bản ghi)
INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'contenttypes', '0001_initial', '2026-10-09 01:07:25.268115'),
(2, 'auth', '0001_initial', '2026-10-09 01:07:25.866609'),
(3, 'admin', '0001_initial', '2026-10-09 01:07:25.985102'),
(4, 'admin', '0002_logentry_remove_auto_add', '2026-10-09 01:07:25.985102'),
(5, 'admin', '0003_logentry_add_action_flag_choices', '2026-10-09 01:07:26.001581'),
(6, 'contenttypes', '0002_remove_content_type_name', '2026-10-09 01:07:26.065441'),
(7, 'auth', '0002_alter_permission_name_max_length', '2026-10-09 01:07:26.125449'),
(8, 'auth', '0003_alter_user_email_max_length', '2026-10-09 01:07:26.143869'),
(9, 'auth', '0004_alter_user_username_opts', '2026-10-09 01:07:26.152939'),
(10, 'auth', '0005_alter_user_last_login_null', '2026-10-09 01:07:26.190640'),
(11, 'auth', '0006_require_contenttypes_0002', '2026-10-09 01:07:26.193888'),
(12, 'auth', '0007_alter_validators_add_error_messages', '2026-10-09 01:07:26.206164'),
(13, 'auth', '0008_alter_user_username_max_length', '2026-10-09 01:07:26.224184'),
(14, 'auth', '0009_alter_user_last_name_max_length', '2026-10-09 01:07:26.238840'),
(15, 'auth', '0010_alter_group_name_max_length', '2026-10-09 01:07:26.253016'),
(16, 'auth', '0011_update_proxy_permissions', '2026-10-09 01:07:26.265518'),
(17, 'auth', '0012_alter_user_first_name_max_length', '2026-10-09 01:07:26.284531'),
(18, 'courts', '0001_initial', '2026-10-09 01:07:26.301118'),
(19, 'sessions', '0001_initial', '2026-10-09 01:07:26.335113'),
(20, 'accounts', '0001_initial', '2026-10-09 01:33:07.252887'),
(21, 'courts', '0002_court_court_type_court_features_court_image_url', '2026-10-09 01:33:07.316812'),
(22, 'bookings', '0001_initial', '2026-10-09 01:33:07.445206');

-- --------------------------------------------------------
-- Cấu trúc bảng cho `django_session`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `django_session`;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dữ liệu mẫu cho bảng `django_session` (3 bản ghi)
INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('2u6i9pv895yhptyn9vco6j6tch22nxdv', '.eJxVjEEOwiAQRe_C2pChUBhcuvcMZIBBqoYmpV0Z765NutDtf-_9lwi0rTVsnZcwZXEWSpx-t0jpwW0H-U7tNss0t3WZotwVedAur3Pm5-Vw_w4q9fqtB5dRl5hBW-2sy8UVhTSyJ8XFg0UEg6iTKQNDLCN4Y10iF1EDsLfi_QHYIzdf:1xEzyV:_eXWHBvqAiXVRNdseUgTyJb9n9FE5J1DyKdFLs6e4bo', '2026-10-23 02:04:43.623267'),
('hd6wvgcg5db0xitrra4zsm3174xt6zwa', '.eJxVjEEOwiAQRe_C2pChUBhcuvcMZIBBqoYmpV0Z765NutDtf-_9lwi0rTVsnZcwZXEWSpx-t0jpwW0H-U7tNss0t3WZotwVedAur3Pm5-Vw_w4q9fqtB5dRl5hBW-2sy8UVhTSyJ8XFg0UEg6iTKQNDLCN4Y10iF1EDsLfi_QHYIzdf:1xP8Du:4Dwocjtmzv8bfd7gV8BXDBMOe8jEnTBLLkOdOcJL4zQ', '2026-11-20 00:54:30.157256'),
('ncirdfpfqa9z8y2xpwlb6ekjvj0rsywj', '.eJxVjEEOwiAQRe_C2pChUBhcuvcMZIBBqoYmpV0Z765NutDtf-_9lwi0rTVsnZcwZXEWSpx-t0jpwW0H-U7tNss0t3WZotwVedAur3Pm5-Vw_w4q9fqtB5dRl5hBW-2sy8UVhTSyJ8XFg0UEg6iTKQNDLCN4Y10iF1EDsLfi_QHYIzdf:1xF03z:ZxEzPseyfI8egnxwelzJE0sMAmLsc70eGe-hnrQghh0', '2026-10-23 02:10:23.386886');

SET FOREIGN_KEY_CHECKS=1;

-- KẾT THÚC DUMP CƠ SỞ DỮ LIỆU PICKLEPRO --
