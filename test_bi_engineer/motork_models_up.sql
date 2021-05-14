CREATE TABLE IF NOT EXISTS "sales" (
  "id" SERIAL PRIMARY KEY,
  "user_id" INT,
  "customer_id" INT,
  "invoice_id" INT,
  "sales_details" VARCHAR,
  "revenue" FLOAT,
  "vat" FLOAT,
  "created_at" DATETIME DEFAULT (now()),
  "updated_at" DATETIME DEFAULT (now()),
  FOREIGN KEY ("customer_id") REFERENCES "contacts" ("id")
);

CREATE TABLE IF NOT EXISTS "user_info" (
  "id" SERIAL PRIMARY KEY,
  "first_name" VARCHAR,
  "last_name" VARCHAR,
  "created_at" DATETIME DEFAULT (now()),
  "updated_at" DATETIME DEFAULT (now()),
  FOREIGN KEY ("id") REFERENCES "sales" ("user_id")
);

CREATE TABLE IF NOT EXISTS "contacts" (
  "id" SERIAL PRIMARY KEY,
  "first_name" VARCHAR,
  "last_name" VARCHAR,
  "phone" VARCHAR,
  "email" VARCHAR,
  "created_from" VARCHAR,
  "last_contact_date" DATETIME,
  "created_at" DATETIME DEFAULT (now()),
  "updated_at" DATETIME DEFAULT (now()),
  FOREIGN KEY ("id") REFERENCES "leads" ("customer_id"),
  FOREIGN KEY ("id") REFERENCES "customers" ("id")
);

CREATE TABLE IF NOT EXISTS "invoices" (
  "id" SERIAL PRIMARY KEY,
  "customer_id" INT,
  "revenue" FLOAT,
  "vat" FLOAT,
  "created_at" DATETIME DEFAULT (now()),
  "updated_at" DATETIME DEFAULT (now()),
  FOREIGN KEY ("id") REFERENCES "sales" ("invoice_id"),
  FOREIGN KEY ("id") REFERENCES "invoice_line_items" ("invoice_id"),
  FOREIGN KEY ("created_at") REFERENCES "inventory" ("last_sales_date"),
  FOREIGN KEY ("customer_id") REFERENCES "customers" ("id")
);

CREATE TABLE IF NOT EXISTS "invoice_line_items" (
  "id" SERIAL PRIMARY KEY,
  "invoice_id" INT,
  "line_item_name" VARCHAR,
  "line_item_details" VARCHAR,
  "revenue" FLOAT,
  "vat" FLOAT,
  "created_at" DATETIME DEFAULT (now()),
  "updated_at" DATETIME DEFAULT (now())
);

CREATE TABLE IF NOT EXISTS "inventory" (
  "id" SERIAL PRIMARY KEY,
  "brand" VARCHAR,
  "model" VARCHAR,
  "options" VARCHAR,
  "first_availability_date" DATETIME,
  "last_sales_date" DATETIME,
  "type" FLOAT,
  "status" VARCHAR,
  "base_price" FLOAT,
  "created_at" DATETIME DEFAULT (now()),
  "updated_at" DATETIME DEFAULT (now()),
  FOREIGN KEY ("id") REFERENCES "vehicles" ("vehicle_model_id")
);

CREATE TABLE IF NOT EXISTS "vehicles" (
  "id" SERIAL PRIMARY KEY,
  "vehicle_model_id" INT NOT NULL,
  "brand" VARCHAR,
  "model" VARCHAR,
  "vehicle_status" VARCHAR,
  "created_at" DATETIME DEFAULT (now()),
  "updated_at" DATETIME DEFAULT (now()),
  FOREIGN KEY ("id") REFERENCES "vehicle_optionals" ("vehicle_id")
);

CREATE TABLE IF NOT EXISTS "vehicle_optionals" (
  "id" SERIAL PRIMARY KEY,
  "vehicle_id" INT NOT NULL,
  "optional_type" VARCHAR,
  "optional_price" VARCHAR,
  "currency" VARCHAR NOT NULL,
  "created_at" DATETIME DEFAULT (now()),
  "updated_at" DATETIME DEFAULT (now())
);

CREATE TABLE IF NOT EXISTS "leads" (
  "id" SERIAL PRIMARY KEY,
  "customer_id" INT,
  "first_name" VARCHAR,
  "last_name" VARCHAR,
  "phone" VARCHAR,
  "email" VARCHAR,
  "source" VARCHAR,
  "stage" VARCHAR,
  "output" BOOLEAN,
  "created_at" DATETIME DEFAULT (now()),
  "updated_at" DATETIME DEFAULT (now()),
  FOREIGN KEY ("customer_id") REFERENCES "tasks" ("customer_id")
);

CREATE TABLE IF NOT EXISTS "tasks" (
  "id" INT,
  "customer_id" INT,
  "type" VARCHAR,
  "planned_time" DATETIME,
  "done_time" DATETIME,
  "output" BOOLEAN,
  "note" VARCHAR,
  "created_at" DATETIME DEFAULT (now()),
  "updated_at" DATETIME DEFAULT (now()),
  FOREIGN KEY ("customer_id") REFERENCES "customers" ("id")
);

CREATE TABLE IF NOT EXISTS "customers" (
  "id" INT,
  "company_id" INT,
  "first_name" VARCHAR,
  "last_name" VARCHAR,
  "phone" VARCHAR,
  "email" VARCHAR,
  "source" VARCHAR,
  "company_name" VARCHAR,
  "vat_code" VARCHAR,
  "last_contact_date" DATETIME,
  "last_purchase_date" DATETIME,
  "number of purchases" INT,
  "total_revenue" FLOAT,
  "created_at" DATETIME DEFAULT (now()),
  "updated_at" DATETIME DEFAULT (now())
);

CREATE TABLE IF NOT EXISTS "companies" (
  "id" INT,
  "company_name" VARCHAR,
  "vat_code" VARCHAR,
  "created_at" DATETIME DEFAULT (now()),
  "updated_at" DATETIME DEFAULT (now()),
  FOREIGN KEY ("id") REFERENCES "customers" ("company_id")
);
