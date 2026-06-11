**# 🗄️ AAK Academy Management System - Database**

AAK Academy is an innovative e-learning platform designed to revolutionize the way students at the academy engage with educational content. This database serves as the backbone of the platform, managing student enrollment, fee calculation with automated discounts (10% for 3 subjects, 20% for 6 subjects), assignment and quiz administration, live class scheduling, attendance tracking, and comprehensive audit logging.

**## Database Features**

- **Student Management**: Complete student profiles with program enrollment
- **Subject Selection**: Students can enroll in subjects with automated discount calculation
- **Fee Management**: Real-time fee computation, payment tracking, and invoice generation
- **Assignment & Quiz System**: Create, submit, grade assignments and quizzes with feedback
- **Live Class Integration**: Zoom-integrated virtual classrooms with attendance tracking
- **Role-Based Access**: Admin, Teacher, and Student roles with distinct permissions
- **Audit Logging**: Complete trail of all user actions for accountability

**## Database Schema (20 Tables)**

**| Table | Description |**
|-------|-------------|
| user | System users (admin, teacher, student) |
| admin | Administrator details |
| teacher | Teacher profiles and qualifications |
| program | Academic programs |
| student | Student information |
| subject | Course subjects |
| enrollment | Student subject enrollment (bridge table) |
| fee_record | Fee records for students |
| payment | Payment transactions |
| assignment | Assignment details |
| assignment_submission | Student assignment submissions |
| quiz | Quiz information |
| quiz_attempt | Student quiz attempts |
| quiz_question | Quiz questions |
| learning_material | Study materials |
| announcement | System announcements |
| live_class | Online class sessions |
| attendance | Student attendance records |
| notification | User notifications |
| audit_log | System audit trail |

## Technology Stack

- **DBMS**: MySQL 8.0+
- **Frontend**: HTML5, CSS3, JavaScript
- **Backend**: PHP / Node.js

**## Installation**

```sql
-- Create database
CREATE DATABASE aak_academy;
USE aak_academy;

-- Run DDL script to create tables
SOURCE dbDDL.sql;

-- Run DML script to insert sample data
SOURCE dbDML.sql;



Group Details
**| Name           | Roll No.         |	Email                  |**
  | Salman Safdar  | NUM-BSCS-2024-70 |	bscs24f70@namal.edu.pk |
  | Muhammad Haris | NUM-BSCS-2024-49 |	bscs24f49@namal.edu.pk |
  | Farwa Imran	   | NUM-BSCS-2024-22 |	bscs24f22@namal.edu.pk |

**Instructor: Mam Asiya Batool

Requirement Provider: Ammar Ahmad Khan**
