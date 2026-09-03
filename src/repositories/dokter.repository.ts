import { pool } from "@config/db";
import type { DokterModel } from "@models/dokter.model";

export async function findDokterFromView(): Promise<DokterModel[]> {
  const res = await pool.query<DokterModel>("SELECT * FROM v_master_dokter ORDER BY id ASC");
  return res.rows;
}