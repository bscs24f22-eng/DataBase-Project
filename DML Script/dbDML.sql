-- =====================================================
-- DATABASE: aak_academy
-- DML SCRIPT 
-- =====================================================

-- =====================================================
-- 1. USER Table (49 rows)
-- =====================================================
INSERT INTO user (user_id, full_name, email, password_hash, role, phone, status, created_at) VALUES
(1, 'Admin Khan', 'admin@aak.edu', 'hashed_pass_1', 'admin', '0300-1111111', 'active', '2026-06-10 16:54:01'),
(2, 'Dr. Ali Hassan', 'ali@aak.edu', 'hashed_pass_2', 'teacher', '0301-2222222', 'active', '2026-06-10 16:54:01'),
(3, 'Ms. Sara Noor', 'sara@aak.edu', 'hashed_pass_3', 'teacher', '0302-3333333', 'active', '2026-06-10 16:54:01'),
(4, 'Ahmed Raza', 'ahmed@student.aak', 'hashed_pass_4', 'student', '0303-4444444', 'active', '2026-06-10 16:54:01'),
(5, 'Fatima Malik', 'fatima@student.aak', 'hashed_pass_5', 'student', '0304-5555555', 'active', '2026-06-10 16:54:01'),
(6, 'Usman Tariq', 'usman@student.aak', 'hashed_pass_6', 'student', '0305-6666666', 'active', '2026-06-10 16:54:01'),
(7, 'Ayesha Zafar', 'ayesha@student.aak', 'hashed_pass_7', 'student', '0306-7777777', 'active', '2026-06-10 16:54:01'),
(8, 'Dr. Bilal Shah', 'bilal@aak.edu', 'hashed_pass_8', 'teacher', '0307-8888888', 'active', '2026-06-10 16:54:01'),
(9, 'Admin AAK', 'admin@aakacademy.pk', 'hash_admin', 'admin', '03000000000', 'active', '2026-06-10 19:32:42'),
(10, 'Dr. Ali Hassan', 'ali.hassan@aakacademy.pk', 'hash_t1', 'teacher', '03010000001', 'active', '2026-06-10 19:32:42'),
(11, 'Dr. Sara Noor', 'sara.noor@aakacademy.pk', 'hash_t2', 'teacher', '03010000002', 'active', '2026-06-10 19:32:42'),
(12, 'Prof. Bilal Ahmed', 'bilal.ahmed@aakacademy.pk', 'hash_t3', 'teacher', '03010000003', 'active', '2026-06-10 19:32:42'),
(13, 'Prof. Hina Tariq', 'hina.tariq@aakacademy.pk', 'hash_t4', 'teacher', '03010000004', 'active', '2026-06-10 19:32:42'),
(14, 'Dr. Usman Raza', 'usman.raza@aakacademy.pk', 'hash_t5', 'teacher', '03010000005', 'active', '2026-06-10 19:32:42'),
(15, 'Dr. Ayesha Khan', 'ayesha.khan@aakacademy.pk', 'hash_t6', 'teacher', '03010000006', 'active', '2026-06-10 19:32:42'),
(16, 'Prof. Zain Ali', 'zain.ali@aakacademy.pk', 'hash_t7', 'teacher', '03010000007', 'active', '2026-06-10 19:32:42'),
(17, 'Prof. Maryam Asif', 'maryam.asif@aakacademy.pk', 'hash_t8', 'teacher', '03010000008', 'active', '2026-06-10 19:32:42'),
(18, 'Dr. Fahad Iqbal', 'fahad.iqbal@aakacademy.pk', 'hash_t9', 'teacher', '03010000009', 'active', '2026-06-10 19:32:42'),
(19, 'Dr. Komal Yousaf', 'komal.yousaf@aakacademy.pk', 'hash_t10', 'teacher', '03010000010', 'active', '2026-06-10 19:32:42'),
(20, 'Prof. Hamza Malik', 'hamza.malik@aakacademy.pk', 'hash_t11', 'teacher', '03010000011', 'active', '2026-06-10 19:32:42'),
(21, 'Dr. Rabia Javed', 'rabia.javed@aakacademy.pk', 'hash_t12', 'teacher', '03010000012', 'active', '2026-06-10 19:32:42'),
(22, 'Prof. Danish Khan', 'danish.khan@aakacademy.pk', 'hash_t13', 'teacher', '03010000013', 'active', '2026-06-10 19:32:42'),
(23, 'Dr. Mehwish Ali', 'mehwish.ali@aakacademy.pk', 'hash_t14', 'teacher', '03010000014', 'active', '2026-06-10 19:32:42'),
(24, 'Prof. Hassan Shah', 'hassan.shah@aakacademy.pk', 'hash_t15', 'teacher', '03010000015', 'active', '2026-06-10 19:32:42'),
(25, 'Dr. Sana Akram', 'sana.akram@aakacademy.pk', 'hash_t16', 'teacher', '03010000016', 'active', '2026-06-10 19:32:42'),
(26, 'Prof. Imran Siddiqui', 'imran.siddiqui@aakacademy.pk', 'hash_t17', 'teacher', '03010000017', 'active', '2026-06-10 19:32:42'),
(27, 'Dr. Laiba Noor', 'laiba.noor@aakacademy.pk', 'hash_t18', 'teacher', '03010000018', 'active', '2026-06-10 19:32:42'),
(28, 'Prof. Talha Waheed', 'talha.waheed@aakacademy.pk', 'hash_t19', 'teacher', '03010000019', 'active', '2026-06-10 19:32:42'),
(29, 'Dr. Nimra Ilyas', 'nimra.ilyas@aakacademy.pk', 'hash_t20', 'teacher', '03010000020', 'active', '2026-06-10 19:32:42'),
(30, 'Ahmed Raza', 'ahmed.raza@student.aakacademy.pk', 'hash_s1', 'student', '03110000001', 'active', '2026-06-10 19:32:42'),
(31, 'Fatima Malik', 'fatima.malik@student.aakacademy.pk', 'hash_s2', 'student', '03110000002', 'active', '2026-06-10 19:32:42'),
(32, 'Usman Tariq', 'usman.tariq@student.aakacademy.pk', 'hash_s3', 'student', '03110000003', 'active', '2026-06-10 19:32:42'),
(33, 'Ayesha Zafar', 'ayesha.zafar@student.aakacademy.pk', 'hash_s4', 'student', '03110000004', 'active', '2026-06-10 19:32:42'),
(34, 'Hamza Khalid', 'hamza.khalid@student.aakacademy.pk', 'hash_s5', 'student', '03110000005', 'active', '2026-06-10 19:32:42'),
(35, 'Iqra Jamil', 'iqra.jamil@student.aakacademy.pk', 'hash_s6', 'student', '03110000006', 'active', '2026-06-10 19:32:42'),
(36, 'Abdullah Khan', 'abdullah.khan@student.aakacademy.pk', 'hash_s7', 'student', '03110000007', 'active', '2026-06-10 19:32:42'),
(37, 'Maham Noor', 'maham.noor@student.aakacademy.pk', 'hash_s8', 'student', '03110000008', 'active', '2026-06-10 19:32:42'),
(38, 'Saad Ali', 'saad.ali@student.aakacademy.pk', 'hash_s9', 'student', '03110000009', 'active', '2026-06-10 19:32:42'),
(39, 'Noor Fatima', 'noor.fatima@student.aakacademy.pk', 'hash_s10', 'student', '03110000010', 'active', '2026-06-10 19:32:42'),
(40, 'Huzaifa Ahmed', 'huzaifa.ahmed@student.aakacademy.pk', 'hash_s11', 'student', '03110000011', 'active', '2026-06-10 19:32:42'),
(41, 'Zoya Ashraf', 'zoya.ashraf@student.aakacademy.pk', 'hash_s12', 'student', '03110000012', 'active', '2026-06-10 19:32:42'),
(42, 'Muneeb Shah', 'muneeb.shah@student.aakacademy.pk', 'hash_s13', 'student', '03110000013', 'active', '2026-06-10 19:32:42'),
(43, 'Anaya Siddiqui', 'anaya.siddiqui@student.aakacademy.pk', 'hash_s14', 'student', '03110000014', 'active', '2026-06-10 19:32:42'),
(44, 'Rayan Iqbal', 'rayan.iqbal@student.aakacademy.pk', 'hash_s15', 'student', '03110000015', 'active', '2026-06-10 19:32:42'),
(45, 'Hira Sohail', 'hira.sohail@student.aakacademy.pk', 'hash_s16', 'student', '03110000016', 'active', '2026-06-10 19:32:42'),
(46, 'Taha Yousuf', 'taha.yousuf@student.aakacademy.pk', 'hash_s17', 'student', '03110000017', 'active', '2026-06-10 19:32:42'),
(47, 'Alina Rauf', 'alina.rauf@student.aakacademy.pk', 'hash_s18', 'student', '03110000018', 'active', '2026-06-10 19:32:42'),
(48, 'Mustafa Qureshi', 'mustafa.qureshi@student.aakacademy.pk', 'hash_s19', 'student', '03110000019', 'active', '2026-06-10 19:32:42'),
(49, 'Eman Khalil', 'eman.khalil@student.aakacademy.pk', 'hash_s20', 'student', '03110000020', 'active', '2026-06-10 19:32:42');

