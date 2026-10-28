  AgriTech - Smart Farming Management System (MERN)
=================================================

QUICK START (Windows 10/11)
---------------------------
 1. Double-click  00_INSTALL_PREREQUISITES.bat   (once; installs Node.js + MongoDB; asks for admin)
 2. Double-click  01_SETUP.bat                   (once; installs project packages)
 3. Double-click  02_RUN.bat                     (every time; starts backend + frontend, opens browser)
 4. Double-click  03_STOP.bat                    (optional; stops everything)

The app opens at http://localhost:5173  (API on http://localhost:5000)

DEMO LOGINS (created automatically on first run)
  Admin : admin@agritech.com  / Admin@123
  Farmer: farmer@agritech.com / Farmer@123

DATABASE
  The server first tries MONGO_URI from server/.env (default: local MongoDB).
  If no MongoDB is running it automatically starts an embedded MongoDB and stores the
  data in server/data/mongo, so the app always runs. To use MongoDB Atlas, paste your
  connection string into MONGO_URI in server/.env.

FEATURES (all 7 modules from the brief)
  - Register / login (JWT, bcrypt-hashed passwords, farmer and admin roles)
  - Farm profiles (auto-geocoded from village/state) - full CRUD
  - Crop monitoring - full CRUD with status, dates, yield, notes
  - Soil health analysis - enter pH/N/P/K/moisture/organic matter, get a score + advice
  - Weather forecast (Open-Meteo, no API key) + automatic pest / crop-risk advisories
  - Pest alerts - admin publishes, farmers read
  - Resource shop - cart, stock check, orders, order tracking, cancel pending orders
  - Expert consultation - farmers ask, admin replies, resolve
  - Community forum - posts and comments
  - Admin dashboard - stats, users and roles, orders, catalogue, pest alerts
  - Multilingual UI: English, Hindi, Tamil (language switcher in the navbar)
  - Charts (Recharts), responsive Bootstrap 5 layout, lazy-loaded pages (code splitting)

PROJECT LAYOUT
  server/   Express API
    config/       db connection (+ embedded fallback), demo-data seed
    middleware/   JWT auth + role guard, error handling
    models/       User, Farm, Crop, Soil, WeatherData, PestAlert, Resource, Order, Consultation, Post
    routes/       one file per module (mounted under /api)
    utils/        generic CRUD factory, soil analysis rules, geocoding
  client/   React (Vite) single-page app
    src/pages/    Dashboard, Farms, Crops, Soil, Weather, Alerts, Shop, Consult, Forum, Admin, Auth
    src/components/  Navbar, generic CrudPage

API OVERVIEW  (all except /auth/login and /auth/register need  Authorization: Bearer <token>)
  POST /api/auth/register | POST /api/auth/login | GET /api/auth/me
  GET/POST/PUT/DELETE  /api/farms  /api/crops  /api/soil        (owner-scoped)
  GET /api/weather?farmId=ID  or  ?lat=..&lon=..      GET /api/weather/geocode?q=Pune
  GET /api/alerts  /api/resources                      (write = admin only)
  GET/POST /api/orders    PATCH /api/orders/:id/status
  GET/POST /api/consultations    POST /api/consultations/:id/reply
  GET/POST /api/forum     POST /api/forum/:id/comments
  GET /api/admin/stats  /api/admin/users              (admin only)
  Import these into Postman to test.

NOTES ON TECHNOLOGY CHOICES
  - Vite is used instead of Create React App (CRA is deprecated and slow); it is still React.
  - bcryptjs is used instead of bcrypt: same hashing, but no native build tools needed on Windows.

TROUBLESHOOTING
  - "Node.js was not found": run 00_INSTALL_PREREQUISITES.bat, then open a new window.
  - First launch is slow: the embedded MongoDB downloads once (about 100 MB) during setup.
  - Port in use: change PORT in server/.env and the proxy target in client/vite.config.js.
  - Reset all data: stop the app, delete server/data (embedded DB) or drop the "agritech" database.
