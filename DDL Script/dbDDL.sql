-- =====================================================
-- DATABASE: aak_academy
-- =====================================================

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS live_class;
DROP TABLE IF EXISTS announcement;
DROP TABLE IF EXISTS learning_material;
DROP TABLE IF EXISTS quiz_question;
DROP TABLE IF EXISTS quiz_attempt;
DROP TABLE IF EXISTS quiz;
DROP TABLE IF EXISTS assignment_submission;
DROP TABLE IF EXISTS assignment;
DROP TABLE IF EXISTS audit_log;
DROP TABLE IF EXISTS notification;
DROP TABLE IF EXISTS payment;
DROP TABLE IF EXISTS fee_record;
DROP TABLE IF EXISTS enrollment;
DROP TABLE IF EXISTS subject;
DROP TABLE IF EXISTS student;
DROP TABLE IF EXISTS teacher;
DROP TABLE IF EXISTS admin;
DROP TABLE IF EXISTS program;
DROP TABLE IF EXISTS `user`;

SET FOREIGN_KEY_CHECKS = 1;

-- =====================================================
-- TABLE 1: user
-- =====================================================
CREATE TABLE `user` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('admin','teacher','student') NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`)
);

-- =====================================================
-- TABLE 2: admin
-- =====================================================
CREATE TABLE `admin` (
  `admin_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `access_level` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`admin_id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `admin_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE
);

-- =====================================================
-- TABLE 3: teacher
-- =====================================================
CREATE TABLE `teacher` (
  `teacher_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `qualification` varchar(100) DEFAULT NULL,
  `experience_years` int DEFAULT NULL,
  `specialization` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`teacher_id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `teacher_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE
);

-- =====================================================
-- TABLE 4: program
-- =====================================================
CREATE TABLE `program` (
  `program_id` int NOT NULL AUTO_INCREMENT,
  `program_name` varchar(100) NOT NULL,
  `description` text,
  PRIMARY KEY (`program_id`)
);

-- =====================================================
-- TABLE 5: student
-- =====================================================
CREATE TABLE `student` (
  `student_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `dob` date DEFAULT NULL,
  `gender` enum('male','female','other') DEFAULT NULL,
  `program_id` int DEFAULT NULL,
  `enrollment_date` date DEFAULT NULL,
  `fee_status` enum('paid','unpaid','partial') DEFAULT 'unpaid',
  PRIMARY KEY (`student_id`),
  UNIQUE KEY `user_id` (`user_id`),
  FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE,
  FOREIGN KEY (`program_id`) REFERENCES `program` (`program_id`) ON DELETE SET NULL
);

-- =====================================================
-- TABLE 6: subject
-- =====================================================
CREATE TABLE `subject` (
  `subject_id` int NOT NULL AUTO_INCREMENT,
  `program_id` int DEFAULT NULL,
  `teacher_id` int DEFAULT NULL,
  `subject_name` varchar(100) NOT NULL,
  `credit_hours` int DEFAULT NULL,
  `fee` decimal(10,2) DEFAULT NULL,
  `prerequisite` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`subject_id`),
  FOREIGN KEY (`program_id`) REFERENCES `program` (`program_id`) ON DELETE SET NULL,
  FOREIGN KEY (`teacher_id`) REFERENCES `teacher` (`teacher_id`) ON DELETE SET NULL
);

-- =====================================================
-- TABLE 7: enrollment
-- =====================================================
CREATE TABLE `enrollment` (
  `enrollment_id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `subject_id` int NOT NULL,
  `enrollment_date` date NOT NULL,
  `discount_percentage` float DEFAULT '0',
  PRIMARY KEY (`enrollment_id`),
  FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`) ON DELETE CASCADE,
  FOREIGN KEY (`subject_id`) REFERENCES `subject` (`subject_id`) ON DELETE CASCADE
);

