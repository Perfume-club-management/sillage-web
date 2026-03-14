from __future__ import annotations

from sqlalchemy import select

from app.db.base import Base  # noqa: F401
from app.core.config import get_settings
from app.core.security import hash_password
from app.db.session import SessionLocal
from app.models.role import Role
from app.models.user import User
from app.models.user_role import UserRole


BASE_ROLES = (
    {
        "code": "admin",
        "name": "Administrator",
        "description": "Full system administration access.",
    },
    {
        "code": "officer",
        "name": "Officer",
        "description": "Club executive and operational management access.",
    },
    {
        "code": "member",
        "name": "Member",
        "description": "General club member access.",
    },
)


def seed_base_data() -> None:
    settings = get_settings()

    with SessionLocal() as session:
        existing_codes = {
            code
            for code in session.scalars(select(Role.code))
        }

        for role_data in BASE_ROLES:
            if role_data["code"] in existing_codes:
                continue
            session.add(Role(**role_data))

        session.commit()

        admin_role = session.scalar(select(Role).where(Role.code == "admin"))
        admin_user = session.scalar(select(User).where(User.email == settings.seed_admin_email))

        if admin_user is None:
            admin_user = User(
                email=settings.seed_admin_email,
                password_hash=hash_password(settings.seed_admin_password),
                name=settings.seed_admin_name,
                status="active",
            )
            session.add(admin_user)
            session.flush()

        existing_admin_link = session.scalar(
            select(UserRole).where(
                UserRole.user_id == admin_user.id,
                UserRole.role_id == admin_role.id,
            )
        )
        if existing_admin_link is None:
            session.add(
                UserRole(
                    user_id=admin_user.id,
                    role_id=admin_role.id,
                )
            )

        session.commit()


if __name__ == "__main__":
    seed_base_data()
