export interface CreateAntreanDto {
  nik: string;
  nama: string;
  tanggal_lahir: string;
  telepon?: string;
  dokter_id: number;
  tanggal: string;
  metadata?: Record<string, any>;
}

export interface KuotaDokterReport {
  dokter_id: number;
  nama_dokter: string;
  spesialis: string;
  tarif_jasa: number;
  kuota_harian: number;
  total_terdaftar: number;
  sisa_kuota: number;
}