-- =====================================================
-- TABLE 8: fee_record
-- =====================================================
CREATE TABLE `fee_record` (
  `fee_id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `total_fee` decimal(10,2) NOT NULL,
  `discount_percentage` float DEFAULT '0',
  `amount_paid` decimal(10,2) DEFAULT '0.00',
  `remaining_balance` decimal(10,2) DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `payment_status` enum('paid','unpaid','partial') DEFAULT 'unpaid',
  PRIMARY KEY (`fee_id`),
  FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`) ON DELETE CASCADE
);

-- =====================================================
-- TABLE 9: payment
-- =====================================================
CREATE TABLE `payment` (
  `payment_id` int NOT NULL AUTO_INCREMENT,
  `fee_id` int NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_method` varchar(50) DEFAULT NULL,
  `payment_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`payment_id`),
  FOREIGN KEY (`fee_id`) REFERENCES `fee_record` (`fee_id`) ON DELETE CASCADE
);

-- =====================================================
-- TABLE 10: notification
-- =====================================================
CREATE TABLE `notification` (
  `notification_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `title` varchar(150) NOT NULL,
  `message` text,
  `notification_type` varchar(50) DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`notification_id`),
  FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE
);

-- =====================================================
-- TABLE 11: audit_log
-- =====================================================
CREATE TABLE `audit_log` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `ip_address` varchar(50) DEFAULT NULL,
  `old_value` text,
  `new_value` text,
  `timestamp` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`),
  FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE SET NULL
);

-- =====================================================
-- TABLE 12: assignment
-- =====================================================
CREATE TABLE `assignment` (
  `assignment_id` int NOT NULL AUTO_INCREMENT,
  `subject_id` int NOT NULL,
  `teacher_id` int NOT NULL,
  `title` varchar(150) NOT NULL,
  `instructions` text,
  `deadline` date DEFAULT NULL,
  `total_marks` int DEFAULT NULL,
  PRIMARY KEY (`assignment_id`),
  FOREIGN KEY (`subject_id`) REFERENCES `subject` (`subject_id`) ON DELETE CASCADE,
  FOREIGN KEY (`teacher_id`) REFERENCES `teacher` (`teacher_id`) ON DELETE CASCADE
);

-- =====================================================
-- TABLE 13: assignment_submission
-- =====================================================
CREATE TABLE `assignment_submission` (
  `submission_id` int NOT NULL AUTO_INCREMENT,
  `assignment_id` int NOT NULL,
  `student_id` int NOT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `submission_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `obtained_marks` int DEFAULT NULL,
  `feedback` text,
  PRIMARY KEY (`submission_id`),
  FOREIGN KEY (`assignment_id`) REFERENCES `assignment` (`assignment_id`) ON DELETE CASCADE,
  FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`) ON DELETE CASCADE
);

-- =====================================================
-- TABLE 14: quiz
-- =====================================================
CREATE TABLE `quiz` (
  `quiz_id` int NOT NULL AUTO_INCREMENT,
  `subject_id` int NOT NULL,
  `teacher_id` int NOT NULL,
  `title` varchar(150) NOT NULL,
  `total_marks` int DEFAULT NULL,
  `time_limit` int DEFAULT NULL,
  `quiz_date` date DEFAULT NULL,
  PRIMARY KEY (`quiz_id`),
  FOREIGN KEY (`subject_id`) REFERENCES `subject` (`subject_id`) ON DELETE CASCADE,
  FOREIGN KEY (`teacher_id`) REFERENCES `teacher` (`teacher_id`) ON DELETE CASCADE
);

-- =====================================================
-- TABLE 15: quiz_attempt
-- =====================================================
CREATE TABLE `quiz_attempt` (
  `attempt_id` int NOT NULL AUTO_INCREMENT,
  `quiz_id` int NOT NULL,
  `student_id` int NOT NULL,
  `score` decimal(5,2) DEFAULT NULL,
  `attempt_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`attempt_id`),
  FOREIGN KEY (`quiz_id`) REFERENCES `quiz` (`quiz_id`) ON DELETE CASCADE,
  FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`) ON DELETE CASCADE
);

