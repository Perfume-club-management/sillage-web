# Project Progress Report

## Test Account

Current seeded administrator account:

- Email: `admin@sillage.local`
- Password: `admin1234!`
- Name: `System Administrator`
- Role: `admin`

Notes:

- This account is created automatically during API container startup.
- The account is inserted into PostgreSQL and linked to the `admin` role.
- Seed settings can be changed with:
  - `SEED_ADMIN_EMAIL`
  - `SEED_ADMIN_PASSWORD`
  - `SEED_ADMIN_NAME`

---

## 1. Project Overview

This project is a Docker Compose based multi-service application.

Current services:

- `db`: PostgreSQL 16
- `api`: FastAPI
- `web`: React + Vite
- `flutter_web`: Flutter Web
- `nginx`: reverse proxy

Service flow:

- External requests enter through `nginx`
- `/api` routes to FastAPI
- `/` routes to React web
- `/app` style frontend structure is implemented in Flutter Web
- PostgreSQL is used as the core persistent storage

---

## 2. Infrastructure and Runtime

The Docker startup flow was improved so the backend can initialize reliably.

Completed:

- Added PostgreSQL healthcheck in `docker-compose.yml`
- Changed API startup to wait until DB is ready
- Added automatic Alembic migration on API container startup
- Added automatic base data seeding on API container startup

Important files:

- [docker-compose.yml](G:\project\Pers\01%20web\sillage-web\docker-compose.yml)
- [api/Dockerfile](G:\project\Pers\01%20web\sillage-web\api\Dockerfile)
- [api/docker-entrypoint.sh](G:\project\Pers\01%20web\sillage-web\api\docker-entrypoint.sh)

Current verified status:

- Docker containers build successfully
- Compose stack starts successfully
- API health endpoint returns DB status correctly

---

## 3. PostgreSQL Design and Schema

A first production-oriented schema draft was implemented in code and migration form.

Implemented domains:

- Auth and roles
- Member profiles
- Notices
- Calendar / events
- Recruitment
- Finance ledger
- Attachments
- Audit logs

Created database tables:

- `roles`
- `users`
- `user_roles`
- `member_profiles`
- `notices`
- `notice_reads`
- `events`
- `event_participants`
- `recruitment_posts`
- `applications`
- `application_reviews`
- `ledger_entries`
- `attachments`
- `audit_logs`

Important files:

- [api/alembic/versions/20260315_0001_initial_schema.py](G:\project\Pers\01%20web\sillage-web\api\alembic\versions\20260315_0001_initial_schema.py)
- [api/app/db/base.py](G:\project\Pers\01%20web\sillage-web\api\app\db\base.py)
- [api/app/models/user.py](G:\project\Pers\01%20web\sillage-web\api\app\models\user.py)
- [api/app/models/recruitment.py](G:\project\Pers\01%20web\sillage-web\api\app\models\recruitment.py)
- [api/app/models/ledger_entry.py](G:\project\Pers\01%20web\sillage-web\api\app\models\ledger_entry.py)

Current state:

- Initial schema migration is applied successfully
- Base roles are seeded successfully
- Administrator test account is seeded successfully

---

## 4. API Progress

The backend was expanded from a minimal health-only FastAPI app into a DB-aware service base.

Completed:

- Added settings management
- Added SQLAlchemy engine and session setup
- Added Alembic integration
- Added DB-aware `/health` endpoint
- Added password hashing utility for seeded accounts
- Added seed runner for roles and admin account

Important files:

- [api/app/main.py](G:\project\Pers\01%20web\sillage-web\api\app\main.py)
- [api/app/api/routes/health.py](G:\project\Pers\01%20web\sillage-web\api\app\api\routes\health.py)
- [api/app/core/config.py](G:\project\Pers\01%20web\sillage-web\api\app\core\config.py)
- [api/app/core/security.py](G:\project\Pers\01%20web\sillage-web\api\app\core\security.py)
- [api/app/db/seeds.py](G:\project\Pers\01%20web\sillage-web\api\app\db\seeds.py)

Current limitation:

- Business CRUD APIs are not yet fully implemented
- Login API is not yet connected to real DB authentication flow

---

## 5. Flutter App Progress

Flutter Web now has a much stronger application structure than the initial mock state.

Completed:

- Refactored auth contract from token-only shape to restorable session model
- Added mock and remote repository separation
- Added persistent session restore logic
- Added initialization state to auth flow
- Added role-based routing guard
- Added shared app shell and navigation
- Added main section pages for flow-based navigation

Important files:

- [flutter_app/lib/features/auth/application/auth_controller.dart](G:\project\Pers\01%20web\sillage-web\flutter_app\lib\features\auth\application\auth_controller.dart)
- [flutter_app/lib/features/auth/application/auth_state.dart](G:\project\Pers\01%20web\sillage-web\flutter_app\lib\features\auth\application\auth_state.dart)
- [flutter_app/lib/features/auth/data/auth_repository_provider.dart](G:\project\Pers\01%20web\sillage-web\flutter_app\lib\features\auth\data\auth_repository_provider.dart)
- [flutter_app/lib/app/router.dart](G:\project\Pers\01%20web\sillage-web\flutter_app\lib\app\router.dart)
- [flutter_app/lib/app/app_shell.dart](G:\project\Pers\01%20web\sillage-web\flutter_app\lib\app\app_shell.dart)
- [flutter_app/lib/features/home/presentation/pages.dart](G:\project\Pers\01%20web\sillage-web\flutter_app\lib\features\home\presentation\pages.dart)

---

## 6. Home Screen and Routing

The home screen was reorganized based on the provided flow visualization and reference image.

Implemented home behavior:

- Card-based home layout
- Role badge and summary area
- Quick-action widgets
- Operational section widgets
- Flow-linked page list
- Widget tap routes to subpages

Connected section pages:

- Dashboard / Home
- Notices
- Calendar
- Recruitment
- Club Operations
- Members
- Activities
- Inventory
- Finance
- My Page

Routing notes:

- Users are redirected from login to the correct default page by role
- Access to restricted pages is blocked by role-aware route checks

---

## 7. React Web Status

React is still present in the Compose stack and builds successfully, but it remains mostly template-level.

Current state:

- Build pipeline works
- Served through nginx
- Business UI is not yet implemented

Important file:

- [web/src/App.jsx](G:\project\Pers\01%20web\sillage-web\web\src\App.jsx)

---

## 8. Verified Results

Verified during execution:

- Docker Compose build succeeds
- Flutter Web build succeeds
- API container starts successfully
- PostgreSQL migration runs successfully
- Base roles are inserted successfully
- Administrator account is inserted successfully
- API health check returns:
  - `status: ok`
  - `database: ok`

---

## 9. Current Project Status

The project is now in a usable foundation stage.

What is ready:

- Containerized runtime
- PostgreSQL schema foundation
- Automatic migration and seeding
- Administrator test account
- Role-based Flutter routing
- Flow-based home screen and section pages

What remains as the next major work:

- Real authentication API
- User login from Flutter against DB-backed API
- CRUD APIs for notices, members, recruitment, events, finance, and inventory
- Real data binding on Flutter pages

---

## 10. Recommended Next Steps

Recommended implementation order:

1. Implement `auth/login` API using the seeded admin account and password verification
2. Connect Flutter login to real FastAPI auth
3. Implement notices list/detail/create API and bind the notices page
4. Implement members API and bind the members page
5. Implement recruitment and events APIs
6. Implement finance and inventory CRUD with audit logging

