export interface RekamMedisLengkapReport {
  rekam_medis_id: number;
  tanggal_berobat: string;
  nik: string;
  nama_pasien: string;
  nama_dokter: string;
  diagnosa: string;
  catatan_json: Record<string, any>;
  rincian_resep: Array<{ nama_obat: string; jumlah: number }>;
}