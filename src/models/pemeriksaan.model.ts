export interface ResepItemDto {
  obat_id: number;
  jumlah: number;
}

export interface CreatePemeriksaanDto {
  antrean_id: number;
  diagnosa: string;
  catatan_dokter?: string;
  resep_items?: ResepItemDto[];
}

export interface StokObatReport {
  obat_id: number;
  nama_obat: string;
  harga_satuan: number;
  sisa_stok: number;
}

