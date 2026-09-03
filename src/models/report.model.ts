export interface RekamMedisLengkapReport {
  rekam_medis_id: number;
  pasien_id: number;
  nik: string;
  nama_pasien: string;
  nama_dokter: string;
  tanggal_berobat: string;
  diagnosa: string;
  catatan_dokter?: string;
  rincian_resep: Array<{ nama_obat: string; jumlah: number }>;
}

export interface LogAktivitasReport {
  id: number;
  pengguna: string;
  aksi: string;
  id_referensi: number | null;
  keterangan: string;
  created_at: string;
}