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
GROUP BY 
    d.id, 
    d.nama_dokter, 
    d.spesialis, 
    d.tarif_jasa, 
    d.kuota_harian;


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
GROUP BY 
    a.id, 
    a.nomor_antrean, 
    p.nama_lengkap, 
    d.nama_dokter, 
    d.tarif_jasa, 
    a.status;


CREATE OR REPLACE VIEW v_rekam_medis_lengkap AS
SELECT 
    rm.id AS rekam_medis_id,
    a.tanggal_berobat,
    p.nik,
    p.nama_lengkap AS nama_pasien,
    d.nama_dokter,
    rm.diagnosa,
    rm.catatan_json,
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
JOIN pasien p ON a.pasien_id = p.id
JOIN dokter d ON a.dokter_id = d.id
LEFT JOIN resep_detail rd ON rm.id = rd.rekam_medis_id
LEFT JOIN obat o ON rd.obat_id = o.id
GROUP BY 
    rm.id, 
    a.tanggal_berobat, 
    p.nik, 
    p.nama_lengkap, 
    d.nama_dokter, 
    rm.diagnosa, 
    rm.catatan_json
ORDER BY rm.id DESC;


CREATE OR REPLACE FUNCTION fn_total_pasien_bulanan(
    p_bulan INT, 
    p_tahun INT
)
RETURNS INT AS $$
DECLARE 
    v_total INT;
BEGIN
    SELECT COUNT(id) INTO v_total 
    FROM antrean 
    WHERE EXTRACT(MONTH FROM tanggal_berobat) = p_bulan 
      AND EXTRACT(YEAR FROM tanggal_berobat) = p_tahun;

    RETURN v_total;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE sp_generate_laporan_bulanan(
    p_bulan INT, 
    p_tahun INT
)
AS $$
DECLARE
    v_total_pasien INT;
BEGIN
    v_total_pasien := fn_total_pasien_bulanan(p_bulan, p_tahun);
    
    RAISE NOTICE 'Laporan Bulan % Tahun %: Total Pasien = %', p_bulan, p_tahun, v_total_pasien;
END;
$$ LANGUAGE plpgsql;