require('dotenv').config();
const express = require('express');
const cors = require('cors');
const morgan = require('morgan');
const connectDB = require('./config/db');
const seed = require('./config/seed');
const { notFound, errorHandler } = require('./middleware/error');

const app = express();
app.use(cors());
app.use(express.json({ limit: '1mb' }));
app.use(morgan('dev'));

app.get('/api/health', (req, res) => res.json({ ok: true }));
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

app.use(notFound);
app.use(errorHandler);

const PORT = process.env.PORT || 5000;
connectDB()
  .then(seed)
  .then(() => app.listen(PORT, () => console.log(`AgriTech API running on http://localhost:${PORT}`)))
  .catch((e) => {
    console.error('Startup failed:', e);
    process.exit(1);
  });