-- =====================================================
-- 2. ADMIN Table (2 rows)
-- =====================================================
INSERT INTO admin (admin_id, user_id, access_level) VALUES
(1, 1, 'full'),
(2, 9, 'full');

-- =====================================================
-- 3. TEACHER Table (23 rows)
-- =====================================================
INSERT INTO teacher (teacher_id, user_id, qualification, experience_years, specialization) VALUES
(1, 2, 'PhD Computer Science', 10, 'Database Systems'),
(2, 3, 'MS Software Engineering', 5, 'Web Development'),
(3, 8, 'PhD Mathematics', 8, 'Calculus and Linear Algebra'),
(4, 10, 'PhD Computer Science', 12, 'Database Systems'),
(5, 11, 'MS Software Engineering', 7, 'Web Development'),
(6, 12, 'PhD Information Technology', 10, 'Artificial Intelligence'),
(7, 13, 'MS Computer Science', 5, 'Cyber Security'),
(8, 14, 'PhD Software Engineering', 15, 'Software Engineering'),
(9, 15, 'MS Information Technology', 6, 'Cloud Computing'),
(10, 16, 'PhD Computer Science', 11, 'Machine Learning'),
(11, 17, 'MS Mathematics', 8, 'Discrete Mathematics'),
(12, 18, 'PhD Data Science', 9, 'Data Analytics'),
(13, 19, 'MS Computer Networks', 7, 'Computer Networks'),
(14, 20, 'PhD Information Systems', 13, 'Information Systems'),
(15, 21, 'MS Artificial Intelligence', 5, 'Deep Learning'),
(16, 22, 'PhD Computer Engineering', 14, 'Operating Systems'),
(17, 23, 'MS Software Engineering', 6, 'Mobile Application Development'),
(18, 24, 'PhD Mathematics', 16, 'Calculus'),
(19, 25, 'MS Computer Science', 8, 'Object Oriented Programming'),
(20, 26, 'PhD Cyber Security', 12, 'Network Security'),
(21, 27, 'MS Data Science', 5, 'Big Data'),
(22, 28, 'PhD Software Engineering', 10, 'Software Project Management'),
(23, 29, 'MS Information Technology', 7, 'Database Administration');

-- =====================================================
-- 4. PROGRAM Table (24 rows)
-- =====================================================
INSERT INTO program (program_id, program_name, description) VALUES
(1, 'BSCS', 'Bachelor of Science in Computer Science'),
(2, 'BSSE', 'Bachelor of Science in Software Engineering'),
(3, 'BSIT', 'Bachelor of Science in Information Technology'),
(4, 'Short Courses', 'Short professional development courses'),
(5, 'BS Computer Science', '4 year undergraduate degree in Computer Science'),
(6, 'BS Software Engineering', '4 year undergraduate degree in Software Engineering'),
(7, 'BS Information Technology', '4 year undergraduate degree in Information Technology'),
(8, 'BS Artificial Intelligence', '4 year undergraduate degree in AI'),
(9, 'BS Data Science', '4 year undergraduate degree in Data Science'),
(10, 'ADP Computer Science', '2 year Associate Degree Program'),
(11, 'Diploma in Web Development', 'Professional Web Development Diploma'),
(12, 'Diploma in Graphic Design', 'Professional Graphic Designing Diploma'),
(13, 'Diploma in Digital Marketing', 'Digital Marketing Certification'),
(14, 'Short Course Python', '3 month Python Programming Course'),
(15, 'Short Course Java', '3 month Java Programming Course'),
(16, 'Short Course C++', '3 month C++ Programming Course'),
(17, 'Short Course Flutter', 'Flutter Mobile Development'),
(18, 'Short Course React', 'React JS Development'),
(19, 'Short Course SQL', 'Database and SQL Course'),
(20, 'Short Course UI/UX', 'UI UX Designing'),
(21, 'Short Course Networking', 'CCNA Basics'),
(22, 'Short Course Cyber Security', 'Cyber Security Fundamentals'),
(23, 'Short Course AI', 'Introduction to Artificial Intelligence'),
(24, 'Short Course Data Analytics', 'Power BI and Excel Analytics');