-- =====================================================
-- TABLE 16: quiz_question
-- =====================================================
CREATE TABLE `quiz_question` (
  `question_id` int NOT NULL AUTO_INCREMENT,
  `quiz_id` int NOT NULL,
  `question_type` varchar(50) DEFAULT NULL,
  `question_text` text NOT NULL,
  `correct_answer` varchar(255) DEFAULT NULL,
  `marks` int DEFAULT NULL,
  PRIMARY KEY (`question_id`),
  FOREIGN KEY (`quiz_id`) REFERENCES `quiz` (`quiz_id`) ON DELETE CASCADE
);

-- =====================================================
-- TABLE 17: learning_material
-- =====================================================
CREATE TABLE `learning_material` (
  `material_id` int NOT NULL AUTO_INCREMENT,
  `subject_id` int NOT NULL,
  `teacher_id` int NOT NULL,
  `title` varchar(150) NOT NULL,
  `material_type` varchar(50) DEFAULT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `upload_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`material_id`),
  FOREIGN KEY (`subject_id`) REFERENCES `subject` (`subject_id`) ON DELETE CASCADE,
  FOREIGN KEY (`teacher_id`) REFERENCES `teacher` (`teacher_id`) ON DELETE CASCADE
);

-- =====================================================
-- TABLE 18: announcement
-- =====================================================
CREATE TABLE `announcement` (
  `announcement_id` int NOT NULL AUTO_INCREMENT,
  `teacher_id` int NOT NULL,
  `subject_id` int DEFAULT NULL,
  `title` varchar(150) NOT NULL,
  `content` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`announcement_id`),
  FOREIGN KEY (`teacher_id`) REFERENCES `teacher` (`teacher_id`) ON DELETE CASCADE,
  FOREIGN KEY (`subject_id`) REFERENCES `subject` (`subject_id`) ON DELETE SET NULL
);

-- =====================================================
-- TABLE 19: live_class
-- =====================================================
CREATE TABLE `live_class` (
  `class_id` int NOT NULL AUTO_INCREMENT,
  `subject_id` int NOT NULL,
  `teacher_id` int NOT NULL,
  `zoom_link` varchar(255) DEFAULT NULL,
  `class_date` date DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  PRIMARY KEY (`class_id`),
  FOREIGN KEY (`subject_id`) REFERENCES `subject` (`subject_id`) ON DELETE CASCADE,
  FOREIGN KEY (`teacher_id`) REFERENCES `teacher` (`teacher_id`) ON DELETE CASCADE
);

-- =====================================================
-- TABLE 20: attendance
-- =====================================================
CREATE TABLE `attendance` (
  `attendance_id` int NOT NULL AUTO_INCREMENT,
  `class_id` int NOT NULL,
  `student_id` int NOT NULL,
  `status` enum('present','absent','late') DEFAULT NULL,
  `join_time` datetime DEFAULT NULL,
  PRIMARY KEY (`attendance_id`),
  FOREIGN KEY (`class_id`) REFERENCES `live_class` (`class_id`) ON DELETE CASCADE,
  FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`) ON DELETE CASCADE
);

-- =====================================================
-- INDEXES for Performance
-- =====================================================
CREATE INDEX idx_user_email ON `user`(email);
CREATE INDEX idx_student_program ON student(program_id);
CREATE INDEX idx_subject_program ON subject(program_id);
CREATE INDEX idx_subject_teacher ON subject(teacher_id);
CREATE INDEX idx_enrollment_student ON enrollment(student_id);
CREATE INDEX idx_enrollment_subject ON enrollment(subject_id);
CREATE INDEX idx_fee_student ON fee_record(student_id);
CREATE INDEX idx_payment_fee ON payment(fee_id);
CREATE INDEX idx_attendance_class ON attendance(class_id);
CREATE INDEX idx_attendance_student ON attendance(student_id);

-- =====================================================
-- DONE
-- =====================================================