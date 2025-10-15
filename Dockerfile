# Use official Node.js LTS image
FROM node:18-alpine AS base

WORKDIR /app
COPY package*.json ./

# Install only production dependencies
RUN npm ci --omit=dev

COPY . .

EXPOSE 8080

# Use non-root user for security
RUN addgroup -S app && adduser -S app -G app
USER app

CMD ["node", "src/server.js"]
