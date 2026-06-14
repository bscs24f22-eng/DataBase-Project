/**
 * Database setup helper for AAMS
 * Run: node setup-db.js [mysql_root_password]
 */
require('dotenv').config();
const mysql = require('mysql2/promise');
const fs = require('fs');
const path = require('path');

const DB_NAME = process.env.DB_NAME || 'aak_academy';
const DB_USER = process.env.DB_USER || 'aak_academy';
const DB_PASSWORD = process.env.DB_PASSWORD || 'Namal.123';

async function execFile(conn, filePath) {
  let sql = fs.readFileSync(filePath, 'utf8');
  sql = sql.replace(/^COMMIT;?\s*$/gim, '');
  await conn.query(sql);
}

async function main() {
  const rootPassword = process.argv[2] || process.env.MYSQL_ROOT_PASSWORD || '';
  console.log('Connecting as root...');

  const rootConn = await mysql.createConnection({
    host: process.env.DB_HOST || 'localhost',
    user: 'root',
    password: rootPassword,
    multipleStatements: true,
  }).catch(err => {
    console.error('Root connection failed:', err.message);
    console.log('\nRun: node setup-db.js YOUR_ROOT_PASSWORD');
    process.exit(1);
  });

  try {
    await rootConn.query(`CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\``);
    await rootConn.query(`DROP USER IF EXISTS '${DB_USER}'@'localhost'`);
    await rootConn.query(`CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY ?`, [DB_PASSWORD]);
    await rootConn.query(`GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'localhost'`);
    await rootConn.query('FLUSH PRIVILEGES');
    await rootConn.query(`USE \`${DB_NAME}\``);

    const ddl = path.join(__dirname, 'dbDDL.sql');
    const dml = path.join(__dirname, 'dbDML.sql');

    console.log('Running dbDDL.sql...');
    await execFile(rootConn, ddl);

    console.log('Running dbDML.sql...');
    await execFile(rootConn, dml);

    const [tables] = await rootConn.query('SHOW TABLES');
    console.log(`\nSetup complete — ${tables.length} tables created.`);
    console.log('Start app: npm start');
    console.log('Open: http://localhost:3000');
  } finally {
    await rootConn.end();
  }
}

main().catch(err => {
  console.error('Setup failed:', err.message);
  process.exit(1);
});
