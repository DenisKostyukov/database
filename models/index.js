const { Client } = require('pg');
const User = require('./User');

const config = {
  user: 'postgres',
  password: 'denxbr23',
  host: 'localhost',
  port: 5432,
  database: 'main_database',
};

const dbClient = new Client(config);

User._client = dbClient;

module.exports = {
  User,
  client: dbClient,
};