const mongoose = require('mongoose');
const path = require('path');
const fs = require('fs');

module.exports = async function connectDB() {
  const uri = process.env.MONGO_URI || 'mongodb://127.0.0.1:27017/agritech';
  try {
    await mongoose.connect(uri, { serverSelectionTimeoutMS: 4000 });
    console.log('MongoDB connected:', uri.replace(/\/\/.*@/, '//***@'));
  } catch (e) {
    console.log('MongoDB not reachable (' + e.message + ').');
    console.log('Starting embedded MongoDB (first run downloads the binary, please wait)...');
    const { MongoMemoryServer } = require('mongodb-memory-server');
    const dbPath = path.join(__dirname, '..', 'data', 'mongo');
    fs.mkdirSync(dbPath, { recursive: true });
    const mongod = await MongoMemoryServer.create({
      instance: { dbPath, storageEngine: 'wiredTiger', port: 27018 },
    });
    await mongoose.connect(mongod.getUri('agritech'));
    console.log('Embedded MongoDB connected. Data stored in', dbPath);
  }
};
