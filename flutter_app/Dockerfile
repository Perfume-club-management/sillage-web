FROM ghcr.io/cirruslabs/flutter:stable AS builder
WORKDIR /app

COPY pubspec.yaml pubspec.lock* ./

RUN flutter clean && flutter pub get
# RUN flutter build web --release --no-wasm-dry-run

COPY . .
RUN flutter build web --release

FROM nginx:1.27-alpine
COPY --from=builder /app/build/web /usr/share/nginx/html
EXPOSE 80
