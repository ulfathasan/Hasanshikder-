/*
# Create SP Tuprhasan Online Shop Database Schema

## Overview
This migration creates the complete database for the SP Tuprhasan Online Shop e-commerce platform.
It replaces the previous localStorage-based data storage with persistent Supabase tables.
This is a single-tenant app (no user sign-in), so all policies allow anon + authenticated access.

## New Tables

1. **products** - Stores all shop products with full details
   - id (text, primary key) - Product identifier like "prod-01"
   - name (text) - Product name
   - category (text) - Category name
   - price (numeric) - Price in BDT
   - image (text) - Main image URL
   - gallery (text[]) - Array of additional image URLs
   - description (text) - Product description
   - specs (jsonb) - Array of {key, val} specification objects
   - sizes (text[]) - Available sizes
   - colors (jsonb) - Array of {name, hex} color objects
   - variations (text[]) - Design/style variations
   - button_label (text) - Buy Now button text
   - button_url (text) - External Buy Now redirect URL
   - is_flash (boolean) - Show in flash sale display
   - stock (integer) - Stock quantity
   - rating (numeric) - Average rating (0-5)
   - reviews_count (integer) - Number of reviews
   - created_at (timestamptz)

2. **orders** - Customer orders with full details
   - id (uuid, primary key)
   - order_id (text, unique) - Human-readable order ID like "SP-123456"
   - customer_name (text)
   - phone (text)
   - email (text)
   - address (text)
   - delivery_area (text) - "ঢাকার ভিতরে" or "ঢাকার বাইরে"
   - delivery_charge (numeric)
   - subtotal (numeric)
   - discount (numeric)
   - total (numeric)
   - payment_method (text)
   - trx_id (text) - Payment transaction ID
   - status (text) - Pending, Confirmed, Shipped, Delivered, Cancelled
   - items (jsonb) - Array of cart items
   - created_at (timestamptz)

3. **reviews** - Customer product reviews
   - id (uuid, primary key)
   - prod_id (text) - References products.id
   - name (text) - Reviewer name
   - rating (integer) - 1-5 stars
   - comment (text)
   - created_at (timestamptz)

4. **coupons** - Discount coupon codes
   - id (uuid, primary key)
   - code (text, unique) - Coupon code
   - discount (numeric) - Discount amount in BDT
   - created_at (timestamptz)

5. **settings** - Shop configuration (single row)
   - id (integer, primary key, always 1)
   - delivery_inside_dhaka (numeric) - Delivery charge inside Dhaka
   - delivery_outside_dhaka (numeric) - Delivery charge outside Dhaka
   - bkash_number (text) - bKash payment number
   - nagad_number (text) - Nagad payment number

## Security
- RLS enabled on all tables.
- All policies use `TO anon, authenticated` since this is a no-sign-in single-tenant app.
- All data is intentionally public/shared (products, orders, reviews, coupons, settings).
*/

-- ==================== PRODUCTS TABLE ====================
CREATE TABLE IF NOT EXISTS products (
  id text PRIMARY KEY,
  name text NOT NULL,
  category text NOT NULL,
  price numeric NOT NULL DEFAULT 0,
  image text,
  gallery text[] DEFAULT '{}',
  description text,
  specs jsonb DEFAULT '[]',
  sizes text[] DEFAULT '{}',
  colors jsonb DEFAULT '[]',
  variations text[] DEFAULT '{}',
  button_label text DEFAULT 'Buy Now',
  button_url text,
  is_flash boolean NOT NULL DEFAULT false,
  stock integer NOT NULL DEFAULT 0,
  rating numeric DEFAULT 4.8,
  reviews_count integer DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE products ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_select_products" ON products;
CREATE POLICY "anon_select_products" ON products FOR SELECT
  TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "anon_insert_products" ON products;
CREATE POLICY "anon_insert_products" ON products FOR INSERT
  TO anon, authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "anon_update_products" ON products;
CREATE POLICY "anon_update_products" ON products FOR UPDATE
  TO anon, authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "anon_delete_products" ON products;
CREATE POLICY "anon_delete_products" ON products FOR DELETE
  TO anon, authenticated USING (true);

-- ==================== ORDERS TABLE ====================
CREATE TABLE IF NOT EXISTS orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id text UNIQUE NOT NULL,
  customer_name text NOT NULL,
  phone text NOT NULL,
  email text DEFAULT '',
  address text NOT NULL,
  delivery_area text,
  delivery_charge numeric DEFAULT 0,
  subtotal numeric DEFAULT 0,
  discount numeric DEFAULT 0,
  total numeric DEFAULT 0,
  payment_method text DEFAULT 'COD',
  trx_id text DEFAULT '',
  status text NOT NULL DEFAULT 'Pending',
  items jsonb DEFAULT '[]',
  created_at timestamptz DEFAULT now()
);

ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_select_orders" ON orders;
CREATE POLICY "anon_select_orders" ON orders FOR SELECT
  TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "anon_insert_orders" ON orders;
