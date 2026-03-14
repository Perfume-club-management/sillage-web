#!/bin/sh
set -eu

python - <<'PY'
import os
import time
from sqlalchemy import create_engine, text

database_url = os.environ["DATABASE_URL"]

for attempt in range(30):
    try:
        engine = create_engine(database_url, pool_pre_ping=True)
        with engine.connect() as connection:
            connection.execute(text("SELECT 1"))
        print("Database is ready.")
        break
    except Exception as exc:
        if attempt == 29:
            raise
        print(f"Waiting for database... ({attempt + 1}/30) {exc}")
        time.sleep(2)
PY

alembic upgrade head
python -m app.db.seeds
exec uvicorn app.main:app --host 0.0.0.0 --port 8000
