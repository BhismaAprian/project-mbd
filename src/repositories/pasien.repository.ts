import { pool } from "@config/db";
import type { PasienModel } from "@models/pasien.model";

export async function findPasienFromView(query?: string): Promise<PasienModel[]> {
  if (query) {
    const res = await pool.query<PasienModel>(
      "SELECT * FROM v_master_pasien WHERE nik = $1 OR nama_lengkap ILIKE $2 ORDER BY id DESC",
      [query, `%${query}%`]
    );
    return res.rows;
  }

  const res = await pool.query<PasienModel>("SELECT * FROM v_master_pasien ORDER BY id DESC");
  return res.rows;
}