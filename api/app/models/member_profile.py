from __future__ import annotations

import uuid
from datetime import date

from sqlalchemy import CheckConstraint, Date, ForeignKey, String
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.models.base import Base


class MemberProfile(Base):
    __tablename__ = "member_profiles"
    __table_args__ = (
        CheckConstraint(
            "member_status in ('active', 'leave_requested', 'inactive', 'alumni')",
            name="member_profiles_status",
        ),
    )

    user_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), primary_key=True)
    student_no: Mapped[str | None] = mapped_column(String(30))
    department: Mapped[str | None] = mapped_column(String(100))
    phone: Mapped[str | None] = mapped_column(String(30))
    join_date: Mapped[date | None] = mapped_column(Date)
    leave_date: Mapped[date | None] = mapped_column(Date)
    member_status: Mapped[str] = mapped_column(String(20), default="active", server_default="active", nullable=False)

    user = relationship("User", back_populates="member_profile")
