FROM ghcr.io/cirruslabs/flutter:stable AS builder
WORKDIR /app

ARG PUBLIC_API_BASE_URL
ENV PUBLIC_API_BASE_URL=${PUBLIC_API_BASE_URL}

COPY pubspec.yaml pubspec.lock* ./
RUN flutter pub get

COPY . .

# Flutter Web 빌드 (앱에서 API URL을 env/const로 읽도록 구현 권장)
RUN flutter build web --release

FROM nginx:1.27-alpine
COPY --from=builder /app/build/web /usr/share/nginx/html
EXPOSE 80