-- =====================================================
-- 5. STUDENT Table (24 rows)
-- =====================================================
INSERT INTO student (student_id, user_id, dob, gender, program_id, enrollment_date, fee_status) VALUES
(1, 4, '2002-05-15', 'male', 1, '2023-09-01', 'paid'),
(2, 5, '2003-03-22', 'female', 1, '2023-09-01', 'partial'),
(3, 6, '2002-11-10', 'male', 2, '2023-09-01', 'paid'),
(4, 7, '2004-07-08', 'female', 3, '2024-02-01', 'unpaid'),
(5, 42, '2002-05-15', 'male', 1, '2024-01-15', 'paid'),
(6, 43, '2003-02-10', 'female', 2, '2024-01-15', 'partial'),
(7, 44, '2001-11-18', 'male', 3, '2024-01-15', 'paid'),
(8, 45, '2002-08-22', 'female', 4, '2024-01-15', 'unpaid'),
(9, 46, '2003-03-05', 'male', 5, '2024-01-15', 'paid'),
(10, 47, '2002-07-19', 'female', 1, '2024-01-15', 'partial'),
(11, 48, '2004-01-11', 'male', 2, '2024-01-15', 'paid'),
(12, 49, '2003-09-09', 'female', 3, '2024-01-15', 'paid'),
(13, 30, '2002-10-30', 'male', 4, '2024-01-15', 'unpaid'),
(14, 31, '2001-12-14', 'female', 5, '2024-01-15', 'partial'),
(15, 32, '2003-04-25', 'male', 6, '2024-01-15', 'paid'),
(16, 33, '2002-06-16', 'female', 7, '2024-01-15', 'paid'),
(17, 34, '2001-08-12', 'male', 8, '2024-01-15', 'partial'),
(18, 35, '2002-09-27', 'female', 9, '2024-01-15', 'paid'),
(19, 36, '2003-05-21', 'male', 10, '2024-01-15', 'unpaid'),
(20, 37, '2002-11-03', 'female', 11, '2024-01-15', 'paid'),
(21, 38, '2001-02-17', 'male', 12, '2024-01-15', 'partial'),
(22, 39, '2003-07-08', 'female', 13, '2024-01-15', 'paid'),
(23, 40, '2002-01-29', 'male', 14, '2024-01-15', 'paid'),
(24, 41, '2004-04-13', 'female', 15, '2024-01-15', 'unpaid');

-- =====================================================
-- 6. SUBJECT Table (20 rows)
-- =====================================================
INSERT INTO subject (subject_id, program_id, teacher_id, subject_name, credit_hours, fee, prerequisite) VALUES
(1, 1, 1, 'Database Systems', 3, 5000.00, NULL),
(2, 1, 1, 'Data Structures', 3, 5000.00, NULL),
(3, 1, 2, 'Web Engineering', 3, 4500.00, NULL),
(4, 2, 2, 'Software Design', 3, 4500.00, NULL),
(5, 3, 3, 'Calculus I', 3, 4000.00, NULL),
(6, 1, 3, 'Discrete Mathematics', 3, 4000.00, NULL),
(7, 1, 4, 'Operating Systems', 3, 5000.00, 'Data Structures'),
(8, 1, 5, 'Computer Networks', 3, 4800.00, NULL),
(9, 1, 6, 'Artificial Intelligence', 3, 5500.00, 'Database Systems'),
(10, 1, 7, 'Machine Learning', 3, 6000.00, 'Artificial Intelligence'),
(11, 2, 8, 'Software Testing', 3, 4500.00, NULL),
(12, 2, 9, 'Requirements Engineering', 3, 4700.00, NULL),
(13, 2, 10, 'Agile Development', 3, 4300.00, NULL),
(14, 2, 11, 'Mobile App Development', 3, 5200.00, 'Web Engineering'),
(15, 3, 12, 'Network Security', 3, 5000.00, NULL),
(16, 3, 13, 'Cloud Computing', 3, 5400.00, NULL),
(17, 3, 14, 'Data Analytics', 3, 5600.00, NULL),
(18, 3, 15, 'Business Intelligence', 3, 5000.00, NULL),
(19, 1, 16, 'Compiler Construction', 3, 5800.00, 'Data Structures'),
(20, 1, 17, 'Computer Graphics', 3, 4900.00, NULL);

-- =====================================================
-- 7. ENROLLMENT Table (28 rows)
-- =====================================================
INSERT INTO enrollment (enrollment_id, student_id, subject_id, enrollment_date, discount_percentage) VALUES
(1, 1, 1, '2023-09-05', 0),
(2, 1, 2, '2023-09-05', 0),
(3, 1, 3, '2023-09-05', 10),
(4, 2, 1, '2023-09-05', 5),
(5, 2, 3, '2023-09-05', 0),
(6, 3, 4, '2023-09-05', 0),
(7, 4, 5, '2024-02-05', 0),
(8, 4, 6, '2024-02-05', 0),
(9, 5, 7, '2024-02-01', 0),
(10, 6, 8, '2024-02-01', 5),
(11, 7, 9, '2024-02-01', 10),
(12, 8, 10, '2024-02-01', 0),
(13, 9, 11, '2024-02-01', 0),
(14, 10, 12, '2024-02-01', 15),
(15, 11, 13, '2024-02-01', 0),
(16, 12, 14, '2024-02-01', 5),
(17, 13, 15, '2024-02-01', 0),
(18, 14, 16, '2024-02-01', 0),
(19, 15, 17, '2024-02-01', 10),
(20, 16, 18, '2024-02-01', 0),
(21, 17, 19, '2024-02-01', 0),
(22, 18, 20, '2024-02-01', 5),
(23, 19, 7, '2024-02-01', 0),
(24, 20, 8, '2024-02-01', 0),
(25, 21, 9, '2024-02-01', 10),
(26, 22, 10, '2024-02-01', 0),
(27, 23, 11, '2024-02-01', 0),
(28, 24, 12, '2024-02-01', 5);

