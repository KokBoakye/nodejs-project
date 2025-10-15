const express = require("express");
const morgan = require("morgan");
const helmet = require("helmet");
const healthRoute = require("./routes/health");
const { sanitizeInput } = require("./utils/validator");

const app = express();

// Security & parsing middleware
app.use(express.json());
app.use(helmet());
app.use(morgan("dev"));

// Sanitize all incoming input
app.use((req, res, next) => {
    if (req.body) {
        for (const key in req.body) {
            req.body[key] = sanitizeInput(req.body[key]);
        }
    }
    next();
});

// Routes
app.use("/health", healthRoute);

app.get("/", (req, res) => {
    res.json({ message: "Welcome to the Secure Node App 🔐" });
});

// Example vulnerable endpoint (for DAST demo)
app.get("/echo", (req, res) => {
    const { msg } = req.query;
    res.send(`Echo: ${msg || "nothing"}`); // ZAP will test this for XSS
});

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));

module.exports = app;
