import { pool } from "@config/db";
import type { CreatePemeriksaanDto, StokObatReport } from "@models/pemeriksaan.model";

export async function findStokObatAktif(): Promise<StokObatReport[]> {
  const res = await pool.query<StokObatReport>("SELECT * FROM v_stok_obat_aktif");
  return res.rows;
}

export async function createPemeriksaanMedis(data: CreatePemeriksaanDto): Promise<void> {
  await pool.query(
    "CALL sp_selesaikan_pemeriksaan($1, $2, $3, $4)",
    [
      data.antrean_id,
      data.diagnosa,
      data.catatan_json ? JSON.stringify(data.catatan_json) : null,
      data.resep_items ? JSON.stringify(data.resep_items) : null,
    ]
  );
}