-- =====================================================
-- 8. FEE_RECORD Table (24 rows)
-- =====================================================
INSERT INTO fee_record (fee_id, student_id, total_fee, discount_percentage, amount_paid, remaining_balance, due_date, payment_status) VALUES
(1, 1, 14500.00, 5, 14500.00, 0.00, '2023-10-01', 'paid'),
(2, 2, 9500.00, 0, 5000.00, 4500.00, '2023-10-01', 'partial'),
(3, 3, 4500.00, 0, 4500.00, 0.00, '2023-10-01', 'paid'),
(4, 4, 8000.00, 0, 0.00, 8000.00, '2024-03-01', 'unpaid'),
(5, 5, 5000.00, 0, 5000.00, 0.00, '2024-03-01', 'paid'),
(6, 6, 4800.00, 5, 3000.00, 1800.00, '2024-03-01', 'partial'),
(7, 7, 5500.00, 10, 5500.00, 0.00, '2024-03-01', 'paid'),
(8, 8, 6000.00, 0, 0.00, 6000.00, '2024-03-01', 'unpaid'),
(9, 9, 4500.00, 0, 4500.00, 0.00, '2024-03-01', 'paid'),
(10, 10, 4700.00, 15, 3000.00, 1700.00, '2024-03-01', 'partial'),
(11, 11, 4300.00, 0, 4300.00, 0.00, '2024-03-01', 'paid'),
(12, 12, 5200.00, 5, 5200.00, 0.00, '2024-03-01', 'paid'),
(13, 13, 5000.00, 0, 2500.00, 2500.00, '2024-03-01', 'partial'),
(14, 14, 5400.00, 0, 0.00, 5400.00, '2024-03-01', 'unpaid'),
(15, 15, 5600.00, 10, 5600.00, 0.00, '2024-03-01', 'paid'),
(16, 16, 5000.00, 0, 5000.00, 0.00, '2024-03-01', 'paid'),
(17, 17, 5800.00, 0, 3000.00, 2800.00, '2024-03-01', 'partial'),
(18, 18, 4900.00, 5, 4900.00, 0.00, '2024-03-01', 'paid'),
(19, 19, 5000.00, 0, 0.00, 5000.00, '2024-03-01', 'unpaid'),
(20, 20, 4800.00, 0, 4800.00, 0.00, '2024-03-01', 'paid'),
(21, 21, 5500.00, 10, 3000.00, 2500.00, '2024-03-01', 'partial'),
(22, 22, 6000.00, 0, 6000.00, 0.00, '2024-03-01', 'paid'),
(23, 23, 4500.00, 0, 0.00, 4500.00, '2024-03-01', 'unpaid'),
(24, 24, 4700.00, 5, 4700.00, 0.00, '2024-03-01', 'paid');

-- =====================================================
-- 9. PAYMENT Table (21 rows)
-- =====================================================
INSERT INTO payment (payment_id, fee_id, amount, payment_method, payment_date) VALUES
(1, 1, 14500.00, 'bank_transfer', '2023-09-15 10:00:00'),
(2, 2, 5000.00, 'cash', '2023-09-20 11:30:00'),
(3, 3, 4500.00, 'online', '2023-09-18 09:00:00'),
(4, 5, 5000.00, 'online', '2024-02-15 09:00:00'),
(5, 6, 3000.00, 'cash', '2024-02-16 10:15:00'),
(6, 7, 5500.00, 'bank_transfer', '2024-02-17 11:00:00'),
(7, 9, 4500.00, 'online', '2024-02-18 09:30:00'),
(8, 10, 3000.00, 'cash', '2024-02-18 12:00:00'),
(9, 11, 4300.00, 'bank_transfer', '2024-02-19 10:00:00'),
(10, 12, 5200.00, 'online', '2024-02-19 11:00:00'),
(11, 13, 2500.00, 'cash', '2024-02-20 09:15:00'),
(12, 15, 5600.00, 'bank_transfer', '2024-02-20 14:00:00'),
(13, 16, 5000.00, 'online', '2024-02-21 10:00:00'),
(14, 17, 3000.00, 'cash', '2024-02-21 11:00:00'),
(15, 18, 4900.00, 'online', '2024-02-22 08:30:00'),
(16, 20, 4800.00, 'bank_transfer', '2024-02-23 09:45:00'),
(17, 21, 3000.00, 'cash', '2024-02-24 13:15:00'),
(18, 22, 6000.00, 'online', '2024-02-24 15:30:00'),
(19, 24, 4700.00, 'bank_transfer', '2024-02-25 10:20:00'),
(20, 1, 5000.00, 'Bank Transfer', '2026-06-10 21:02:31'),
(21, 24, 5000.00, 'Bank Transfer', '2026-06-10 21:04:26');

-- =====================================================
-- 10. NOTIFICATION Table (20 rows)
-- =====================================================
INSERT INTO notification (notification_id, user_id, title, message, notification_type, is_read, created_at) VALUES
(1, 4, 'Assignment Posted', 'New assignment posted in Database Systems.', 'assignment', 0, '2023-10-01 09:05:00'),
(2, 5, 'Assignment Posted', 'New assignment posted in Database Systems.', 'assignment', 0, '2023-10-01 09:05:00'),
(3, 4, 'Quiz Reminder', 'DB Quiz 1 is tomorrow at 10 AM.', 'quiz', 1, '2023-10-04 08:00:00'),
(4, 4, 'Fee Cleared', 'Your fee balance is cleared.', 'fee', 1, '2023-09-16 10:00:00'),
(5, 5, 'Fee Reminder', 'You have a pending fee of Rs. 4500.', 'fee', 0, '2023-10-01 08:00:00'),
(6, 7, 'Fee Due', 'Your fee of Rs. 8000 is due on 1st March 2024.', 'fee', 0, '2024-02-15 08:00:00'),
(7, 30, 'OS Assignment', 'New assignment uploaded.', 'assignment', 0, '2024-03-01 08:10:00'),
(8, 31, 'Network Quiz', 'Quiz tomorrow.', 'quiz', 1, '2024-03-02 09:10:00'),
(9, 32, 'AI Project', 'Project deadline announced.', 'assignment', 0, '2024-03-03 10:10:00'),
(10, 33, 'ML Lecture', 'Lecture link available.', 'class', 1, '2024-03-04 09:40:00'),
(11, 34, 'Testing Lab', 'Attend lab session.', 'class', 0, '2024-03-05 08:40:00'),
(12, 35, 'SRS Reminder', 'Submit SRS before due date.', 'assignment', 0, '2024-03-06 09:20:00'),
(13, 36, 'Workshop', 'Agile workshop registration open.', 'announcement', 1, '2024-03-07 10:10:00'),
(14, 37, 'Android Viva', 'Check viva schedule.', 'announcement', 0, '2024-03-08 09:10:00'),
(15, 38, 'Security Seminar', 'Join seminar session.', 'announcement', 1, '2024-03-09 08:50:00'),
(16, 39, 'Cloud Lab', 'Cloud lab link updated.', 'class', 0, '2024-03-10 09:05:00'),
(17, 40, 'Analytics Assignment', 'Assignment uploaded.', 'assignment', 1, '2024-03-11 10:35:00'),
(18, 41, 'BI Presentation', 'Presentation schedule available.', 'announcement', 0, '2024-03-12 09:20:00'),
(19, 42, 'Compiler Quiz', 'Quiz postponed.', 'quiz', 1, '2024-03-13 08:05:00'),
(20, 43, 'Graphics Project', 'Final project uploaded.', 'assignment', 0, '2024-03-14 09:35:00');

