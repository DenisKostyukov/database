const { Client } = require('pg');
const User = require('./User');
const Phone = require('./Phone')
const config = require('../configs/db.json');

const dbClient = new Client(config);

User._client = dbClient;
Phone._client = dbClient;
module.exports = {
  User,
  Phone,
  client: dbClient,
};