export interface CreateAntreanDto {
  nik: string;
  nama: string;
  tanggal_lahir: string;
  telepon?: string;
  dokter_id: number;
  tanggal: string; 
}

export interface BatalkanAntreanDto {
  antrean_id: number;
  alasan: string;
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

export interface AntreanHariIniReport {
  antrean_id: number;
  nomor_antrean: number;
  nik: string;
  nama_pasien: string;
  telepon?: string;
  nama_dokter: string;
  spesialis: string;
  tanggal_berobat: string;
  status: 'Menunggu' | 'Periksa' | 'Selesai' | 'Batal';
  alasan_batal?: string;
  waktu_daftar: string;
}