-- =====================================================
-- 11. AUDIT_LOG Table (20 rows)
-- =====================================================
INSERT INTO audit_log (log_id, user_id, action, ip_address, old_value, new_value, timestamp) VALUES
(1, 1, 'INSERT student', '192.168.1.10', NULL, 'Student Ahmed Raza added', '2023-09-01 09:00:00'),
(2, 1, 'INSERT student', '192.168.1.10', NULL, 'Student Fatima Malik added', '2023-09-01 09:05:00'),
(3, 1, 'UPDATE fee_status', '192.168.1.10', 'unpaid', 'paid', '2023-09-15 10:30:00'),
(4, 2, 'INSERT assignment', '192.168.1.20', NULL, 'Assignment ER Diagram Design', '2023-10-01 09:00:00'),
(5, 2, 'INSERT quiz', '192.168.1.20', NULL, 'Quiz DB Quiz 1 Basics', '2023-09-25 11:00:00'),
(6, 1, 'DELETE enrollment', '192.168.1.10', 'enrollment_id=5', NULL, '2023-09-30 14:00:00'),
(7, 1, 'INSERT subject', '192.168.1.100', NULL, 'Operating Systems Added', '2024-03-01 08:00:00'),
(8, 4, 'CREATE assignment', '192.168.1.101', NULL, 'OS Assignment Created', '2024-03-01 09:00:00'),
(9, 5, 'CREATE quiz', '192.168.1.102', NULL, 'Networks Quiz Created', '2024-03-02 09:30:00'),
(10, 6, 'UPDATE assignment', '192.168.1.103', 'Old Deadline', 'New Deadline', '2024-03-03 10:00:00'),
(11, 7, 'UPLOAD material', '192.168.1.104', NULL, 'ML Lecture Uploaded', '2024-03-04 11:00:00'),
(12, 8, 'CREATE live class', '192.168.1.105', NULL, 'Testing Live Class', '2024-03-05 08:00:00'),
(13, 9, 'UPDATE announcement', '192.168.1.106', 'Draft', 'Published', '2024-03-06 09:00:00'),
(14, 10, 'INSERT notification', '192.168.1.107', NULL, 'Workshop Notification', '2024-03-07 10:00:00'),
(15, 11, 'UPDATE quiz', '192.168.1.108', '20 Marks', '25 Marks', '2024-03-08 11:30:00'),
(16, 12, 'DELETE material', '192.168.1.109', 'Old PDF', NULL, '2024-03-09 09:00:00'),
(17, 13, 'UPDATE fee', '192.168.1.110', 'Partial', 'Paid', '2024-03-10 10:15:00'),
(18, 14, 'INSERT attendance', '192.168.1.111', NULL, 'Attendance Marked', '2024-03-11 09:00:00'),
(19, 15, 'CREATE announcement', '192.168.1.112', NULL, 'BI Presentation Notice', '2024-03-12 10:00:00'),
(20, 16, 'UPDATE quiz date', '192.168.1.113', '2024-03-13', '2024-03-14', '2024-03-13 08:30:00');

-- =====================================================
-- 12. ASSIGNMENT Table (22 rows)
-- =====================================================
INSERT INTO assignment (assignment_id, subject_id, teacher_id, title, instructions, deadline, total_marks) VALUES
(1, 1, 1, 'ER Diagram Design', 'Design ERD for a library system.', '2023-10-15', 20),
(2, 1, 1, 'Normalization Exercise', 'Normalize given tables to 3NF.', '2023-11-01', 25),
(3, 2, 1, 'Linked List Implementation', 'Implement singly linked list in C++.', '2023-10-20', 30),
(4, 3, 2, 'HTML CSS Portfolio', 'Create a personal portfolio website.', '2023-10-25', 30),
(5, 7, 4, 'OS Process Management', 'Solve process scheduling problems.', '2024-03-10', 20),
(6, 8, 5, 'Network Topology Report', 'Prepare topology report.', '2024-03-12', 25),
(7, 9, 6, 'AI Expert System', 'Develop a simple expert system.', '2024-03-15', 30),
(8, 10, 7, 'ML Classification', 'Build a classification model.', '2024-03-18', 30),
(9, 11, 8, 'Testing Techniques', 'Document testing methods.', '2024-03-20', 20),
(10, 12, 9, 'Requirement Analysis', 'Prepare SRS document.', '2024-03-22', 25),
(11, 13, 10, 'Agile Sprint Plan', 'Design sprint backlog.', '2024-03-24', 20),
(12, 14, 11, 'Android UI', 'Create mobile UI screens.', '2024-03-26', 30),
(13, 15, 12, 'Security Policy', 'Write security policy.', '2024-03-28', 20),
(14, 16, 13, 'Cloud Deployment', 'Deploy sample application.', '2024-03-30', 30),
(15, 17, 14, 'Data Dashboard', 'Build analytics dashboard.', '2024-04-02', 30),
(16, 18, 15, 'BI Report', 'Prepare BI report.', '2024-04-04', 25),
(17, 19, 16, 'Compiler Phases', 'Explain compiler phases.', '2024-04-06', 20),
(18, 20, 17, 'Graphics Project', 'Draw 2D transformation demo.', '2024-04-08', 30),
(19, 1, 1, 'Database Optimization', 'Optimize queries and indexing', '2025-12-15', 100),
(20, 2, 2, 'Advanced Java Project', 'Build a mini management system', '2025-12-20', 100),
(21, 1, 1, 'Database Optimization Project', 'Optimize database queries and indexing', '2025-12-15', 100),
(22, 2, 2, 'Advanced Java Project', 'Build a mini management system', '2025-12-20', 100);

