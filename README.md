# 🗄️ AAK Academy Management System

## 📖 Project Description

AAK Academy Management System is a role-based e-learning and academic management platform designed to streamline educational activities within the academy. The system provides separate interfaces for administrators, teachers, and students to manage enrollments, subjects, fees, assignments, quizzes, attendance, live classes, notifications, and audit logs.

The project consists of a MySQL database integrated with a web-based frontend and backend to provide secure and efficient management of academic operations.

---

# 💻 System Requirements

## Software Requirements

- Windows 10/11 or Linux
- MySQL Server 8.0 or later
- MySQL Workbench (Recommended)
- Node.js v18 or later
- npm (Node Package Manager)
- Modern Web Browser (Google Chrome, Microsoft Edge, Firefox)

## Hardware Requirements

- Minimum 4 GB RAM
- Intel Core i3 Processor or equivalent
- 500 MB free disk space

## Required Libraries/Packages

Install project dependencies using:

```bash
npm install
```

Main packages include:

- Express.js
- mysql2
- dotenv
- cors

---

# ⚙️ Installation Instructions

## Step 1: Clone the repository

```bash
git clone <repository-link>
```

or download the project ZIP and extract it.

---

## Step 2: Navigate to project folder

```bash
cd AAK
```

---

## Step 3: Install Node.js dependencies

```bash
npm install
```

---

## Step 4: Create the MySQL database

```sql
CREATE DATABASE aak_academy;
USE aak_academy;
```

---

## Step 5: Import database schema

```sql
SOURCE dbDDL.sql;
```

---

## Step 6: Insert sample data

```sql
SOURCE dbDML.sql;
```

---

## Step 7: Configure environment variables

Open the `.env` file and update:

```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_NAME=aak_academy
PORT=3000
```

---

## Step 8: Start the backend server

```bash
node server.js
```

You should see:

```
AAMS server running at http://localhost:3000
Database: aak_academy @ localhost
```

---

# ▶️ Usage Instructions

1. Ensure the MySQL server is running.
2. Start the backend server using:

```bash
node server.js
```

3. Open your browser and visit:

```
http://localhost:3000
```

or

```
http://localhost:3000/AAMS_RoleBased.html
```

4. Log in according to your assigned role:

- Administrator
- Teacher
- Student

5. Use the dashboard to:

- Manage students
- Manage teachers
- Enroll subjects
- Calculate fees
- Upload assignments
- Attempt quizzes
- Schedule live classes
- Track attendance
- View notifications
- Monitor audit logs

---

# 📁 Code Structure

```
AAK/
│
├── AAMS_RoleBased.html      # Main frontend interface
├── server.js                # Node.js backend server
├── package.json             # Project dependencies
├── package-lock.json
├── .env                     # Environment configuration
├── dbDDL.sql                # Database schema creation script
├── dbDML.sql                # Sample data insertion script
├── node_modules/            # Installed npm packages
└── README.md                # Project documentation
```

---

# ✨ Database Features

- Student Management
- Teacher Management
- Program Management
- Subject Enrollment
- Automated Fee Calculation
  - 10% discount for 3 subjects
  - 20% discount for 6 subjects
- Payment Tracking
- Assignment Management
- Quiz Management
- Learning Material Repository
- Live Class Scheduling
- Attendance Tracking
- Notification System
- Role-Based Access Control
- Complete Audit Logging

---

# 🗃️ Database Schema (20 Tables)

| Table | Description |
|----------|-----------------------------|
| user | System users |
| admin | Administrator details |
| teacher | Teacher profiles |
| program | Academic programs |
| student | Student information |
| subject | Course subjects |
| enrollment | Student subject enrollment |
| fee_record | Student fee records |
| payment | Payment transactions |
| assignment | Assignment details |
| assignment_submission | Assignment submissions |
| quiz | Quiz information |
| quiz_attempt | Quiz attempts |
| quiz_question | Quiz questions |
| learning_material | Study resources |
| announcement | System announcements |
| live_class | Online class sessions |
| attendance | Attendance records |
| notification | User notifications |
| audit_log | System audit logs |

---

# 🛠️ Technology Stack

- **Frontend:** HTML5, CSS3, JavaScript
- **Backend:** Node.js, Express.js
- **Database:** MySQL 8.0
- **Environment:** dotenv
- **Database Driver:** mysql2

---

# 👨‍💻 Team Members

| Name | Roll Number | Email |
|----------------------|----------------|----------------------------|
| Salman Safdar | NUM-BSCS-2024-70 | bscs24f70@namal.edu.pk |
| Muhammad Haris | NUM-BSCS-2024-49 | bscs24f49@namal.edu.pk |
| Farwa Imran | NUM-BSCS-2024-22 | bscs24f22@namal.edu.pk |

---

## 👩‍🏫 Instructor

**Mam Asiya Batool**

## 📌 Requirement Provider

**Ammar Ahmad Khan**
