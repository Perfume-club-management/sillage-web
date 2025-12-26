FROM ghcr.io/cirruslabs/flutter:stable
WORKDIR /app

# Install dependencies only (source code will be mounted)
COPY pubspec.yaml pubspec.lock* ./
RUN flutter pub get

# App code will be mounted as volume in docker-compose.yml

EXPOSE 80

CMD ["flutter", "run", "-d", "web-server", "--web-port=80", "--web-hostname=0.0.0.0"]