-- =====================================================
-- 13. ASSIGNMENT_SUBMISSION Table (21 rows)
-- =====================================================
INSERT INTO assignment_submission (submission_id, assignment_id, student_id, file_path, submission_date, obtained_marks, feedback) VALUES
(1, 1, 1, '/uploads/ahmed_erd.pdf', '2023-10-14 18:00:00', 18, 'Good work, minor cardinality issues.'),
(2, 1, 2, '/uploads/fatima_erd.pdf', '2023-10-15 10:00:00', 20, 'Excellent ERD design!'),
(3, 2, 1, '/uploads/ahmed_norm.pdf', '2023-10-31 20:00:00', 22, 'Missing BCNF explanation.'),
(4, 3, 1, '/uploads/ahmed_ll.cpp', '2023-10-19 17:00:00', 28, 'Well implemented.'),
(5, 4, 1, '/uploads/ahmed_port/', '2023-10-24 23:00:00', 25, 'Creative design.'),
(6, 5, 5, '/uploads/os_1.pdf', '2024-03-09 15:00:00', 18, 'Good work'),
(7, 6, 6, '/uploads/network.pdf', '2024-03-11 16:00:00', 22, 'Well done'),
(8, 7, 7, '/uploads/ai.zip', '2024-03-14 14:30:00', 27, 'Excellent'),
(9, 8, 8, '/uploads/ml.zip', '2024-03-17 17:20:00', 26, 'Nice effort'),
(10, 9, 9, '/uploads/testing.pdf', '2024-03-19 13:00:00', 19, 'Good'),
(11, 10, 10, '/uploads/srs.pdf', '2024-03-21 10:15:00', 23, 'Very good'),
(12, 11, 11, '/uploads/agile.pdf', '2024-03-23 11:00:00', 18, 'Needs improvement'),
(13, 12, 12, '/uploads/android.zip', '2024-03-25 18:00:00', 29, 'Excellent UI'),
(14, 13, 13, '/uploads/security.pdf', '2024-03-27 12:30:00', 20, 'Good'),
(15, 14, 14, '/uploads/cloud.zip', '2024-03-29 15:00:00', 28, 'Very nice'),
(16, 15, 15, '/uploads/dashboard.pbix', '2024-04-01 14:00:00', 29, 'Outstanding'),
(17, 16, 16, '/uploads/bi.pdf', '2024-04-03 10:30:00', 23, 'Good analysis'),
(18, 17, 17, '/uploads/compiler.pdf', '2024-04-05 16:00:00', 18, 'Acceptable'),
(19, 18, 18, '/uploads/graphics.zip', '2024-04-07 17:45:00', 27, 'Creative work'),
(20, 1, 1, '/submissions/assignment20.pdf', '2026-06-10 21:02:54', 90, 'Excellent Work'),
(21, 1, 24, '/submissions/final_assignment.pdf', '2026-06-10 21:04:27', 90, 'Excellent Work');

-- =====================================================
-- 14. QUIZ Table (22 rows)
-- =====================================================
INSERT INTO quiz (quiz_id, subject_id, teacher_id, title, total_marks, time_limit, quiz_date) VALUES
(1, 1, 1, 'DB Quiz 1 - Basics', 20, 30, '2023-10-05'),
(2, 1, 1, 'DB Quiz 2 - SQL', 25, 40, '2023-11-10'),
(3, 2, 1, 'DS Quiz - Arrays and Lists', 20, 30, '2023-10-12'),
(4, 3, 2, 'Web Quiz - HTML Basics', 15, 20, '2023-10-18'),
(5, 7, 4, 'OS Quiz 1', 20, 30, '2024-03-05'),
(6, 8, 5, 'Networks Quiz', 20, 30, '2024-03-06'),
(7, 9, 6, 'AI Basics Quiz', 25, 40, '2024-03-07'),
(8, 10, 7, 'ML Quiz', 25, 40, '2024-03-08'),
(9, 11, 8, 'Testing Quiz', 20, 30, '2024-03-09'),
(10, 12, 9, 'Requirements Quiz', 20, 30, '2024-03-10'),
(11, 13, 10, 'Agile Quiz', 20, 30, '2024-03-11'),
(12, 14, 11, 'Android Quiz', 25, 40, '2024-03-12'),
(13, 15, 12, 'Security Quiz', 20, 30, '2024-03-13'),
(14, 16, 13, 'Cloud Quiz', 25, 40, '2024-03-14'),
(15, 17, 14, 'Analytics Quiz', 20, 30, '2024-03-15'),
(16, 18, 15, 'BI Quiz', 20, 30, '2024-03-16'),
(17, 19, 16, 'Compiler Quiz', 25, 40, '2024-03-17'),
(18, 20, 17, 'Graphics Quiz', 20, 30, '2024-03-18'),
(19, 1, 1, 'Database Final Quiz', 50, 60, '2025-12-18'),
(20, 2, 2, 'Java OOP Quiz', 50, 45, '2025-12-19'),
(21, 1, 1, 'Database Final Quiz', 50, 60, '2025-12-18'),
(22, 2, 2, 'Java OOP Quiz', 50, 45, '2025-12-19');

-- =====================================================
-- 15. QUIZ_ATTEMPT Table (21 rows)
-- =====================================================
INSERT INTO quiz_attempt (attempt_id, quiz_id, student_id, score, attempt_date) VALUES
(1, 1, 1, 17.50, '2023-10-05 10:30:00'),
(2, 1, 2, 19.00, '2023-10-05 10:45:00'),
(3, 2, 1, 21.00, '2023-11-10 11:00:00'),
(4, 3, 1, 18.00, '2023-10-12 10:00:00'),
(5, 4, 1, 13.00, '2023-10-18 09:30:00'),
(6, 5, 5, 18.00, '2024-03-05 10:00:00'),
(7, 6, 6, 17.00, '2024-03-06 10:30:00'),
(8, 7, 7, 22.00, '2024-03-07 11:00:00'),
(9, 8, 8, 20.00, '2024-03-08 09:30:00'),
(10, 9, 9, 19.00, '2024-03-09 12:00:00'),
(11, 10, 10, 18.00, '2024-03-10 10:15:00'),
(12, 11, 11, 17.00, '2024-03-11 11:30:00'),
(13, 12, 12, 23.00, '2024-03-12 09:00:00'),
(14, 13, 13, 19.00, '2024-03-13 08:45:00'),
(15, 14, 14, 21.00, '2024-03-14 10:30:00'),
(16, 15, 15, 20.00, '2024-03-15 09:15:00'),
(17, 16, 16, 18.00, '2024-03-16 11:00:00'),
(18, 17, 17, 22.00, '2024-03-17 12:30:00'),
(19, 18, 18, 19.00, '2024-03-18 10:00:00'),
(20, 1, 1, 45.00, '2026-06-10 21:02:45'),
(21, 1, 24, 45.00, '2026-06-10 21:04:26');

