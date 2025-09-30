# Multi-stage build for smaller final image
FROM node:18-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev
COPY . .

FROM node:18-alpine
ENV NODE_ENV=production
WORKDIR /app
COPY --from=build /app /app
EXPOSE 4000
# Healthcheck (basic TCP)
HEALTHCHECK --interval=30s --timeout=5s --retries=3 CMD nc -z localhost 4000 || exit 1
CMD ["npm","start"]