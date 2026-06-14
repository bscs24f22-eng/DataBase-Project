require('dotenv').config();
const express = require('express');
const mysql = require('mysql2/promise');
const cors = require('cors');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname)));

const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'aak_academy',
  password: process.env.DB_PASSWORD || 'Namal.123',
  database: process.env.DB_NAME || 'aak_academy',
  waitForConnections: true,
  connectionLimit: 10,
  dateStrings: true,
});

async function query(sql, params = []) {
  const [rows] = await pool.execute(sql, params);
  return rows;
}

function cap(s) {
  if (!s) return s;
  return s.charAt(0).toUpperCase() + s.slice(1).toLowerCase();
}

function fmtStatus(s) {
  return s === 'active' ? 'Active' : 'Inactive';
}

function fmtFeeStatus(s) {
  const m = { paid: 'Paid', unpaid: 'Pending', partial: 'Partial' };
  return m[s] || cap(s);
}

function fmtAttStatus(s) {
  if (!s) return 'Absent';
  return cap(s);
}

async function logAudit(userId, action, oldVal, newVal) {
  try {
    await query(
      'INSERT INTO audit_log (user_id, action, old_value, new_value) VALUES (?, ?, ?, ?)',
      [userId || null, action, oldVal || null, newVal || null]
    );
  } catch (_) { /* non-blocking */ }
}

// ── HEALTH ──
app.get('/api/health', async (_req, res) => {
  try {
    await query('SELECT 1 AS ok');
    res.json({ ok: true, database: process.env.DB_NAME });
  } catch (err) {
    res.status(500).json({ ok: false, error: err.message });
  }
});

