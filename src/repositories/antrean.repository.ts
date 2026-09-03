import { pool } from "@config/db";
import type { 
  CreateAntreanDto, 
  KuotaDokterReport, 
  AntreanHariIniReport, 
  BatalkanAntreanDto
} from "@models/antrean.model";

export async function findKuotaDokter(): Promise<KuotaDokterReport[]> {
  const res = await pool.query<KuotaDokterReport>("SELECT * FROM v_kuota_dokter_hari_ini");
  return res.rows;
}

export async function createAntreanRegistration(data: CreateAntreanDto): Promise<void> {
  await pool.query(
    "CALL sp_daftar_antrean_pasien($1, $2, $3, $4, $5, $6)",
    [
      data.nik,
      data.nama,
      data.tanggal_lahir,
      data.telepon || null,
      data.dokter_id,
      data.tanggal,
    ]
  );
}

export async function getAntreanHariIni(): Promise<AntreanHariIniReport[]> {
  const result = await pool.query<AntreanHariIniReport>("SELECT * FROM v_antrean_hari_ini");
  return result.rows;
}

export async function batalkanAntrean(data: BatalkanAntreanDto): Promise<void> {
  await pool.query("CALL sp_batalkan_antrean_pasien($1, $2)", [
    data.antrean_id,
    data.alasan,
  ]);
}