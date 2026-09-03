import { pool } from "@config/db";
import type { ProcessPembayaranDto, TagihanKasirReport } from "@models/kasir.model";

export async function findTagihanKasir(): Promise<TagihanKasirReport[]> {
  const res = await pool.query<TagihanKasirReport>("SELECT * FROM v_tagihan_kasir");
  return res.rows;
}

export async function createPembayaranKasir(data: ProcessPembayaranDto): Promise<void>{
  const res = await pool.query(
    "CALL sp_proses_pembayaran($1,$2,$3)",
    [
      data.antrean_id,
      data.diskon_persen || 0,
      data.metode_pembayaran || 'Cash',
    ]
  );
}

export async function getPendapatanHariIni(): Promise<number> {
  const res = await pool.query<{ fn_total_pendapatan_hari_ini: number }>(
    "SELECT fn_total_pendapatan_hari_ini()"
  );
  return Number(res.rows[0]?.fn_total_pendapatan_hari_ini || 0);
}