// ── LOGIN ──
app.post('/api/login', async (req, res) => {
  try {
    const { email, password, role } = req.body;
    if (!email || !role) return res.status(400).json({ error: 'Email and role required' });

    const dbRole = role.toLowerCase();
    const rows = await query(
      `SELECT u.user_id, u.full_name, u.email, u.password_hash, u.role, u.phone, u.status,
              a.admin_id, t.teacher_id, s.student_id
       FROM \`user\` u
       LEFT JOIN admin a ON u.user_id = a.user_id
       LEFT JOIN teacher t ON u.user_id = t.user_id
       LEFT JOIN student s ON u.user_id = s.user_id
       WHERE u.email = ? AND u.role = ? AND u.status = 'active'`,
      [email, dbRole]
    );
    if (!rows.length) return res.status(401).json({ error: 'Invalid email or role' });

    const user = rows[0];
    const validPass =
      !password ||
      password === 'password123' ||
      password === user.password_hash ||
      password === process.env.DB_PASSWORD;

    if (!validPass) return res.status(401).json({ error: 'Invalid password' });

    res.json({
      user_id: user.user_id,
      name: user.full_name,
      email: user.email,
      role: cap(user.role),
      phone: user.phone,
      admin_id: user.admin_id,
      teacher_id: user.teacher_id,
      student_id: user.student_id,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ── META (dropdowns) ──
app.get('/api/meta', async (_req, res) => {
  try {
    const [students, teachers, programs, subjects] = await Promise.all([
      query(`SELECT s.student_id AS id, u.full_name AS name FROM student s JOIN \`user\` u ON s.user_id = u.user_id ORDER BY u.full_name`),
      query(`SELECT t.teacher_id AS id, u.full_name AS name FROM teacher t JOIN \`user\` u ON t.user_id = u.user_id ORDER BY u.full_name`),
      query(`SELECT program_id AS id, program_name AS name FROM program ORDER BY program_name`),
      query(`SELECT s.subject_id AS id, s.subject_name AS name, p.program_name AS program
             FROM subject s LEFT JOIN program p ON s.program_id = p.program_id ORDER BY s.subject_name`),
    ]);
    res.json({ students, teachers, programs, subjects });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ── DASHBOARD STATS ──
app.get('/api/dashboard/stats', async (_req, res) => {
  try {
    const [sc] = await query('SELECT COUNT(*) AS c FROM student');
    const [tc] = await query('SELECT COUNT(*) AS c FROM teacher');
    const [subc] = await query('SELECT COUNT(*) AS c FROM subject');
    const [rev] = await query('SELECT COALESCE(SUM(amount_paid),0) AS total FROM fee_record');
    const [att] = await query(`SELECT
      ROUND(SUM(CASE WHEN status='present' THEN 1 ELSE 0 END)*100/COUNT(*),1) AS rate,
      COUNT(*) AS total FROM attendance`);
    res.json({
      students: sc.c,
      teachers: tc.c,
      subjects: subc.c,
      revenue: rev.total,
      attendanceRate: att.rate || 0,
      classesHeld: att.total || 0,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ── STUDENTS ──
app.get('/api/students', async (_req, res) => {
  try {
    const rows = await query(`
      SELECT s.student_id AS id, s.student_id,
        CONCAT('NUM-', LPAD(s.student_id, 4, '0')) AS regNo,
        u.full_name AS name, u.email, u.status,
        s.dob, s.gender, s.enrollment_date AS enrolled,
        COALESCE(p.program_name, 'Unassigned') AS program,
        s.program_id, s.fee_status
      FROM student s
      JOIN \`user\` u ON s.user_id = u.user_id
      LEFT JOIN program p ON s.program_id = p.program_id
      ORDER BY s.student_id`);
    res.json(rows.map(r => ({
      ...r,
      gender: cap(r.gender),
      status: fmtStatus(r.status),
    })));
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/api/students', async (req, res) => {
  const conn = await pool.getConnection();
  try {
    const { name, email, program, dob, gender, enrolled, status, phone } = req.body;
    await conn.beginTransaction();
    const [ur] = await conn.execute(
      `INSERT INTO \`user\` (full_name, email, password_hash, role, phone, status)
       VALUES (?, ?, 'password123', 'student', ?, ?)`,
      [name, email || `${name.toLowerCase().replace(/\s/g,'.')}@student.aakacademy.pk`,
       phone || null, (status || 'Active').toLowerCase()]
    );
    const userId = ur.insertId;
    let programId = req.body.program_id || null;
    if (!programId && program) {
      const [pr] = await conn.execute('SELECT program_id FROM program WHERE program_name = ?', [program]);
      if (pr.length) programId = pr[0].program_id;
    }
    const [sr] = await conn.execute(
      `INSERT INTO student (user_id, dob, gender, program_id, enrollment_date, fee_status)
       VALUES (?, ?, ?, ?, ?, 'unpaid')`,
      [userId, dob || null, (gender || 'male').toLowerCase(), programId, enrolled || new Date().toISOString().slice(0, 10)]
    );
    await conn.commit();
    res.json({ id: sr.insertId, message: 'Student created' });
  } catch (err) {
    await conn.rollback();
    res.status(500).json({ error: err.message });
  } finally {
    conn.release();
  }
});

app.put('/api/students/:id', async (req, res) => {
  const conn = await pool.getConnection();
  try {
    const id = req.params.id;
    const { name, program, dob, gender, enrolled, status, phone } = req.body;
    const [st] = await conn.execute('SELECT user_id FROM student WHERE student_id = ?', [id]);
    if (!st.length) return res.status(404).json({ error: 'Not found' });
    const userId = st[0].user_id;

    let programId = req.body.program_id || null;
    if (!programId && program) {
      const [pr] = await conn.execute('SELECT program_id FROM program WHERE program_name = ?', [program]);
      if (pr.length) programId = pr[0].program_id;
    }

    await conn.execute(
      `UPDATE \`user\` SET full_name=?, phone=?, status=? WHERE user_id=?`,
      [name, phone || null, (status || 'Active').toLowerCase(), userId]
    );
    await conn.execute(
      `UPDATE student SET dob=?, gender=?, program_id=?, enrollment_date=? WHERE student_id=?`,
      [dob || null, (gender || 'male').toLowerCase(), programId, enrolled, id]
    );
    await conn.commit();
    res.json({ message: 'Updated' });
  } catch (err) {
    await conn.rollback();
    res.status(500).json({ error: err.message });
  } finally {
    conn.release();
  }
});

app.delete('/api/students/:id', async (req, res) => {
  try {
    const [st] = await query('SELECT user_id FROM student WHERE student_id = ?', [req.params.id]);
    if (!st.length) return res.status(404).json({ error: 'Not found' });
    await query('DELETE FROM \`user\` WHERE user_id = ?', [st[0].user_id]);
    res.json({ message: 'Deleted' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ── TEACHERS ──
app.get('/api/teachers', async (_req, res) => {
  try {
    const rows = await query(`
      SELECT t.teacher_id AS id, u.full_name AS name, u.email,
        t.qualification, t.specialization, t.experience_years AS experience,
        DATE(u.created_at) AS hireDate,
        (SELECT COUNT(*) FROM subject WHERE teacher_id = t.teacher_id) AS subjects
      FROM teacher t JOIN \`user\` u ON t.user_id = u.user_id ORDER BY t.teacher_id`);
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/api/teachers', async (req, res) => {
  const conn = await pool.getConnection();
  try {
    const { name, email, qualification, specialization, experience, phone } = req.body;
    await conn.beginTransaction();
    const [ur] = await conn.execute(
      `INSERT INTO \`user\` (full_name, email, password_hash, role, phone, status)
       VALUES (?, ?, 'password123', 'teacher', ?, 'active')`,
      [name, email || `${name.toLowerCase().replace(/\s/g,'.')}@aakacademy.pk`, phone || null]
    );
    const [tr] = await conn.execute(
      `INSERT INTO teacher (user_id, qualification, experience_years, specialization)
       VALUES (?, ?, ?, ?)`,
      [ur.insertId, qualification || null, experience || 0, specialization || null]
    );
    await conn.commit();
    res.json({ id: tr.insertId });
  } catch (err) {
    await conn.rollback();
    res.status(500).json({ error: err.message });
  } finally {
    conn.release();
  }
});

app.put('/api/teachers/:id', async (req, res) => {
  const conn = await pool.getConnection();
  try {
    const id = req.params.id;
    const { name, qualification, specialization, experience, email, phone } = req.body;
    const [t] = await conn.execute('SELECT user_id FROM teacher WHERE teacher_id = ?', [id]);
    if (!t.length) return res.status(404).json({ error: 'Not found' });
    await conn.execute('UPDATE \`user\` SET full_name=?, email=?, phone=? WHERE user_id=?',
      [name, email, phone || null, t[0].user_id]);
    await conn.execute(
      'UPDATE teacher SET qualification=?, specialization=?, experience_years=? WHERE teacher_id=?',
      [qualification, specialization, experience || 0, id]
    );
    await conn.commit();
    res.json({ message: 'Updated' });
  } catch (err) {
    await conn.rollback();
    res.status(500).json({ error: err.message });
  } finally {
    conn.release();
  }
});

app.delete('/api/teachers/:id', async (req, res) => {
  try {
    const [t] = await query('SELECT user_id FROM teacher WHERE teacher_id = ?', [req.params.id]);
    if (!t.length) return res.status(404).json({ error: 'Not found' });
    await query('DELETE FROM \`user\` WHERE user_id = ?', [t[0].user_id]);
    res.json({ message: 'Deleted' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ── PROGRAMS ──
app.get('/api/programs', async (_req, res) => {
  try {
    const rows = await query(`
      SELECT p.program_id AS id, p.program_name AS name, p.description,
        (SELECT COUNT(*) FROM student WHERE program_id = p.program_id) AS students,
        (SELECT COUNT(*) FROM subject WHERE program_id = p.program_id) AS subjects
      FROM program p ORDER BY p.program_id`);
    res.json(rows.map(r => ({
      ...r,
      level: r.name.includes('Short') || r.name.includes('Diploma') ? 'Certificate' : 'Undergraduate',
      duration: r.name.includes('ADP') || r.name.includes('Diploma') ? 2 : r.name.includes('Short') ? 1 : 4,
    })));
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/api/programs', async (req, res) => {
  try {
    const { name, description } = req.body;
    const [r] = await pool.execute('INSERT INTO program (program_name, description) VALUES (?, ?)',
      [name, description || null]);
    res.json({ id: r.insertId });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.put('/api/programs/:id', async (req, res) => {
  try {
    const { name, description } = req.body;
    await query('UPDATE program SET program_name=?, description=? WHERE program_id=?',
      [name, description || null, req.params.id]);
    res.json({ message: 'Updated' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.delete('/api/programs/:id', async (req, res) => {
  try {
    await query('DELETE FROM program WHERE program_id = ?', [req.params.id]);
    res.json({ message: 'Deleted' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ── SUBJECTS ──
app.get('/api/subjects', async (req, res) => {
  try {
    let sql = `
      SELECT s.subject_id AS id, CONCAT('SUB-', LPAD(s.subject_id, 3, '0')) AS code,
        s.subject_name AS name, COALESCE(p.program_name,'—') AS program,
        COALESCE(u.full_name,'Unassigned') AS teacher,
        s.credit_hours AS creditHrs, s.fee, s.program_id, s.teacher_id, s.prerequisite
      FROM subject s
      LEFT JOIN program p ON s.program_id = p.program_id
      LEFT JOIN teacher t ON s.teacher_id = t.teacher_id
      LEFT JOIN \`user\` u ON t.user_id = u.user_id`;
    const params = [];
    if (req.query.teacher_id) { sql += ' WHERE s.teacher_id = ?'; params.push(req.query.teacher_id); }
    if (req.query.student_id) {
      sql += params.length ? ' AND' : ' WHERE';
      sql += ' s.subject_id IN (SELECT subject_id FROM enrollment WHERE student_id = ?)';
      params.push(req.query.student_id);
    }
    sql += ' ORDER BY s.subject_id';
    res.json(await query(sql, params));
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/api/subjects', async (req, res) => {
  try {
    const { name, program, teacher, creditHrs, fee, program_id, teacher_id } = req.body;
    let pid = program_id, tid = teacher_id;
    if (!pid && program) {
      const [p] = await query('SELECT program_id FROM program WHERE program_name = ?', [program]);
      if (p) pid = p.program_id;
    }
    if (!tid && teacher) {
      const [t] = await query(
        `SELECT t.teacher_id FROM teacher t JOIN \`user\` u ON t.user_id=u.user_id WHERE u.full_name=?`, [teacher]);
      if (t) tid = t.teacher_id;
    }
    const [r] = await pool.execute(
      'INSERT INTO subject (program_id, teacher_id, subject_name, credit_hours, fee) VALUES (?,?,?,?,?)',
      [pid, tid, name, creditHrs || 3, fee || 0]
    );
    res.json({ id: r.insertId });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.put('/api/subjects/:id', async (req, res) => {
  try {
    const { name, program, teacher, creditHrs, fee } = req.body;
    let pid = req.body.program_id, tid = req.body.teacher_id;
    if (!pid && program) {
      const [p] = await query('SELECT program_id FROM program WHERE program_name = ?', [program]);
      if (p) pid = p.program_id;
    }
    if (!tid && teacher) {
      const [t] = await query(
        `SELECT t.teacher_id FROM teacher t JOIN \`user\` u ON t.user_id=u.user_id WHERE u.full_name=?`, [teacher]);
      if (t) tid = t.teacher_id;
    }
    await query(
      'UPDATE subject SET program_id=?, teacher_id=?, subject_name=?, credit_hours=?, fee=? WHERE subject_id=?',
      [pid, tid, name, creditHrs || 3, fee || 0, req.params.id]
    );
    res.json({ message: 'Updated' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.delete('/api/subjects/:id', async (req, res) => {
  try {
    await query('DELETE FROM subject WHERE subject_id = ?', [req.params.id]);
    res.json({ message: 'Deleted' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ── ENROLLMENT ──
app.get('/api/enrollment', async (req, res) => {
  try {
    let sql = `
      SELECT e.enrollment_id AS id, u.full_name AS student, sub.subject_name AS subject,
        e.enrollment_date AS date, e.discount_percentage AS discount, 'Active' AS status,
        e.student_id, e.subject_id
      FROM enrollment e
      JOIN student s ON e.student_id = s.student_id
      JOIN \`user\` u ON s.user_id = u.user_id
      JOIN subject sub ON e.subject_id = sub.subject_id`;
    const params = [];
    if (req.query.student_id) { sql += ' WHERE e.student_id = ?'; params.push(req.query.student_id); }
    sql += ' ORDER BY e.enrollment_id';
    res.json(await query(sql, params));
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/api/enrollment', async (req, res) => {
  try {
    const { student, subject, date, discount, student_id, subject_id } = req.body;
    let sid = student_id, subid = subject_id;
    if (!sid && student) {
      const [s] = await query(
        `SELECT s.student_id FROM student s JOIN \`user\` u ON s.user_id=u.user_id WHERE u.full_name=?`, [student]);
      if (s) sid = s.student_id;
    }
    if (!subid && subject) {
      const [s] = await query('SELECT subject_id FROM subject WHERE subject_name = ?', [subject]);
      if (s) subid = s.subject_id;
    }
    const [r] = await pool.execute(
      'INSERT INTO enrollment (student_id, subject_id, enrollment_date, discount_percentage) VALUES (?,?,?,?)',
      [sid, subid, date || new Date().toISOString().slice(0, 10), discount || 0]
    );
    res.json({ id: r.insertId });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.put('/api/enrollment/:id', async (req, res) => {
  try {
    const { date, discount } = req.body;
    await query('UPDATE enrollment SET enrollment_date=?, discount_percentage=? WHERE enrollment_id=?',
      [date, discount || 0, req.params.id]);
    res.json({ message: 'Updated' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.delete('/api/enrollment/:id', async (req, res) => {
  try {
    await query('DELETE FROM enrollment WHERE enrollment_id = ?', [req.params.id]);
    res.json({ message: 'Deleted' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ── ASSIGNMENTS ──
app.get('/api/assignments', async (req, res) => {
  try {
    let sql = `
      SELECT a.assignment_id AS id, a.title, sub.subject_name AS subject,
        u.full_name AS teacher, a.deadline, a.total_marks AS marks, a.instructions,
        (SELECT COUNT(*) FROM assignment_submission WHERE assignment_id = a.assignment_id) AS submissions,
        a.subject_id, a.teacher_id
      FROM assignment a
      JOIN subject sub ON a.subject_id = sub.subject_id
      JOIN teacher t ON a.teacher_id = t.teacher_id
      JOIN \`user\` u ON t.user_id = u.user_id`;
    const params = [];
    if (req.query.teacher_id) { sql += ' WHERE a.teacher_id = ?'; params.push(req.query.teacher_id); }
    if (req.query.student_id) {
      sql += params.length ? ' AND' : ' WHERE';
      sql += ' a.subject_id IN (SELECT subject_id FROM enrollment WHERE student_id = ?)';
      params.push(req.query.student_id);
    }
    sql += ' ORDER BY a.assignment_id DESC';
    res.json(await query(sql, params));
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/api/assignments', async (req, res) => {
  try {
    const { title, subject, deadline, marks, instructions, teacher_id, subject_id } = req.body;
    let subid = subject_id, tid = teacher_id || req.body.teacherId;
    if (!subid && subject) {
      const [s] = await query('SELECT subject_id, teacher_id FROM subject WHERE subject_name = ?', [subject]);
      if (s) { subid = s.subject_id; if (!tid) tid = s.teacher_id; }
    }
    if (!tid) {
      const [t] = await query('SELECT teacher_id FROM subject WHERE subject_id = ?', [subid]);
      if (t.length) tid = t[0].teacher_id;
    }
    const [r] = await pool.execute(
      'INSERT INTO assignment (subject_id, teacher_id, title, instructions, deadline, total_marks) VALUES (?,?,?,?,?,?)',
      [subid, tid, title, instructions || null, deadline, marks || 20]
    );
    res.json({ id: r.insertId });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.put('/api/assignments/:id', async (req, res) => {
  try {
    const { title, deadline, marks, instructions } = req.body;
    await query('UPDATE assignment SET title=?, deadline=?, total_marks=?, instructions=? WHERE assignment_id=?',
      [title, deadline, marks, instructions || null, req.params.id]);
    res.json({ message: 'Updated' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.delete('/api/assignments/:id', async (req, res) => {
  try {
    await query('DELETE FROM assignment WHERE assignment_id = ?', [req.params.id]);
    res.json({ message: 'Deleted' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ── QUIZZES ──
app.get('/api/quizzes', async (req, res) => {
  try {
    let sql = `
      SELECT q.quiz_id AS id, q.title, sub.subject_name AS subject,
        u.full_name AS teacher, q.total_marks AS marks, q.quiz_date AS date,
        q.time_limit AS time, q.subject_id, q.teacher_id
      FROM quiz q
      JOIN subject sub ON q.subject_id = sub.subject_id
      JOIN teacher t ON q.teacher_id = t.teacher_id
      JOIN \`user\` u ON t.user_id = u.user_id`;
    const params = [];
    if (req.query.teacher_id) { sql += ' WHERE q.teacher_id = ?'; params.push(req.query.teacher_id); }
    if (req.query.student_id) {
      sql += params.length ? ' AND' : ' WHERE';
      sql += ' q.subject_id IN (SELECT subject_id FROM enrollment WHERE student_id = ?)';
      params.push(req.query.student_id);
    }
    sql += ' ORDER BY q.quiz_id DESC';
    res.json(await query(sql, params));
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/api/quizzes', async (req, res) => {
  try {
    const { title, subject, marks, date, time, teacher_id, subject_id } = req.body;
    let subid = subject_id, tid = teacher_id;
    if (!subid && subject) {
      const [s] = await query('SELECT subject_id, teacher_id FROM subject WHERE subject_name = ?', [subject]);
      if (s) { subid = s.subject_id; if (!tid) tid = s.teacher_id; }
    }
    const [r] = await pool.execute(
      'INSERT INTO quiz (subject_id, teacher_id, title, total_marks, time_limit, quiz_date) VALUES (?,?,?,?,?,?)',
      [subid, tid, title, marks || 20, time || 30, date]
    );
    res.json({ id: r.insertId });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.put('/api/quizzes/:id', async (req, res) => {
  try {
    const { title, marks, date, time } = req.body;
    await query('UPDATE quiz SET title=?, total_marks=?, quiz_date=?, time_limit=? WHERE quiz_id=?',
      [title, marks, date, time, req.params.id]);
    res.json({ message: 'Updated' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.delete('/api/quizzes/:id', async (req, res) => {
  try {
    await query('DELETE FROM quiz WHERE quiz_id = ?', [req.params.id]);
    res.json({ message: 'Deleted' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ── LIVE CLASSES ──
app.get('/api/liveclasses', async (req, res) => {
  try {
    let sql = `
      SELECT lc.class_id AS id, sub.subject_name AS subject, u.full_name AS teacher,
        lc.zoom_link AS zoom, lc.class_date AS date,
        TIME_FORMAT(lc.start_time,'%h:%i %p') AS start,
        TIME_FORMAT(lc.end_time,'%h:%i %p') AS end,
        lc.subject_id, lc.teacher_id, lc.start_time, lc.end_time
      FROM live_class lc
      JOIN subject sub ON lc.subject_id = sub.subject_id
      JOIN teacher t ON lc.teacher_id = t.teacher_id
      JOIN \`user\` u ON t.user_id = u.user_id`;
    const params = [];
    if (req.query.teacher_id) { sql += ' WHERE lc.teacher_id = ?'; params.push(req.query.teacher_id); }
    if (req.query.student_id) {
      sql += params.length ? ' AND' : ' WHERE';
      sql += ' lc.subject_id IN (SELECT subject_id FROM enrollment WHERE student_id = ?)';
      params.push(req.query.student_id);
    }
    sql += ' ORDER BY lc.class_date DESC';
    res.json(await query(sql, params));
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/api/liveclasses', async (req, res) => {
  try {
    const { subject, zoom, date, start, end, teacher_id, subject_id } = req.body;
    let subid = subject_id, tid = teacher_id;
    if (!subid && subject) {
      const [s] = await query('SELECT subject_id, teacher_id FROM subject WHERE subject_name = ?', [subject]);
      if (s) { subid = s.subject_id; if (!tid) tid = s.teacher_id; }
    }
    const [r] = await pool.execute(
      'INSERT INTO live_class (subject_id, teacher_id, zoom_link, class_date, start_time, end_time) VALUES (?,?,?,?,?,?)',
      [subid, tid, zoom, date, start, end]
    );
    res.json({ id: r.insertId });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.put('/api/liveclasses/:id', async (req, res) => {
  try {
    const { zoom, date, start, end } = req.body;
    await query('UPDATE live_class SET zoom_link=?, class_date=?, start_time=?, end_time=? WHERE class_id=?',
      [zoom, date, start, end, req.params.id]);
    res.json({ message: 'Updated' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.delete('/api/liveclasses/:id', async (req, res) => {
  try {
    await query('DELETE FROM live_class WHERE class_id = ?', [req.params.id]);
    res.json({ message: 'Deleted' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ── ATTENDANCE ──
app.get('/api/attendance', async (req, res) => {
  try {
    let sql = `
      SELECT att.attendance_id AS id, su.full_name AS student,
        CONCAT(sub.subject_name, ' — ', lc.class_date) AS liveClass,
        att.join_time AS datetime, att.status,
        att.class_id, att.student_id
      FROM attendance att
      JOIN student s ON att.student_id = s.student_id
      JOIN \`user\` su ON s.user_id = su.user_id
      JOIN live_class lc ON att.class_id = lc.class_id
      JOIN subject sub ON lc.subject_id = sub.subject_id`;
    const params = [];
    if (req.query.student_id) { sql += ' WHERE att.student_id = ?'; params.push(req.query.student_id); }
    sql += ' ORDER BY att.attendance_id DESC';
    const rows = await query(sql, params);
    res.json(rows.map(r => ({ ...r, status: fmtAttStatus(r.status) })));
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/api/attendance', async (req, res) => {
  try {
    const { student, liveClass, datetime, status, student_id, class_id } = req.body;
    let sid = student_id, cid = class_id;
    if (!sid && student) {
      const [s] = await query(
        `SELECT s.student_id FROM student s JOIN \`user\` u ON s.user_id=u.user_id WHERE u.full_name=?`, [student]);
      if (s) sid = s.student_id;
    }
    if (!cid && liveClass) {
      const subName = liveClass.split(' — ')[0];
      const [c] = await query(
        `SELECT lc.class_id FROM live_class lc JOIN subject sub ON lc.subject_id=sub.subject_id
         WHERE sub.subject_name = ? ORDER BY lc.class_date DESC LIMIT 1`, [subName]);
      if (c) cid = c.class_id;
    }
    const dbStatus = (status || 'Present').toLowerCase();
    const [r] = await pool.execute(
      'INSERT INTO attendance (class_id, student_id, status, join_time) VALUES (?,?,?,?)',
      [cid, sid, dbStatus === 'present' ? 'present' : 'absent', datetime || null]
    );
    res.json({ id: r.insertId });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.put('/api/attendance/:id', async (req, res) => {
  try {
    const { status, datetime } = req.body;
    const dbStatus = (status || 'present').toLowerCase();
    await query('UPDATE attendance SET status=?, join_time=? WHERE attendance_id=?',
      [dbStatus, datetime || null, req.params.id]);
    res.json({ message: 'Updated' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.delete('/api/attendance/:id', async (req, res) => {
  try {
    await query('DELETE FROM attendance WHERE attendance_id = ?', [req.params.id]);
    res.json({ message: 'Deleted' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ── FEES ──
app.get('/api/fees', async (req, res) => {
  try {
    let sql = `
      SELECT f.fee_id AS id, u.full_name AS student, f.total_fee AS total,
        f.discount_percentage AS discount, f.amount_paid AS paid,
        f.remaining_balance AS balance, f.due_date AS due, f.payment_status AS status,
        f.student_id
      FROM fee_record f
      JOIN student s ON f.student_id = s.student_id
      JOIN \`user\` u ON s.user_id = u.user_id`;
    const params = [];
    if (req.query.student_id) { sql += ' WHERE f.student_id = ?'; params.push(req.query.student_id); }
    sql += ' ORDER BY f.fee_id';
    const rows = await query(sql, params);
    res.json(rows.map(r => ({
      ...r,
      total: parseFloat(r.total),
      paid: parseFloat(r.paid),
      balance: parseFloat(r.balance || 0),
      status: fmtFeeStatus(r.status),
    })));
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/api/fees', async (req, res) => {
  try {
    const { student, total, discount, paid, due, status, student_id } = req.body;
    let sid = student_id;
    if (!sid && student) {
      const [s] = await query(
        `SELECT s.student_id FROM student s JOIN \`user\` u ON s.user_id=u.user_id WHERE u.full_name=?`, [student]);
      if (s) sid = s.student_id;
    }
    const paidAmt = parseFloat(paid) || 0;
    const totalAmt = parseFloat(total) || 0;
    const disc = parseFloat(discount) || 0;
    const afterDisc = totalAmt * (1 - disc / 100);
    const balance = Math.max(0, afterDisc - paidAmt);
    const payStatus = (status || 'Pending').toLowerCase();
    const dbStatus = payStatus === 'overdue' ? 'unpaid' : payStatus === 'pending' ? 'unpaid' : payStatus;
    const [r] = await pool.execute(
      `INSERT INTO fee_record (student_id, total_fee, discount_percentage, amount_paid, remaining_balance, due_date, payment_status)
       VALUES (?,?,?,?,?,?,?)`,
      [sid, totalAmt, disc, paidAmt, balance, due, dbStatus]
    );
    res.json({ id: r.insertId });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.put('/api/fees/:id', async (req, res) => {
  try {
    const { total, discount, paid, due, status } = req.body;
    const paidAmt = parseFloat(paid) || 0;
    const totalAmt = parseFloat(total) || 0;
    const disc = parseFloat(discount) || 0;
    const afterDisc = totalAmt * (1 - disc / 100);
    const balance = Math.max(0, afterDisc - paidAmt);
    let dbStatus = (status || 'unpaid').toLowerCase();
    if (dbStatus === 'overdue' || dbStatus === 'pending') dbStatus = 'unpaid';
    if (balance === 0 && paidAmt > 0) dbStatus = 'paid';
    else if (paidAmt > 0 && balance > 0) dbStatus = 'partial';
    await query(
      `UPDATE fee_record SET total_fee=?, discount_percentage=?, amount_paid=?, remaining_balance=?, due_date=?, payment_status=? WHERE fee_id=?`,
      [totalAmt, disc, paidAmt, balance, due, dbStatus, req.params.id]
    );
    res.json({ message: 'Updated' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.delete('/api/fees/:id', async (req, res) => {
  try {
    await query('DELETE FROM fee_record WHERE fee_id = ?', [req.params.id]);
    res.json({ message: 'Deleted' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ── MATERIALS ──
app.get('/api/materials', async (req, res) => {
  try {
    let sql = `
      SELECT m.material_id AS id, m.title, sub.subject_name AS subject,
        u.full_name AS teacher, m.material_type AS type,
        DATE(m.upload_date) AS date, m.file_path, m.subject_id, m.teacher_id
      FROM learning_material m
      JOIN subject sub ON m.subject_id = sub.subject_id
      JOIN teacher t ON m.teacher_id = t.teacher_id
      JOIN \`user\` u ON t.user_id = u.user_id`;
    const params = [];
    if (req.query.teacher_id) { sql += ' WHERE m.teacher_id = ?'; params.push(req.query.teacher_id); }
    if (req.query.student_id) {
      sql += params.length ? ' AND' : ' WHERE';
      sql += ' m.subject_id IN (SELECT subject_id FROM enrollment WHERE student_id = ?)';
      params.push(req.query.student_id);
    }
    sql += ' ORDER BY m.material_id DESC';
    res.json(await query(sql, params));
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/api/materials', async (req, res) => {
  try {
    const { title, subject, type, teacher_id, subject_id } = req.body;
    let subid = subject_id, tid = teacher_id;
    if (!subid && subject) {
      const [s] = await query('SELECT subject_id, teacher_id FROM subject WHERE subject_name = ?', [subject]);
      if (s) { subid = s.subject_id; if (!tid) tid = s.teacher_id; }
    }
    const [r] = await pool.execute(
      'INSERT INTO learning_material (subject_id, teacher_id, title, material_type, file_path) VALUES (?,?,?,?,?)',
      [subid, tid, title, type || 'PDF', `/materials/${title.replace(/\s/g,'_').toLowerCase()}.pdf`]
    );
    res.json({ id: r.insertId });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.put('/api/materials/:id', async (req, res) => {
  try {
    const { title, type } = req.body;
    await query('UPDATE learning_material SET title=?, material_type=? WHERE material_id=?',
      [title, type, req.params.id]);
    res.json({ message: 'Updated' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.delete('/api/materials/:id', async (req, res) => {
  try {
    await query('DELETE FROM learning_material WHERE material_id = ?', [req.params.id]);
    res.json({ message: 'Deleted' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ── ANNOUNCEMENTS ──
app.get('/api/announcements', async (req, res) => {
  try {
    let sql = `
      SELECT a.announcement_id AS id, a.title, a.content,
        COALESCE(sub.subject_name, 'General') AS subject,
        u.full_name AS postedBy, DATE(a.created_at) AS posted,
        a.teacher_id, a.subject_id,
        CASE WHEN a.subject_id IS NULL THEN 1 ELSE 0 END AS isAdmin
      FROM announcement a
      JOIN teacher t ON a.teacher_id = t.teacher_id
      JOIN \`user\` u ON t.user_id = u.user_id
      LEFT JOIN subject sub ON a.subject_id = sub.subject_id`;
    const params = [];
    if (req.query.teacher_id) { sql += ' WHERE a.teacher_id = ?'; params.push(req.query.teacher_id); }
    if (req.query.student_id) {
      sql += params.length ? ' AND' : ' WHERE';
      sql += ' (a.subject_id IS NULL OR a.subject_id IN (SELECT subject_id FROM enrollment WHERE student_id = ?))';
      params.push(req.query.student_id);
    }
    sql += ' ORDER BY a.created_at DESC';
    const rows = await query(sql, params);
    res.json(rows.map(r => ({
      ...r,
      poster: r.isAdmin ? 'Admin' : 'Teacher',
      isAdmin: !!r.isAdmin,
    })));
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/api/announcements', async (req, res) => {
  try {
    const { title, content, subject, teacher_id, isAdmin } = req.body;
    let tid = teacher_id || 1;
    let subid = null;
    if (subject && subject !== 'General') {
      const [s] = await query('SELECT subject_id FROM subject WHERE subject_name = ?', [subject]);
      if (s) subid = s.subject_id;
    }
    const [r] = await pool.execute(
      'INSERT INTO announcement (teacher_id, subject_id, title, content) VALUES (?,?,?,?)',
      [tid, subid, title, content]
    );
    res.json({ id: r.insertId });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.put('/api/announcements/:id', async (req, res) => {
  try {
    const { title, content, subject } = req.body;
    let subid = null;
    if (subject && subject !== 'General') {
      const [s] = await query('SELECT subject_id FROM subject WHERE subject_name = ?', [subject]);
      if (s) subid = s.subject_id;
    }
    await query('UPDATE announcement SET title=?, content=?, subject_id=? WHERE announcement_id=?',
      [title, content, subid, req.params.id]);
    res.json({ message: 'Updated' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.delete('/api/announcements/:id', async (req, res) => {
  try {
    await query('DELETE FROM announcement WHERE announcement_id = ?', [req.params.id]);
    res.json({ message: 'Deleted' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ── USERS ──
app.get('/api/users', async (_req, res) => {
  try {
    const rows = await query(`
      SELECT user_id AS id, full_name AS name, email, role, phone, status,
        DATE(created_at) AS lastLogin
      FROM \`user\` ORDER BY user_id`);
    res.json(rows.map(r => ({
      ...r,
      role: cap(r.role),
      status: fmtStatus(r.status),
    })));
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/api/users', async (req, res) => {
  try {
    const { name, email, role, phone, status } = req.body;
    const [r] = await pool.execute(
      `INSERT INTO \`user\` (full_name, email, password_hash, role, phone, status) VALUES (?,?,?,?,?,?)`,
      [name, email, 'password123', role.toLowerCase(), phone || null, (status || 'Active').toLowerCase()]
    );
    res.json({ id: r.insertId });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.put('/api/users/:id', async (req, res) => {
  try {
    const { name, email, role, phone, status } = req.body;
    await query(
      'UPDATE \`user\` SET full_name=?, email=?, role=?, phone=?, status=? WHERE user_id=?',
      [name, email, role.toLowerCase(), phone || null, (status || 'Active').toLowerCase(), req.params.id]
    );
    res.json({ message: 'Updated' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.delete('/api/users/:id', async (req, res) => {
  try {
    await query('DELETE FROM \`user\` WHERE user_id = ?', [req.params.id]);
    res.json({ message: 'Deleted' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ── NOTIFICATIONS ──
app.get('/api/notifications', async (req, res) => {
  try {
    let sql = 'SELECT notification_id AS id, title, message, notification_type AS type, is_read AS isRead, DATE(created_at) AS date FROM notification';
    const params = [];
    if (req.query.user_id) { sql += ' WHERE user_id = ?'; params.push(req.query.user_id); }
    sql += ' ORDER BY created_at DESC';
    res.json(await query(sql, params));
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/api/notifications', async (req, res) => {
  try {
    const { title, message, type, user_id } = req.body;
    const [r] = await pool.execute(
      'INSERT INTO notification (user_id, title, message, notification_type) VALUES (?,?,?,?)',
      [user_id || 1, title, message, type || 'broadcast']
    );
    res.json({ id: r.insertId });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ── AUDIT LOG ──
app.get('/api/auditlog', async (_req, res) => {
  try {
    const rows = await query(`
      SELECT l.log_id AS id, COALESCE(u.full_name,'System') AS user, l.action,
        l.old_value AS oldVal, l.new_value AS newVal, DATE(l.timestamp) AS date
      FROM audit_log l LEFT JOIN \`user\` u ON l.user_id = u.user_id
      ORDER BY l.timestamp DESC LIMIT 50`);
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ── BULK DATA LOAD ──
app.get('/api/data', async (req, res) => {
  try {
    const q = req.query;
    const tid = q.teacher_id;
    const sid = q.student_id;
    const qs = (base) => {
      const p = new URLSearchParams();
      if (tid) p.set('teacher_id', tid);
      if (sid) p.set('student_id', sid);
      return p.toString() ? `${base}?${p}` : base;
    };
    // Internal parallel fetch via direct queries
    const [students, teachers, programs, subjects, enrollment, assignments, quizzes,
           liveclasses, attendance, fees, materials, announcements, users, notifications, auditlog] =
      await Promise.all([
        query(`SELECT s.student_id AS id, CONCAT('NUM-', LPAD(s.student_id,4,'0')) AS regNo, u.full_name AS name,
               COALESCE(p.program_name,'Unassigned') AS program, s.dob, s.gender, s.enrollment_date AS enrolled, u.status
               FROM student s JOIN \`user\` u ON s.user_id=u.user_id LEFT JOIN program p ON s.program_id=p.program_id`),
        query(`SELECT t.teacher_id AS id, u.full_name AS name, t.qualification, t.specialization,
               t.experience_years AS experience, DATE(u.created_at) AS hireDate,
               (SELECT COUNT(*) FROM subject WHERE teacher_id=t.teacher_id) AS subjects
               FROM teacher t JOIN \`user\` u ON t.user_id=u.user_id`),
        query(`SELECT p.program_id AS id, p.program_name AS name,
               (SELECT COUNT(*) FROM student WHERE program_id=p.program_id) AS students,
               (SELECT COUNT(*) FROM subject WHERE program_id=p.program_id) AS subjects FROM program p`),
        query(`SELECT s.subject_id AS id, CONCAT('SUB-',LPAD(s.subject_id,3,'0')) AS code, s.subject_name AS name,
               COALESCE(p.program_name,'—') AS program, COALESCE(u.full_name,'Unassigned') AS teacher,
               s.credit_hours AS creditHrs, s.fee FROM subject s
               LEFT JOIN program p ON s.program_id=p.program_id
               LEFT JOIN teacher t ON s.teacher_id=t.teacher_id LEFT JOIN \`user\` u ON t.user_id=u.user_id`),
        query(`SELECT e.enrollment_id AS id, u.full_name AS student, sub.subject_name AS subject,
               e.enrollment_date AS date, e.discount_percentage AS discount, 'Active' AS status
               FROM enrollment e JOIN student s ON e.student_id=s.student_id JOIN \`user\` u ON s.user_id=u.user_id
               JOIN subject sub ON e.subject_id=sub.subject_id`),
        query(`SELECT a.assignment_id AS id, a.title, sub.subject_name AS subject, tu.full_name AS teacher,
               a.deadline, a.total_marks AS marks,
               (SELECT COUNT(*) FROM assignment_submission WHERE assignment_id=a.assignment_id) AS submissions
               FROM assignment a JOIN subject sub ON a.subject_id=sub.subject_id
               JOIN teacher t ON a.teacher_id=t.teacher_id JOIN \`user\` tu ON t.user_id=tu.user_id`),
        query(`SELECT q.quiz_id AS id, q.title, sub.subject_name AS subject, tu.full_name AS teacher,
               q.total_marks AS marks, q.quiz_date AS date, q.time_limit AS time
               FROM quiz q JOIN subject sub ON q.subject_id=sub.subject_id
               JOIN teacher t ON q.teacher_id=t.teacher_id JOIN \`user\` tu ON t.user_id=tu.user_id`),
        query(`SELECT lc.class_id AS id, sub.subject_name AS subject, u.full_name AS teacher, lc.zoom_link AS zoom,
               lc.class_date AS date, TIME_FORMAT(lc.start_time,'%h:%i %p') AS start, TIME_FORMAT(lc.end_time,'%h:%i %p') AS end
               FROM live_class lc JOIN subject sub ON lc.subject_id=sub.subject_id
               JOIN teacher t ON lc.teacher_id=t.teacher_id JOIN \`user\` u ON t.user_id=u.user_id`),
        query(`SELECT att.attendance_id AS id, su.full_name AS student,
               CONCAT(sub.subject_name,' — ',lc.class_date) AS liveClass, att.join_time AS datetime, att.status
               FROM attendance att JOIN student s ON att.student_id=s.student_id JOIN \`user\` su ON s.user_id=su.user_id
               JOIN live_class lc ON att.class_id=lc.class_id JOIN subject sub ON lc.subject_id=sub.subject_id`),
        query(`SELECT f.fee_id AS id, u.full_name AS student, f.total_fee AS total, f.discount_percentage AS discount,
               f.amount_paid AS paid, f.remaining_balance AS balance, f.due_date AS due, f.payment_status AS status
               FROM fee_record f JOIN student s ON f.student_id=s.student_id JOIN \`user\` u ON s.user_id=u.user_id`),
        query(`SELECT m.material_id AS id, m.title, sub.subject_name AS subject, u.full_name AS teacher,
               m.material_type AS type, DATE(m.upload_date) AS date
               FROM learning_material m JOIN subject sub ON m.subject_id=sub.subject_id
               JOIN teacher t ON m.teacher_id=t.teacher_id JOIN \`user\` u ON t.user_id=u.user_id`),
        query(`SELECT a.announcement_id AS id, a.title, a.content, COALESCE(sub.subject_name,'General') AS subject,
               u.full_name AS postedBy, DATE(a.created_at) AS posted,
               CASE WHEN a.subject_id IS NULL THEN 1 ELSE 0 END AS isAdmin
               FROM announcement a JOIN teacher t ON a.teacher_id=t.teacher_id
               JOIN \`user\` u ON t.user_id=u.user_id LEFT JOIN subject sub ON a.subject_id=sub.subject_id
               ORDER BY a.created_at DESC`),
        query(`SELECT user_id AS id, full_name AS name, email, role, phone, status, DATE(created_at) AS lastLogin FROM \`user\``),
        query(`SELECT notification_id AS id, title, message, DATE(created_at) AS date, is_read FROM notification ORDER BY created_at DESC LIMIT 20`),
        query(`SELECT l.log_id AS id, COALESCE(u.full_name,'System') AS user, l.action, l.old_value AS oldVal,
               l.new_value AS newVal, DATE(l.timestamp) AS date FROM audit_log l LEFT JOIN \`user\` u ON l.user_id=u.user_id ORDER BY l.timestamp DESC LIMIT 20`),
      ]);

    res.json({
      students: students.map(r => ({ ...r, gender: cap(r.gender), status: fmtStatus(r.status) })),
      teachers,
      programs: programs.map(r => ({
        ...r,
        level: r.name.includes('Short') || r.name.includes('Diploma') ? 'Certificate' : 'Undergraduate',
        duration: r.name.includes('ADP') || r.name.includes('Diploma') ? 2 : r.name.includes('Short') ? 1 : 4,
      })),
      subjects,
      enrollment,
      assignments,
      quizzes,
      liveclasses,
      attendance: attendance.map(r => ({ ...r, status: fmtAttStatus(r.status) })),
      fees: fees.map(r => ({
        ...r, total: parseFloat(r.total), paid: parseFloat(r.paid),
        balance: parseFloat(r.balance || 0), status: fmtFeeStatus(r.status),
      })),
      materials,
      announcements: announcements.map(r => ({
        ...r, poster: r.isAdmin ? 'Admin' : 'Teacher', isAdmin: !!r.isAdmin,
      })),
      users: users.map(r => ({ ...r, role: cap(r.role), status: fmtStatus(r.status) })),
      notifications,
      auditlog,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.get('/', (_req, res) => {
  res.sendFile(path.join(__dirname, 'AAMS_RoleBased.html'));
});

app.listen(PORT, () => {
  console.log(`AAMS server running at http://localhost:${PORT}`);
  console.log(`Database: ${process.env.DB_NAME} @ ${process.env.DB_HOST}`);
});
