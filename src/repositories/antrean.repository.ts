import { pool } from "@config/db";
import type { CreateAntreanDto, KuotaDokterReport } from "@models/antrean.model";

export async function findKuotaDokter(): Promise<KuotaDokterReport[]> {
  const res = await pool.query<KuotaDokterReport>("SELECT * FROM v_kuota_dokter_hari_ini");
  return res.rows;
}

export async function createAntreanRegistration(data: CreateAntreanDto): Promise<void> {
  await pool.query(
    "CALL sp_daftar_antrean_pasien($1, $2, $3, $4, $5, $6, $7)",
    [
      data.nik,
      data.nama,
      data.tanggal_lahir,
      data.telepon || null,
      data.dokter_id,
      data.tanggal,
      data.metadata ? JSON.stringify(data.metadata) : null,
    ]
  );
}