CREATE OR REPLACE VIEW v_kuota_dokter_hari_ini AS
SELECT 
    d.id AS dokter_id,
    d.nama_dokter,
    d.spesialis,
    d.tarif_jasa,
    d.kuota_harian,
    COUNT(a.id)::INT AS total_terdaftar,
    (d.kuota_harian - COUNT(a.id))::INT AS sisa_kuota
FROM dokter d
LEFT JOIN antrean a 
    ON d.id = a.dokter_id 
   AND a.tanggal_berobat = CURRENT_DATE 
   AND a.status <> 'Batal'
GROUP BY d.id, d.nama_dokter, d.spesialis, d.tarif_jasa, d.kuota_harian;

CREATE OR REPLACE VIEW v_stok_obat_aktif AS
SELECT 
    id AS obat_id,
    nama_obat,
    harga_satuan,
    stok AS sisa_stok
FROM obat
WHERE stok > 0
ORDER BY nama_obat ASC;

CREATE OR REPLACE VIEW v_tagihan_kasir AS
SELECT 
    a.id AS antrean_id,
    a.nomor_antrean,
    p.nama_lengkap AS nama_pasien,
    d.nama_dokter,
    d.tarif_jasa AS biaya_dokter,
    COALESCE(SUM(rd.subtotal), 0) AS total_resep_obat,
    (d.tarif_jasa + COALESCE(SUM(rd.subtotal), 0)) AS total_bruto,
    a.status
FROM antrean a
JOIN pasien p ON a.pasien_id = p.id
JOIN dokter d ON a.dokter_id = d.id
LEFT JOIN rekam_medis rm ON a.id = rm.antrean_id
LEFT JOIN resep_detail rd ON rm.id = rd.rekam_medis_id
WHERE a.status = 'Periksa'
GROUP BY a.id, a.nomor_antrean, p.nama_lengkap, d.nama_dokter, d.tarif_jasa, a.status;

CREATE OR REPLACE VIEW v_rekam_medis_lengkap AS
SELECT 
    rm.id AS rekam_medis_id,
    rm.pasien_id,
    p.nik,
    p.nama_lengkap AS nama_pasien,
    d.nama_dokter,
    a.tanggal_berobat,
    rm.diagnosa,
    rm.catatan_dokter,
    COALESCE(
        jsonb_agg(
            jsonb_build_object(
                'nama_obat', o.nama_obat, 
                'jumlah', rd.jumlah
            )
        ) FILTER (WHERE rd.id IS NOT NULL), 
        '[]'::jsonb
    ) AS rincian_resep
FROM rekam_medis rm
JOIN antrean a ON rm.antrean_id = a.id
JOIN pasien p ON rm.pasien_id = p.id
JOIN dokter d ON a.dokter_id = d.id
LEFT JOIN resep_detail rd ON rm.id = rd.rekam_medis_id
LEFT JOIN obat o ON rd.obat_id = o.id
GROUP BY rm.id, rm.pasien_id, p.nik, p.nama_lengkap, d.nama_dokter, a.tanggal_berobat, rm.diagnosa, rm.catatan_dokter
ORDER BY rm.id DESC;

CREATE OR REPLACE VIEW v_antrean_hari_ini AS
SELECT 
    a.id AS antrean_id,
    a.nomor_antrean,
    p.nik,
    p.nama_lengkap AS nama_pasien,
    p.telepon,
    d.nama_dokter,
    d.spesialis,
    a.tanggal_berobat,
    a.status,
    a.alasan_batal,
    a.created_at AS waktu_daftar
FROM antrean a
JOIN pasien p ON a.pasien_id = p.id
JOIN dokter d ON a.dokter_id = d.id
WHERE a.tanggal_berobat = CURRENT_DATE
ORDER BY a.nomor_antrean ASC;

CREATE OR REPLACE VIEW v_master_pasien AS
SELECT 
    id,
    nik,
    nama_lengkap,
    jenis_kelamin,
    tanggal_lahir,
    telepon,
    alamat,
    created_at
FROM pasien;

CREATE OR REPLACE VIEW v_master_dokter AS
SELECT 
    id,
    nama_dokter,
    spesialis,
    tarif_jasa,
    kuota_harian,
    created_at
FROM dokter;


CREATE OR REPLACE VIEW v_log_aktivitas_terbaru AS
SELECT 
    id,
    pengguna,
    aksi,
    id_referensi,
    keterangan,
    created_at
FROM log_aktivitas
ORDER BY id DESC
LIMIT 20;