-- =====================================================
-- 16. QUIZ_QUESTION Table (21 rows)
-- =====================================================
INSERT INTO quiz_question (question_id, quiz_id, question_type, question_text, correct_answer, marks) VALUES
(1, 1, 'MCQ', 'What does DBMS stand for?', 'Database Management System', 2),
(2, 1, 'MCQ', 'Which key uniquely identifies a row?', 'Primary Key', 2),
(3, 1, 'Short', 'Define Foreign Key.', 'A key referencing another table PK.', 3),
(4, 2, 'MCQ', 'Which SQL command retrieves data?', 'SELECT', 2),
(5, 2, 'MCQ', 'Which clause filters grouped results?', 'HAVING', 2),
(6, 3, 'MCQ', 'Array index starts from?', '0', 2),
(7, 4, 'MCQ', 'Which tag defines a hyperlink in HTML?', 'a', 2),
(8, 5, 'MCQ', 'Process scheduling belongs to?', 'Operating System', 2),
(9, 6, 'MCQ', 'OSI model has how many layers?', '7', 2),
(10, 7, 'MCQ', 'AI stands for?', 'Artificial Intelligence', 2),
(11, 8, 'MCQ', 'Supervised learning uses?', 'Labeled Data', 2),
(12, 9, 'MCQ', 'Unit testing checks?', 'Individual Module', 2),
(13, 10, 'MCQ', 'SRS stands for?', 'Software Requirement Specification', 2),
(14, 11, 'MCQ', 'Scrum is part of?', 'Agile', 2),
(15, 12, 'MCQ', 'Android is based on?', 'Linux', 2),
(16, 13, 'MCQ', 'Firewall is used for?', 'Security', 2),
(17, 14, 'MCQ', 'Cloud service example?', 'AWS', 2),
(18, 15, 'MCQ', 'Power BI is used for?', 'Analytics', 2),
(19, 16, 'MCQ', 'BI means?', 'Business Intelligence', 2),
(20, 17, 'MCQ', 'Compiler converts?', 'Source Code', 2),
(21, 18, 'MCQ', 'OpenGL is related to?', 'Graphics', 2);

-- =====================================================
-- 17. LEARNING_MATERIAL Table (21 rows)
-- =====================================================
INSERT INTO learning_material (material_id, subject_id, teacher_id, title, material_type, file_path, upload_date) VALUES
(1, 1, 1, 'DB Chapter 1 - Introduction', 'PDF', '/materials/db_ch1.pdf', '2023-09-10 08:00:00'),
(2, 1, 1, 'DB Chapter 2 - Relational Model', 'PDF', '/materials/db_ch2.pdf', '2023-09-17 08:00:00'),
(3, 1, 1, 'SQL Practice Queries', 'PDF', '/materials/sql_practice.pdf', '2023-10-01 09:00:00'),
(4, 2, 1, 'Data Structures Slides', 'PPT', '/materials/ds_slides.pptx', '2023-09-12 08:00:00'),
(5, 3, 2, 'HTML Reference Sheet', 'PDF', '/materials/html_ref.pdf', '2023-09-14 10:00:00'),
(6, 7, 4, 'OS Notes', 'PDF', '/materials/os_notes.pdf', '2024-02-20 09:00:00'),
(7, 8, 5, 'Network Slides', 'PPT', '/materials/network.pptx', '2024-02-20 10:00:00'),
(8, 9, 6, 'AI Handbook', 'PDF', '/materials/ai.pdf', '2024-02-21 09:00:00'),
(9, 10, 7, 'ML Lecture', 'VIDEO', '/materials/ml.mp4', '2024-02-21 11:00:00'),
(10, 11, 8, 'Testing Notes', 'PDF', '/materials/testing.pdf', '2024-02-22 09:00:00'),
(11, 12, 9, 'SRS Guide', 'PDF', '/materials/srs.pdf', '2024-02-22 10:00:00'),
(12, 13, 10, 'Agile Slides', 'PPT', '/materials/agile.pptx', '2024-02-23 09:00:00'),
(13, 14, 11, 'Android Tutorial', 'VIDEO', '/materials/android.mp4', '2024-02-23 11:00:00'),
(14, 15, 12, 'Security Notes', 'PDF', '/materials/security.pdf', '2024-02-24 09:00:00'),
(15, 16, 13, 'Cloud Guide', 'PDF', '/materials/cloud.pdf', '2024-02-24 10:00:00'),
(16, 17, 14, 'Analytics Dataset', 'ZIP', '/materials/data.zip', '2024-02-25 09:00:00'),
(17, 18, 15, 'BI Slides', 'PPT', '/materials/bi.pptx', '2024-02-25 11:00:00'),
(18, 19, 16, 'Compiler Notes', 'PDF', '/materials/compiler.pdf', '2024-02-26 09:00:00'),
(19, 20, 17, 'Graphics Book', 'PDF', '/materials/graphics.pdf', '2024-02-26 10:00:00'),
(20, 1, 1, 'Database Revision Notes', 'PDF', '/materials/db_revision.pdf', '2026-06-10 21:02:08'),
(21, 1, 1, 'Database Revision Notes', 'PDF', '/materials/db_revision_notes.pdf', '2026-06-10 21:04:26');

