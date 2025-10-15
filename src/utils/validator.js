const validator = require("validator");

function sanitizeInput(value) {
    if (typeof value !== "string") return value;
    return validator.escape(validator.trim(value));
}

module.exports = { sanitizeInput };
