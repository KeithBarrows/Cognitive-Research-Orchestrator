CREATE TABLE brains (
  id                text PRIMARY KEY,
  name              text NOT NULL,
  included_in_index boolean NOT NULL,
  last_synced_at    timestamptz,
  is_private_home   boolean NOT NULL DEFAULT false
);

CREATE TABLE thebrain_types (
  id                       text PRIMARY KEY,
  source_brain_id          text NOT NULL REFERENCES brains(id),
  name                     text NOT NULL,
  last_synced_at           timestamptz,
  staleness_threshold_days int
);

CREATE TABLE sensitivity_tiers (
  id          text PRIMARY KEY,
  description text NOT NULL
);

CREATE TABLE thebrain_nodes (
  id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  source_id           text NOT NULL,
  source_brain_id     text NOT NULL REFERENCES brains(id),
  title               text NOT NULL,
  category_type_id    text REFERENCES thebrain_types(id),
  sensitivity_tier_id text NOT NULL DEFAULT 'standard'
                      REFERENCES sensitivity_tiers(id),
  access_type         int,
  updated_at          timestamptz,
  UNIQUE (source_brain_id, source_id)
);

CREATE TABLE ob1_nodes (
  id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  source_id           text NOT NULL UNIQUE,
  title               text NOT NULL,
  category            text,
  sensitivity_tier_id text NOT NULL DEFAULT 'standard'
                      REFERENCES sensitivity_tiers(id),
  updated_at          timestamptz
);

CREATE TABLE plane_workitems (
  id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  source_id           text NOT NULL UNIQUE,
  identifier          text,
  title               text NOT NULL,
  body                text,
  status              text,
  category            text,
  tags                text[],
  start_date          date,
  end_date            date,
  sensitivity_tier_id text NOT NULL DEFAULT 'standard'
                      REFERENCES sensitivity_tiers(id),
  updated_at          timestamptz
);

CREATE TABLE node_links (
  from_type         text NOT NULL,
  from_id           uuid NOT NULL,
  to_type           text NOT NULL,
  to_id             uuid NOT NULL,
  link_type         text NOT NULL,
  confirmed_by_user boolean NOT NULL DEFAULT false,
  detection_method  text,
  similarity_score  double precision,
  created_at        timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (from_type, from_id, to_type, to_id, link_type)
);

CREATE TABLE node_flags (
  node_type        text NOT NULL,
  node_id          uuid NOT NULL,
  flag_type        text NOT NULL,
  detail           text,
  reviewed_by_user boolean NOT NULL DEFAULT false,
  detected_at      timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (node_type, node_id, flag_type)
);

CREATE TABLE chunks (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  node_type   text NOT NULL,
  node_id     uuid NOT NULL,
  chunk_index int NOT NULL,
  text        text NOT NULL,
  embedding   vector(384) NOT NULL,
  created_at  timestamptz NOT NULL DEFAULT now(),
  UNIQUE (node_type, node_id, chunk_index)
);

CREATE TABLE edges (
  from_type    text NOT NULL,
  from_id      uuid NOT NULL,
  to_type      text NOT NULL,
  to_id        uuid NOT NULL,
  relationship text NOT NULL,
  source       text NOT NULL,
  created_at   timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (from_type, from_id, to_type, to_id, relationship)
);

CREATE TABLE sync_state (
  source         text PRIMARY KEY,
  is_synced      boolean NOT NULL DEFAULT false,
  last_synced_at timestamptz
);
