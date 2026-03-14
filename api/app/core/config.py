from __future__ import annotations

from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", extra="ignore")

    api_env: str = "development"
    database_url: str = "postgresql://clubuser:change_me@db:5432/clubdb"
    seed_admin_email: str = "admin@sillage.local"
    seed_admin_password: str = "admin1234!"
    seed_admin_name: str = "System Administrator"


@lru_cache
def get_settings() -> Settings:
    return Settings()
