# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a perfume club management platform built with a microservices architecture consisting of:
- **FastAPI backend** (`api/`) - Python REST API
- **Flutter frontend** (`flutter_app/`) - Cross-platform web/mobile application
- **Nginx reverse proxy** (`nginx/`) - Routes traffic to API and Flutter web app
- **PostgreSQL database** - Data persistence

The project uses Docker Compose for local development and Docker Swarm for production deployment.

## Architecture

### Service Communication
- Nginx listens on port 8080 (configurable via `NGINX_PORT`)
- API requests are proxied to `/api/` → FastAPI service (port 8000)
- Flutter web app is proxied to `/app/` → Flutter web service (port 80)
- All services communicate via the `club_network` Docker network
- Database connection string: `postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@db:5432/${POSTGRES_DB}`

### Environment Configuration
Configuration is managed through `.env` file (see `.env.example` for template):
- Database credentials and port
- API configuration (port, environment, JWT secret, CORS origins)
- Web/Flutter base URLs
- Nginx port

## Development Commands

### Local Development (Docker Compose)
```bash
# Start all services
docker compose up -d

# Build and start specific service
docker compose up --build api
docker compose up --build flutter_web

# View logs
docker compose logs -f api
docker compose logs -f flutter_web

# Stop all services
docker compose down
```

### FastAPI (api/)
```bash
# Run API directly (without Docker)
cd api
pip install -r requirements.txt
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload

# The API main entrypoint is api/app/main.py
```

### Flutter (flutter_app/)
```bash
# Install dependencies
cd flutter_app
flutter pub get

# Run in development mode
flutter run -d chrome

# Build for web
flutter build web --release --no-wasm-dry-run

# Run tests
flutter test

# Run analyzer
flutter analyze
```

### Production Deployment (Docker Swarm)
```bash
# Deploy stack
docker stack deploy -c docker-stack.yml club-platform

# Remove stack
docker stack rm club-platform

# Note: Requires external network 'club_network' to exist
docker network create --driver overlay club_network
```

## Project Structure

- `api/app/main.py` - FastAPI application entrypoint (currently minimal with health endpoint)
- `api/requirements.txt` - Python dependencies (FastAPI, Uvicorn, Pydantic, psycopg2-binary)
- `flutter_app/lib/main.dart` - Flutter application entrypoint
- `flutter_app/pubspec.yaml` - Flutter dependencies and project configuration
- `nginx/nginx.conf` - Nginx routing configuration for API and Flutter web app
- `docker-compose.yml` - Local development orchestration
- `docker-stack.yml` - Production Docker Swarm deployment configuration
- `.env.example` - Template for environment variables

## Key Technical Details

- FastAPI runs on Python 3.12-slim
- Flutter uses the stable channel and targets SDK ^3.10.4
- PostgreSQL 16 is used for the database
- Nginx 1.27-alpine serves as reverse proxy
- Docker Swarm deployment includes replica scaling (API: 2, Flutter: 2, Nginx: 1)
- Environment: `API_ENV` controls FastAPI environment (development/production)