CREATE POLICY "anon_insert_orders" ON orders FOR INSERT
  TO anon, authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "anon_update_orders" ON orders;
CREATE POLICY "anon_update_orders" ON orders FOR UPDATE
  TO anon, authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "anon_delete_orders" ON orders;
CREATE POLICY "anon_delete_orders" ON orders FOR DELETE
  TO anon, authenticated USING (true);

-- ==================== REVIEWS TABLE ====================
CREATE TABLE IF NOT EXISTS reviews (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  prod_id text NOT NULL,
  name text NOT NULL,
  rating integer NOT NULL DEFAULT 5,
  comment text,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_select_reviews" ON reviews;
CREATE POLICY "anon_select_reviews" ON reviews FOR SELECT
  TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "anon_insert_reviews" ON reviews;
CREATE POLICY "anon_insert_reviews" ON reviews FOR INSERT
  TO anon, authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "anon_update_reviews" ON reviews;
CREATE POLICY "anon_update_reviews" ON reviews FOR UPDATE
  TO anon, authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "anon_delete_reviews" ON reviews;
CREATE POLICY "anon_delete_reviews" ON reviews FOR DELETE
  TO anon, authenticated USING (true);

-- ==================== COUPONS TABLE ====================
CREATE TABLE IF NOT EXISTS coupons (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code text UNIQUE NOT NULL,
  discount numeric NOT NULL DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE coupons ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_select_coupons" ON coupons;
CREATE POLICY "anon_select_coupons" ON coupons FOR SELECT
  TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "anon_insert_coupons" ON coupons;
CREATE POLICY "anon_insert_coupons" ON coupons FOR INSERT
  TO anon, authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "anon_update_coupons" ON coupons;
CREATE POLICY "anon_update_coupons" ON coupons FOR UPDATE
  TO anon, authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "anon_delete_coupons" ON coupons;
CREATE POLICY "anon_delete_coupons" ON coupons FOR DELETE
  TO anon, authenticated USING (true);

-- ==================== SETTINGS TABLE ====================
CREATE TABLE IF NOT EXISTS settings (
  id integer PRIMARY KEY DEFAULT 1 CHECK (id = 1),
  delivery_inside_dhaka numeric DEFAULT 70,
  delivery_outside_dhaka numeric DEFAULT 130,
  bkash_number text DEFAULT '01817220921',
  nagad_number text DEFAULT '01817220921',
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE settings ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_select_settings" ON settings;
CREATE POLICY "anon_select_settings" ON settings FOR SELECT
  TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "anon_insert_settings" ON settings;
CREATE POLICY "anon_insert_settings" ON settings FOR INSERT
  TO anon, authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "anon_update_settings" ON settings;
CREATE POLICY "anon_update_settings" ON settings FOR UPDATE
  TO anon, authenticated USING (true) WITH CHECK (true);

-- Insert default settings row
INSERT INTO settings (id, delivery_inside_dhaka, delivery_outside_dhaka, bkash_number, nagad_number)
VALUES (1, 70, 130, '01817220921', '01817220921')
ON CONFLICT (id) DO NOTHING;

-- ==================== INDEXES ====================
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category);
CREATE INDEX IF NOT EXISTS idx_orders_phone ON orders(phone);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_reviews_prod_id ON reviews(prod_id);
CREATE INDEX IF NOT EXISTS idx_coupons_code ON coupons(code);
