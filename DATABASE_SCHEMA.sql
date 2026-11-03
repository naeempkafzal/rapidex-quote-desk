create table if not exists users (
  id uuid primary key default gen_random_uuid(),
  email text unique not null,
  full_name text,
  role text not null check (role in ('admin','manager','staff')),
  created_at timestamptz default now()
);

create table if not exists customers (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  company text,
  email text,
  phone text,
  whatsapp text,
  created_at timestamptz default now()
);

create table if not exists leads (
  id uuid primary key default gen_random_uuid(),
  reference_number text unique not null,
  customer_id uuid references customers(id),
  assigned_to uuid references users(id),
  status text not null default 'New',
  priority text not null default 'Medium',
  priority_reason text,
  source text default 'Website Quote Form',
  pickup_location text,
  destination text,
  shipment_type text,
  product_category text,
  pieces int,
  actual_weight numeric,
  length numeric,
  width numeric,
  height numeric,
  service_preference text,
  required_by date,
  insurance_required boolean default false,
  special_notes text,
  next_action text,
  next_follow_up_at timestamptz,
  estimated_value numeric,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists lead_status_history (
  id uuid primary key default gen_random_uuid(),
  lead_id uuid references leads(id) on delete cascade,
  previous_status text,
  new_status text not null,
  reason text,
  next_action text,
  next_follow_up_at timestamptz,
  changed_by uuid references users(id),
  created_at timestamptz default now()
);

create table if not exists lead_notes (
  id uuid primary key default gen_random_uuid(),
  lead_id uuid references leads(id) on delete cascade,
  author_id uuid references users(id),
  note text not null,
  is_internal boolean default true,
  created_at timestamptz default now()
);

create table if not exists quotes (
  id uuid primary key default gen_random_uuid(),
  lead_id uuid references leads(id) on delete cascade,
  status text not null default 'Draft',
  service_type text,
  chargeable_weight numeric,
  base_freight numeric,
  surcharges numeric,
  margin numeric,
  final_price numeric,
  currency text default 'PKR',
  valid_until date,
  requires_manual_review boolean default false,
  calculation_breakdown jsonb,
  created_at timestamptz default now()
);

create table if not exists rate_cards (
  id uuid primary key default gen_random_uuid(),
  carrier text,
  service_type text,
  origin_zone text,
  destination_zone text,
  weight_min numeric,
  weight_max numeric,
  base_rate numeric,
  minimum_charge numeric,
  margin_percent numeric,
  valid_from date,
  valid_until date,
  active boolean default true
);

create table if not exists tasks (
  id uuid primary key default gen_random_uuid(),
  lead_id uuid references leads(id) on delete cascade,
  assigned_to uuid references users(id),
  title text not null,
  description text,
  due_at timestamptz,
  status text default 'Open',
  created_at timestamptz default now()
);

create table if not exists ai_recommendations (
  id uuid primary key default gen_random_uuid(),
  lead_id uuid references leads(id) on delete cascade,
  priority text,
  priority_score int,
  reason text,
  recommended_action text,
  recommended_follow_up_at timestamptz,
  draft_channel text,
  draft_message text,
  risk_flags jsonb,
  confidence numeric,
  approval_status text default 'Pending',
  created_at timestamptz default now()
);

create table if not exists messages (
  id uuid primary key default gen_random_uuid(),
  lead_id uuid references leads(id) on delete cascade,
  channel text not null,
  direction text not null,
  status text default 'Queued',
  subject text,
  body text not null,
  sent_by uuid references users(id),
  created_at timestamptz default now()
);

create table if not exists audit_logs (
  id uuid primary key default gen_random_uuid(),
  actor_id uuid references users(id),
  action text not null,
  entity text not null,
  entity_id uuid,
  metadata jsonb,
  created_at timestamptz default now()
);
