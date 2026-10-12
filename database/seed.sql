BEGIN;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

DO $$
BEGIN
  CREATE TYPE user_role AS ENUM ('employee', 'manager', 'admin');
EXCEPTION
  WHEN duplicate_object THEN NULL;
END
$$;

CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  first_name TEXT,
  last_name TEXT,
  email TEXT NOT NULL UNIQUE,
  phone_number TEXT,
  role user_role NOT NULL DEFAULT 'employee',
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS auth (
  user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  password TEXT NOT NULL,
  refresh_token TEXT,
  refresh_token_expires_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS teams (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  manager_id UUID NOT NULL REFERENCES users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS team_members (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  team_id UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE (team_id, user_id)
);

CREATE TABLE IF NOT EXISTS "time" (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  departure TIMESTAMPTZ NOT NULL,
  arrival TIMESTAMPTZ NOT NULL,
  CHECK (departure >= arrival)
);

INSERT INTO users (id, first_name, last_name, phone_number, email, role)
VALUES
  ('11111111-1111-4111-8111-111111111111', 'Alice', 'Martin', '+33601020304', 'alice.martin@example.com', 'admin'),
  ('22222222-2222-4222-8222-222222222222', 'Thomas', 'Bernard', '+33611223344', 'thomas.bernard@example.com', 'manager'),
  ('33333333-3333-4333-8333-333333333333', 'Sophie', 'Petit', '+33622334455', 'sophie.petit@example.com', 'employee'),
  ('44444444-4444-4444-8444-444444444444', 'Lucas', 'Robert', '+33633445566', 'lucas.robert@example.com', 'employee')
ON CONFLICT (id) DO NOTHING;

-- Development-only bcrypt hash for: password
INSERT INTO auth (user_id, password)
VALUES
  ('11111111-1111-4111-8111-111111111111', '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy'),
  ('22222222-2222-4222-8222-222222222222', '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy'),
  ('33333333-3333-4333-8333-333333333333', '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy'),
  ('44444444-4444-4444-8444-444444444444', '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy')
ON CONFLICT (user_id) DO NOTHING;

INSERT INTO teams (id, name, description, manager_id)
VALUES
  ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', 'Platform', 'API and infrastructure team', '22222222-2222-4222-8222-222222222222'),
  ('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb', 'Operations', 'Day-to-day operations team', '22222222-2222-4222-8222-222222222222')
ON CONFLICT (id) DO NOTHING;

INSERT INTO team_members (id, team_id, user_id)
VALUES
  ('aaaaaaa1-aaaa-4aaa-8aaa-aaaaaaaaaaa1', 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', '22222222-2222-4222-8222-222222222222'),
  ('aaaaaaa2-aaaa-4aaa-8aaa-aaaaaaaaaaa2', 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', '33333333-3333-4333-8333-333333333333'),
  ('aaaaaaa3-aaaa-4aaa-8aaa-aaaaaaaaaaa3', 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', '44444444-4444-4444-8444-444444444444'),
  ('bbbbbbb1-bbbb-4bbb-8bbb-bbbbbbbbbbb1', 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb', '22222222-2222-4222-8222-222222222222'),
  ('bbbbbbb2-bbbb-4bbb-8bbb-bbbbbbbbbbb2', 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb', '33333333-3333-4333-8333-333333333333')
ON CONFLICT (id) DO NOTHING;

INSERT INTO "time" (id, user_id, departure, arrival)
VALUES
  ('eeeeeee1-eeee-4eee-8eee-eeeeeeeeeee1', '33333333-3333-4333-8333-333333333333', '2026-10-08 17:30:00+02', '2026-10-08 09:00:00+02'),
  ('eeeeeee2-eeee-4eee-8eee-eeeeeeeeeee2', '44444444-4444-4444-8444-444444444444', '2026-10-08 18:00:00+02', '2026-10-08 09:15:00+02'),
  ('eeeeeee3-eeee-4eee-8eee-eeeeeeeeeee3', '33333333-3333-4333-8333-333333333333', '2026-10-09 17:45:00+02', '2026-10-09 08:45:00+02')
ON CONFLICT (id) DO NOTHING;

COMMIT;