-- =====================================================
-- 18. ANNOUNCEMENT Table (22 rows)
-- =====================================================
INSERT INTO announcement (announcement_id, teacher_id, subject_id, title, content, created_at) VALUES
(1, 1, 1, 'Assignment 1 Posted', 'Please check Assignment 1 details on portal.', '2023-10-01 09:00:00'),
(2, 1, 1, 'Quiz 1 Reminder', 'Quiz 1 will be held on 5th October at 10 AM.', '2023-10-03 10:00:00'),
(3, 2, 3, 'Portfolio Deadline', 'Submit portfolio by 25th October.', '2023-10-10 11:00:00'),
(4, 1, 2, 'Linked List Notes', 'Linked list notes uploaded in materials.', '2023-10-08 08:30:00'),
(5, 4, 7, 'OS Assignment Uploaded', 'Please check LMS for assignment details.', '2024-03-01 08:00:00'),
(6, 5, 8, 'Network Quiz Reminder', 'Quiz will be held tomorrow.', '2024-03-02 09:00:00'),
(7, 6, 9, 'AI Project Notice', 'Submit project before deadline.', '2024-03-03 10:00:00'),
(8, 7, 10, 'ML Dataset Shared', 'Dataset uploaded to portal.', '2024-03-04 09:30:00'),
(9, 8, 11, 'Testing Lab', 'Lab will start at 2 PM.', '2024-03-05 08:30:00'),
(10, 9, 12, 'SRS Submission', 'Upload SRS in PDF format.', '2024-03-06 09:15:00'),
(11, 10, 13, 'Agile Workshop', 'Workshop scheduled on Friday.', '2024-03-07 10:00:00'),
(12, 11, 14, 'Android Viva', 'Viva date announced.', '2024-03-08 09:00:00'),
(13, 12, 15, 'Security Seminar', 'Guest speaker session this week.', '2024-03-09 08:45:00'),
(14, 13, 16, 'Cloud Lab', 'Cloud lab moved online.', '2024-03-10 09:00:00'),
(15, 14, 17, 'Analytics Assignment', 'Assignment 2 uploaded.', '2024-03-11 10:30:00'),
(16, 15, 18, 'BI Presentation', 'Presentation schedule published.', '2024-03-12 09:15:00'),
(17, 16, 19, 'Compiler Quiz', 'Quiz postponed by one day.', '2024-03-13 08:00:00'),
(18, 17, 20, 'Graphics Project', 'Final project guidelines uploaded.', '2024-03-14 09:30:00'),
(19, 1, 1, 'Final Exam Schedule', 'Final exam schedule has been uploaded', '2026-06-10 21:02:16'),
(20, 2, 2, 'Project Submission', 'Submit project before deadline', '2026-06-10 21:02:16'),
(21, 1, 1, 'Final Exam Schedule', 'Final examination schedule has been uploaded', '2026-06-10 21:04:26'),
(22, 2, 2, 'Project Submission Reminder', 'Submit your project before the deadline', '2026-06-10 21:04:26');

-- =====================================================
-- 19. LIVE_CLASS Table (22 rows)
-- =====================================================
INSERT INTO live_class (class_id, subject_id, teacher_id, zoom_link, class_date, start_time, end_time) VALUES
(1, 1, 1, 'https://zoom.us/j/1111111111', '2023-10-02', '10:00:00', '11:30:00'),
(2, 1, 1, 'https://zoom.us/j/2222222222', '2023-10-09', '10:00:00', '11:30:00'),
(3, 2, 1, 'https://zoom.us/j/3333333333', '2023-10-03', '14:00:00', '15:30:00'),
(4, 3, 2, 'https://zoom.us/j/4444444444', '2023-10-04', '12:00:00', '13:30:00'),
(5, 7, 4, 'https://zoom.us/j/700001', '2024-03-01', '09:00:00', '10:30:00'),
(6, 8, 5, 'https://zoom.us/j/700002', '2024-03-01', '11:00:00', '12:30:00'),
(7, 9, 6, 'https://zoom.us/j/700003', '2024-03-02', '09:00:00', '10:30:00'),
(8, 10, 7, 'https://zoom.us/j/700004', '2024-03-02', '11:00:00', '12:30:00'),
(9, 11, 8, 'https://zoom.us/j/700005', '2024-03-03', '09:00:00', '10:30:00'),
(10, 12, 9, 'https://zoom.us/j/700006', '2024-03-03', '11:00:00', '12:30:00'),
(11, 13, 10, 'https://zoom.us/j/700007', '2024-03-04', '09:00:00', '10:30:00'),
(12, 14, 11, 'https://zoom.us/j/700008', '2024-03-04', '11:00:00', '12:30:00'),
(13, 15, 12, 'https://zoom.us/j/700009', '2024-03-05', '09:00:00', '10:30:00'),
(14, 16, 13, 'https://zoom.us/j/700010', '2024-03-05', '11:00:00', '12:30:00'),
(15, 17, 14, 'https://zoom.us/j/700011', '2024-03-06', '09:00:00', '10:30:00'),
(16, 18, 15, 'https://zoom.us/j/700012', '2024-03-06', '11:00:00', '12:30:00'),
(17, 19, 16, 'https://zoom.us/j/700013', '2024-03-07', '09:00:00', '10:30:00'),
(18, 20, 17, 'https://zoom.us/j/700014', '2024-03-07', '11:00:00', '12:30:00'),
(19, 1, 1, 'https://zoom.us/j/123456789', '2025-12-10', '10:00:00', '11:00:00'),
(20, 2, 2, 'https://zoom.us/j/987654321', '2025-12-11', '12:00:00', '13:00:00'),
(21, 1, 1, 'https://zoom.us/j/123456789', '2025-12-10', '10:00:00', '11:00:00'),
(22, 2, 2, 'https://zoom.us/j/987654321', '2025-12-11', '12:00:00', '12:45:00');

-- =====================================================
-- 20. ATTENDANCE Table (22 rows)
-- =====================================================
INSERT INTO attendance (attendance_id, class_id, student_id, status, join_time) VALUES
(1, 1, 1, 'present', '2023-10-02 10:02:00'),
(2, 1, 2, 'present', '2023-10-02 10:05:00'),
(3, 2, 1, 'present', '2023-10-09 10:01:00'),
(4, 2, 2, 'absent', NULL),
(5, 3, 1, 'present', '2023-10-03 14:03:00'),
(6, 3, 3, 'late', '2023-10-03 14:20:00'),
(7, 4, 1, 'present', '2023-10-04 12:00:00'),
(8, 4, 4, 'present', '2023-10-04 12:05:00'),
(9, 5, 5, 'present', '2024-03-01 09:01:00'),
(10, 6, 6, 'present', '2024-03-01 11:02:00'),
(11, 7, 7, 'late', '2024-03-02 09:15:00'),
(12, 8, 8, 'present', '2024-03-02 11:00:00'),
(13, 9, 9, 'absent', NULL),
(14, 10, 10, 'present', '2024-03-03 11:03:00'),
(15, 11, 11, 'present', '2024-03-04 09:00:00'),
(16, 12, 12, 'late', '2024-03-04 11:10:00'),
(17, 13, 13, 'present', '2024-03-05 09:02:00'),
(18, 14, 14, 'present', '2024-03-05 11:01:00'),
(19, 15, 15, 'present', '2024-03-06 09:00:00'),
(20, 16, 16, 'absent', NULL),
(21, 17, 17, 'late', '2024-03-07 09:20:00'),
(22, 18, 18, 'present', '2024-03-07 11:05:00');
COMMIT;