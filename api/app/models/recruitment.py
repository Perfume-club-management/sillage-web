from __future__ import annotations

import uuid
from datetime import datetime
from decimal import Decimal

from sqlalchemy import BigInteger, CheckConstraint, DateTime, ForeignKey, Identity, Numeric, String, Text, func
from sqlalchemy.dialects.postgresql import JSONB, UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.models.base import Base


class RecruitmentPost(Base):
    __tablename__ = "recruitment_posts"
    __table_args__ = (
        CheckConstraint(
            "status in ('draft', 'open', 'closed', 'archived')",
            name="recruitment_posts_status",
        ),
    )

    id: Mapped[int] = mapped_column(BigInteger, Identity(), primary_key=True)
    title: Mapped[str] = mapped_column(String(200), nullable=False)
    description: Mapped[str] = mapped_column(Text, nullable=False)
    status: Mapped[str] = mapped_column(String(20), default="draft", server_default="draft", nullable=False, index=True)
    opened_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    closed_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    created_by: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="RESTRICT"), nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), nullable=False)

    applications = relationship("Application", back_populates="recruitment_post", cascade="all, delete-orphan")


class Application(Base):
    __tablename__ = "applications"
    __table_args__ = (
        CheckConstraint(
            "status in ('submitted', 'screening', 'interview', 'accepted', 'rejected', 'cancelled')",
            name="applications_status",
        ),
    )

    id: Mapped[int] = mapped_column(BigInteger, Identity(), primary_key=True)
    recruitment_post_id: Mapped[int] = mapped_column(BigInteger, ForeignKey("recruitment_posts.id", ondelete="CASCADE"), nullable=False)
    applicant_name: Mapped[str] = mapped_column(String(100), nullable=False)
    applicant_email: Mapped[str] = mapped_column(String(255), nullable=False)
    applicant_phone: Mapped[str | None] = mapped_column(String(30))
    answers: Mapped[dict] = mapped_column(JSONB, default=dict, server_default="{}", nullable=False)
    status: Mapped[str] = mapped_column(String(30), default="submitted", server_default="submitted", nullable=False, index=True)
    submitted_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), nullable=False)

    recruitment_post = relationship("RecruitmentPost", back_populates="applications")
    reviews = relationship("ApplicationReview", back_populates="application", cascade="all, delete-orphan")


class ApplicationReview(Base):
    __tablename__ = "application_reviews"

    id: Mapped[int] = mapped_column(BigInteger, Identity(), primary_key=True)
    application_id: Mapped[int] = mapped_column(BigInteger, ForeignKey("applications.id", ondelete="CASCADE"), nullable=False)
    reviewer_user_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="RESTRICT"), nullable=False)
    stage: Mapped[str] = mapped_column(String(30), nullable=False)
    result: Mapped[str | None] = mapped_column(String(30))
    score: Mapped[Decimal | None] = mapped_column(Numeric(5, 2))
    comment: Mapped[str | None] = mapped_column(Text)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), nullable=False)

    application = relationship("Application", back_populates="reviews")
