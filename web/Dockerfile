# Build stage
FROM node:20-alpine AS builder
WORKDIR /app

ARG PUBLIC_API_BASE_URL
ENV VITE_PUBLIC_API_BASE_URL=${PUBLIC_API_BASE_URL}

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# Run stage
FROM nginx:1.27-alpine
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
