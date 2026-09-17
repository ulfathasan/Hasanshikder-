import { createClient } from "@supabase/supabase-js";

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

export const supabase = createClient(supabaseUrl, supabaseAnonKey);

export type Product = {
  id: string;
  name: string;
  category: string;
  price: number;
  image: string;
  gallery: string[];
  description: string;
  specs: { key: string; val: string }[];
  sizes: string[];
  colors: { name: string; hex: string }[];
  variations: string[];
  button_label: string;
  button_url: string;
  is_flash: boolean;
  stock: number;
  rating: number;
  reviews_count: number;
};

export type Order = {
  id: string;
  order_id: string;
  customer_name: string;
  phone: string;
  email: string;
  address: string;
  delivery_area: string;
  delivery_charge: number;
  subtotal: number;
  discount: number;
  total: number;
  payment_method: string;
  trx_id: string;
  status: string;
  items: Record<string, unknown>[];
};

export type Review = {
  id: string;
  prod_id: string;
  name: string;
  rating: number;
  comment: string;
};

export type Coupon = {
  id: string;
  code: string;
  discount: number;
};

export type Settings = {
  id: number;
  delivery_inside_dhaka: number;
  delivery_outside_dhaka: number;
  bkash_number: string;
  nagad_number: string;
};
