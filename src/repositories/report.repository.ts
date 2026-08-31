import { pool } from "@config/db";
import type { RekamMedisLengkapReport } from "@models/report.model";

export async function findRekamMedisLengkap(): Promise<RekamMedisLengkapReport[]> {
  const res = await pool.query<RekamMedisLengkapReport>("SELECT * FROM v_rekam_medis_lengkap");
  return res.rows;
}