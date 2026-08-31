export interface ProcessPembayaranDto {
  antrean_id: number;
  diskon_persen?: number;
  metode_json?: Record<string, any>;
}

export interface TagihanKasirReport {
  antrean_id: number;
  nomor_antrean: number;
  nama_pasien: string;
  nama_dokter: string;
  biaya_dokter: number;
  total_resep_obat: number;
  total_bruto: number;
  status: string;
}