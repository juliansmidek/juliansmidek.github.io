CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  first_name VARCHAR,
  last_name VARCHAR,
  created_at DATETIME DEFAULT (now()),
  updated_at DATETIME DEFAULT (now())
);

CREATE TABLE IF NOT EXISTS leads (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL,
  first_name VARCHAR,
  last_name VARCHAR,
  phone VARCHAR,
  email VARCHAR,
  lead_source INT,
  request_start_date DATETIME,
  request_end_date DATETIME,
  created_at DATETIME DEFAULT (now()),
  updated_at DATETIME DEFAULT (now()),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (lead_source) REFERENCES lead_sources(id)
);

CREATE TABLE IF NOT EXISTS opportunities (
  id SERIAL PRIMARY KEY,
  lead_id INT,
  user_id INT,
  stage INT,
  output boolean,
  note VARCHAR,
  created_at DATETIME DEFAULT (now()),
  updated_at DATETIME DEFAULT (now()),
  FOREIGN KEY (lead_id) REFERENCES leads(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (stage) REFERENCES opportunity_stages(id)
);

CREATE TABLE IF NOT EXISTS offers (
  id SERIAL PRIMARY KEY,
  opportunity_id INT NOT NULL,
  vehicle_id INT NOT NULL,
  no_vehicles INT,
  price float,
  currency VARCHAR NOT NULL,
  created_at DATETIME DEFAULT (now()),
  updated_at DATETIME DEFAULT (now()),
  FOREIGN KEY (opportunity_id) REFERENCES opportunities(id),
  FOREIGN KEY (vehicle_id) REFERENCES vehicles(id),
  FOREIGN KEY (currency) REFERENCES exchange_rates(base)
);

CREATE TABLE IF NOT EXISTS vehicles (
  id SERIAL PRIMARY KEY,
  vehicle_model_id INT NOT NULL,
  brand VARCHAR,
  model VARCHAR,
  vehicle_status VARCHAR,
  created_at DATETIME DEFAULT (now()),
  updated_at DATETIME DEFAULT (now())
);

CREATE TABLE IF NOT EXISTS vehicle_optionals (
  id SERIAL PRIMARY KEY,
  vehicle_id INT NOT NULL,
  optional_type VARCHAR,
  optional_price VARCHAR,
  currency VARCHAR NOT NULL,
  created_at DATETIME DEFAULT (now()),
  updated_at DATETIME DEFAULT (now()),
  FOREIGN KEY (vehicle_id) REFERENCES vehicles(id),
  FOREIGN KEY (currency) REFERENCES exchange_rates(base)
);

CREATE TABLE IF NOT EXISTS contacts (
  id SERIAL PRIMARY KEY,
  lead_id INT,
  opportunity_id INT,
  first_name VARCHAR,
  last_name VARCHAR,
  phone VARCHAR,
  email VARCHAR,
  created_from VARCHAR,
  last_contact_date DATETIME,
  created_at DATETIME DEFAULT (now()),
  updated_at DATETIME DEFAULT (now()),
  FOREIGN KEY (lead_id) REFERENCES leads (id),
  FOREIGN KEY (opportunity_id) REFERENCES opportunities (id)
);

CREATE TABLE IF NOT EXISTS accounts (
  id SERIAL PRIMARY KEY,
  contact_id INT NOT NULL,
  organization_name VARCHAR,
  vat_code VARCHAR,
  created_at DATETIME DEFAULT (now()),
  updated_at DATETIME DEFAULT (now()),
  FOREIGN KEY (contact_id) REFERENCES contacts (id)
);

CREATE TABLE IF NOT EXISTS tasks (
  id SERIAL PRIMARY KEY,
  user_id INT,
  lead_id INT,
  opportunity_id INT,
  type INT,
  planned_time DATETIME,
  done_time DATETIME,
  output VARCHAR,
  note VARCHAR,
  created_at DATETIME DEFAULT (now()),
  updated_at DATETIME DEFAULT (now()),
  FOREIGN KEY (user_id) REFERENCES users (id),
  FOREIGN KEY (lead_id) REFERENCES leads (id),
  FOREIGN KEY (opportunity_id) REFERENCES opportunities (id),
  FOREIGN KEY (type) REFERENCES task_types (id)
);

CREATE TABLE IF NOT EXISTS lead_sources (
  id SERIAL PRIMARY KEY,
  lead_source VARCHAR,
  created_at DATETIME DEFAULT (now()),
  updated_at DATETIME DEFAULT (now())
);

CREATE TABLE IF NOT EXISTS opportunity_stages (
  id SERIAL PRIMARY KEY,
  stage VARCHAR,
  created_at DATETIME DEFAULT (now()),
  updated_at DATETIME DEFAULT (now())
);

CREATE TABLE IF NOT EXISTS exchange_rates (
  id SERIAL PRIMARY KEY,
  base VARCHAR,
  currency VARCHAR,
  rate float,
  date DATETIME
);

CREATE TABLE IF NOT EXISTS task_types (
  id SERIAL PRIMARY KEY,
  task_name VARCHAR,
  created_at DATETIME DEFAULT (now()),
  updated_at DATETIME DEFAULT (now())
);

COMMENT ON TABLE users IS 'an application user (i.e. a salesperson using the CRM). User can have associated
zero or more leads and zero or more activities';

COMMENT ON TABLE leads IS 'an incoming request for quote for a car';

COMMENT ON TABLE opportunities IS 'the lead has been contacted and an interest for a vehicle is confirmed. This
object store the fact that the opportunity has been won (car sold) or not (lost opportunity).
The opportunity is generated from a lead or might be inserted directly';

COMMENT ON TABLE offers IS 'an offer has been made for this opportunity. Multiple offers can be made for the same
opportunity';

COMMENT ON TABLE vehicles IS 'a car in stock or new';

COMMENT ON TABLE vehicle_optionals IS 'an object representing optionals connected to a car. For example if a
specific car has two optionals, there will be two objects connected to this vehicle.';

COMMENT ON TABLE contacts IS 'when a lead is transformed into an opportunity, or when the opportunity has been
created directly, a contact is created';

COMMENT ON TABLE accounts IS 'an organizational entity connected (optionally) to a contact. For example in case of
sales made to a company rather than an individual';

COMMENT ON TABLE tasks IS 'an action connected to a user an opportunity. Might be a call, a store visit, a
recall, an SMS. It has a planned date time (when in the future it has to be done) and a done
date time (when it has been done).';