from __future__ import annotations

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql


revision = "20260315_0001"
down_revision = None
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.create_table(
        "roles",
        sa.Column("id", sa.BigInteger(), sa.Identity(always=False), primary_key=True),
        sa.Column("code", sa.String(length=30), nullable=False),
        sa.Column("name", sa.String(length=50), nullable=False),
        sa.Column("description", sa.String(length=255), nullable=True),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.text("now()"), nullable=False),
        sa.UniqueConstraint("code", name="uq_roles_code"),
    )

    op.create_table(
        "users",
        sa.Column("id", postgresql.UUID(as_uuid=True), primary_key=True, nullable=False),
        sa.Column("email", sa.String(length=255), nullable=False),
        sa.Column("password_hash", sa.Text(), nullable=False),
        sa.Column("name", sa.String(length=100), nullable=False),
        sa.Column("status", sa.String(length=20), server_default="active", nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.text("now()"), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), server_default=sa.text("now()"), nullable=False),
        sa.UniqueConstraint("email", name="uq_users_email"),
    )
    op.create_check_constraint(
        "ck_users_status",
        "users",
        "status in ('pending', 'active', 'inactive', 'graduated', 'withdrawn')",
    )

    op.create_table(
        "user_roles",
        sa.Column("id", sa.BigInteger(), sa.Identity(always=False), primary_key=True),
        sa.Column("user_id", postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column("role_id", sa.BigInteger(), nullable=False),
        sa.Column("assigned_at", sa.DateTime(timezone=True), server_default=sa.text("now()"), nullable=False),
        sa.ForeignKeyConstraint(["role_id"], ["roles.id"], ondelete="RESTRICT"),
        sa.ForeignKeyConstraint(["user_id"], ["users.id"], ondelete="CASCADE"),
        sa.UniqueConstraint("user_id", "role_id", name="uq_user_roles_user_role"),
    )

    op.create_table(
        "member_profiles",
        sa.Column("user_id", postgresql.UUID(as_uuid=True), primary_key=True, nullable=False),
        sa.Column("student_no", sa.String(length=30), nullable=True),
        sa.Column("department", sa.String(length=100), nullable=True),
        sa.Column("phone", sa.String(length=30), nullable=True),
        sa.Column("join_date", sa.Date(), nullable=True),
        sa.Column("leave_date", sa.Date(), nullable=True),
        sa.Column("member_status", sa.String(length=20), server_default="active", nullable=False),
        sa.ForeignKeyConstraint(["user_id"], ["users.id"], ondelete="CASCADE"),
    )
    op.create_check_constraint(
        "ck_member_profiles_status",
        "member_profiles",
        "member_status in ('active', 'leave_requested', 'inactive', 'alumni')",
    )

    op.create_table(
        "notices",
        sa.Column("id", sa.BigInteger(), sa.Identity(always=False), primary_key=True),
        sa.Column("title", sa.String(length=200), nullable=False),
        sa.Column("body", sa.Text(), nullable=False),
        sa.Column("author_user_id", postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column("is_pinned", sa.Boolean(), server_default=sa.text("false"), nullable=False),
        sa.Column("published_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.text("now()"), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), server_default=sa.text("now()"), nullable=False),
        sa.ForeignKeyConstraint(["author_user_id"], ["users.id"], ondelete="RESTRICT"),
    )

    op.create_table(
        "notice_reads",
        sa.Column("notice_id", sa.BigInteger(), nullable=False),
        sa.Column("user_id", postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column("read_at", sa.DateTime(timezone=True), server_default=sa.text("now()"), nullable=False),
        sa.ForeignKeyConstraint(["notice_id"], ["notices.id"], ondelete="CASCADE"),
        sa.ForeignKeyConstraint(["user_id"], ["users.id"], ondelete="CASCADE"),
        sa.PrimaryKeyConstraint("notice_id", "user_id", name="pk_notice_reads"),
    )

    op.create_table(
        "events",
        sa.Column("id", sa.BigInteger(), sa.Identity(always=False), primary_key=True),
        sa.Column("title", sa.String(length=200), nullable=False),
        sa.Column("category", sa.String(length=50), nullable=False),
        sa.Column("description", sa.Text(), nullable=True),
        sa.Column("starts_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("ends_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("location", sa.String(length=200), nullable=True),
        sa.Column("created_by", postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.text("now()"), nullable=False),
        sa.ForeignKeyConstraint(["created_by"], ["users.id"], ondelete="RESTRICT"),
    )

    op.create_table(
        "event_participants",
        sa.Column("event_id", sa.BigInteger(), nullable=False),
        sa.Column("user_id", postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column("attendance_status", sa.String(length=20), server_default="planned", nullable=False),
        sa.ForeignKeyConstraint(["event_id"], ["events.id"], ondelete="CASCADE"),
        sa.ForeignKeyConstraint(["user_id"], ["users.id"], ondelete="CASCADE"),
        sa.PrimaryKeyConstraint("event_id", "user_id", name="pk_event_participants"),
    )
    op.create_check_constraint(
        "ck_event_participants_attendance_status",
        "event_participants",
        "attendance_status in ('planned', 'attended', 'absent', 'cancelled')",
    )

    op.create_table(
        "recruitment_posts",
        sa.Column("id", sa.BigInteger(), sa.Identity(always=False), primary_key=True),
        sa.Column("title", sa.String(length=200), nullable=False),
        sa.Column("description", sa.Text(), nullable=False),
        sa.Column("status", sa.String(length=20), server_default="draft", nullable=False),
        sa.Column("opened_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("closed_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("created_by", postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.text("now()"), nullable=False),
        sa.ForeignKeyConstraint(["created_by"], ["users.id"], ondelete="RESTRICT"),
    )
    op.create_check_constraint(
        "ck_recruitment_posts_status",
        "recruitment_posts",
        "status in ('draft', 'open', 'closed', 'archived')",
    )

    op.create_table(
        "applications",
        sa.Column("id", sa.BigInteger(), sa.Identity(always=False), primary_key=True),
        sa.Column("recruitment_post_id", sa.BigInteger(), nullable=False),
        sa.Column("applicant_name", sa.String(length=100), nullable=False),
        sa.Column("applicant_email", sa.String(length=255), nullable=False),
        sa.Column("applicant_phone", sa.String(length=30), nullable=True),
        sa.Column("answers", postgresql.JSONB(astext_type=sa.Text()), server_default=sa.text("'{}'::jsonb"), nullable=False),
        sa.Column("status", sa.String(length=30), server_default="submitted", nullable=False),
        sa.Column("submitted_at", sa.DateTime(timezone=True), server_default=sa.text("now()"), nullable=False),
        sa.ForeignKeyConstraint(["recruitment_post_id"], ["recruitment_posts.id"], ondelete="CASCADE"),
    )
    op.create_check_constraint(
        "ck_applications_status",
        "applications",
        "status in ('submitted', 'screening', 'interview', 'accepted', 'rejected', 'cancelled')",
    )

    op.create_table(
        "application_reviews",
        sa.Column("id", sa.BigInteger(), sa.Identity(always=False), primary_key=True),
        sa.Column("application_id", sa.BigInteger(), nullable=False),
        sa.Column("reviewer_user_id", postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column("stage", sa.String(length=30), nullable=False),
        sa.Column("result", sa.String(length=30), nullable=True),
        sa.Column("score", sa.Numeric(5, 2), nullable=True),
        sa.Column("comment", sa.Text(), nullable=True),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.text("now()"), nullable=False),
        sa.ForeignKeyConstraint(["application_id"], ["applications.id"], ondelete="CASCADE"),
        sa.ForeignKeyConstraint(["reviewer_user_id"], ["users.id"], ondelete="RESTRICT"),
    )

    op.create_table(
        "ledger_entries",
        sa.Column("id", sa.BigInteger(), sa.Identity(always=False), primary_key=True),
        sa.Column("entry_type", sa.String(length=10), nullable=False),
        sa.Column("category", sa.String(length=50), nullable=False),
        sa.Column("amount", sa.Numeric(12, 2), nullable=False),
        sa.Column("description", sa.Text(), nullable=True),
        sa.Column("event_id", sa.BigInteger(), nullable=True),
        sa.Column("created_by", postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column("approved_by", postgresql.UUID(as_uuid=True), nullable=True),
        sa.Column("occurred_on", sa.Date(), nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.text("now()"), nullable=False),
        sa.ForeignKeyConstraint(["approved_by"], ["users.id"], ondelete="SET NULL"),
        sa.ForeignKeyConstraint(["created_by"], ["users.id"], ondelete="RESTRICT"),
        sa.ForeignKeyConstraint(["event_id"], ["events.id"], ondelete="SET NULL"),
    )
    op.create_check_constraint("ck_ledger_entries_entry_type", "ledger_entries", "entry_type in ('income', 'expense')")
    op.create_check_constraint("ck_ledger_entries_amount", "ledger_entries", "amount >= 0")

    op.create_table(
        "attachments",
        sa.Column("id", sa.BigInteger(), sa.Identity(always=False), primary_key=True),
        sa.Column("owner_type", sa.String(length=30), nullable=False),
        sa.Column("owner_id", sa.BigInteger(), nullable=False),
        sa.Column("original_name", sa.String(length=255), nullable=False),
        sa.Column("stored_path", sa.Text(), nullable=False),
        sa.Column("mime_type", sa.String(length=100), nullable=True),
        sa.Column("size_bytes", sa.BigInteger(), nullable=True),
        sa.Column("uploaded_by", postgresql.UUID(as_uuid=True), nullable=True),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.text("now()"), nullable=False),
        sa.ForeignKeyConstraint(["uploaded_by"], ["users.id"], ondelete="SET NULL"),
    )

    op.create_table(
        "audit_logs",
        sa.Column("id", sa.BigInteger(), sa.Identity(always=False), primary_key=True),
        sa.Column("actor_user_id", postgresql.UUID(as_uuid=True), nullable=True),
        sa.Column("action", sa.String(length=100), nullable=False),
        sa.Column("target_type", sa.String(length=50), nullable=False),
        sa.Column("target_id", sa.String(length=100), nullable=False),
        sa.Column("payload", postgresql.JSONB(astext_type=sa.Text()), server_default=sa.text("'{}'::jsonb"), nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.text("now()"), nullable=False),
        sa.ForeignKeyConstraint(["actor_user_id"], ["users.id"], ondelete="SET NULL"),
    )

    op.create_index("ix_notices_published_at", "notices", ["published_at"])
    op.create_index("ix_events_starts_at", "events", ["starts_at"])
    op.create_index("ix_recruitment_posts_status", "recruitment_posts", ["status"])
    op.create_index("ix_applications_status", "applications", ["status"])
    op.create_index("ix_ledger_entries_occurred_on", "ledger_entries", ["occurred_on"])
    op.create_index("ix_audit_logs_created_at", "audit_logs", ["created_at"])


def downgrade() -> None:
    op.drop_index("ix_audit_logs_created_at", table_name="audit_logs")
    op.drop_index("ix_ledger_entries_occurred_on", table_name="ledger_entries")
    op.drop_index("ix_applications_status", table_name="applications")
    op.drop_index("ix_recruitment_posts_status", table_name="recruitment_posts")
    op.drop_index("ix_events_starts_at", table_name="events")
    op.drop_index("ix_notices_published_at", table_name="notices")
    op.drop_table("audit_logs")
    op.drop_table("attachments")
    op.drop_constraint("ck_ledger_entries_amount", "ledger_entries", type_="check")
    op.drop_constraint("ck_ledger_entries_entry_type", "ledger_entries", type_="check")
    op.drop_table("ledger_entries")
    op.drop_table("application_reviews")
    op.drop_constraint("ck_applications_status", "applications", type_="check")
    op.drop_table("applications")
    op.drop_constraint("ck_recruitment_posts_status", "recruitment_posts", type_="check")
    op.drop_table("recruitment_posts")
    op.drop_constraint("ck_event_participants_attendance_status", "event_participants", type_="check")
    op.drop_table("event_participants")
    op.drop_table("events")
    op.drop_table("notice_reads")
    op.drop_table("notices")
    op.drop_constraint("ck_member_profiles_status", "member_profiles", type_="check")
    op.drop_table("member_profiles")
    op.drop_table("user_roles")
    op.drop_constraint("ck_users_status", "users", type_="check")
    op.drop_table("users")
    op.drop_table("roles")
