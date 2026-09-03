export interface PasienModel {
  id: number;
  nik: string;
  nama_lengkap: string;
  jenis_kelamin: string | null;
  tanggal_lahir: string;
  telepon: string | null;
  alamat: string | null;
  created_at: string;
}