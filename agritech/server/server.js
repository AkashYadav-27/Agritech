require('dotenv').config();

const express = require('express');
const cors = require('cors');
const morgan = require('morgan');

const connectDB = require('./config/db');
const seed = require('./config/seed');

const {
  notFound,
  errorHandler
} = require('./middleware/error');

const app = express();

// Middleware
app.use(cors());
app.use(express.json({ limit: '1mb' }));
app.use(morgan('dev'));

// Health check
app.get('/api/health', (req, res) => {
  res.json({ ok: true });
});

// API routes
app.use('/api/auth', require('./routes/auth'));
app.use('/api/farms', require('./routes/farms'));
app.use('/api/crops', require('./routes/crops'));
app.use('/api/soil', require('./routes/soil'));
app.use('/api/weather', require('./routes/weather'));
app.use('/api/alerts', require('./routes/alerts'));
app.use('/api/resources', require('./routes/resources'));
app.use('/api/orders', require('./routes/orders'));
app.use('/api/consultations', require('./routes/consultations'));
app.use('/api/forum', require('./routes/forum'));
app.use('/api/admin', require('./routes/admin'));

// Error handling
app.use(notFound);
app.use(errorHandler);

// Export Express app for Vercel
module.exports = app;

// Start server only when running locally
if (require.main === module) {
  const PORT = process.env.PORT || 5000;

  connectDB()
    .then(() => {
      if (process.env.NODE_ENV !== 'production') {
        return seed();
      }
    })
    .then(() => {
      app.listen(PORT, () => {
        console.log(
          `AgriTech API running on http://localhost:${PORT}`
        );
      });
    })
    .catch((error) => {
      console.error('Startup failed:', error);
      process.exit(1);
    });
}