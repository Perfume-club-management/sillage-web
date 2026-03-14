FROM ghcr.io/cirruslabs/flutter:stable AS builder
WORKDIR /app

ARG PUBLIC_API_BASE_URL=http://localhost:8080/api
ARG USE_MOCK_AUTH=true

COPY pubspec.yaml pubspec.lock* ./

COPY . .
RUN flutter clean && flutter pub get
RUN flutter build web --release --no-wasm-dry-run --dart-define=API_BASE_URL=${PUBLIC_API_BASE_URL} --dart-define=USE_MOCK_AUTH=${USE_MOCK_AUTH}

FROM nginx:1.27-alpine
COPY --from=builder /app/build/web /usr/share/nginx/html
EXPOSE 80
