import { pool } from "@config/db";
import type { RekamMedisLengkapReport, LogAktivitasReport } from "@models/report.model";

export async function findRekamMedisLengkap(): Promise<RekamMedisLengkapReport[]> {
  const res = await pool.query<RekamMedisLengkapReport>("SELECT * FROM v_rekam_medis_lengkap");
  return res.rows;
}

export async function findRekamMedisByNik(nik: string): Promise<RekamMedisLengkapReport[]> {
  const res = await pool.query<RekamMedisLengkapReport>(
    "SELECT * FROM v_rekam_medis_lengkap WHERE nik = $1",
    [nik]
  );
  return res.rows;
}

export async function findLogAktivitasTerbaru(): Promise<LogAktivitasReport[]> {
  const res = await pool.query<LogAktivitasReport>("SELECT * FROM v_log_aktivitas_terbaru");
  return res.rows;
}