DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'pendaftaran_role') THEN 
        CREATE ROLE pendaftaran_role; 
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'dokter_role') THEN 
        CREATE ROLE dokter_role; 
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'kasir_role') THEN 
        CREATE ROLE kasir_role; 
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'admin_role') THEN 
        CREATE ROLE admin_role; 
    END IF;
END $$;


GRANT SELECT ON v_kuota_dokter_hari_ini TO pendaftaran_role;
GRANT EXECUTE ON FUNCTION fn_cek_sisa_kuota_dokter(INT, DATE) TO pendaftaran_role;
GRANT EXECUTE ON PROCEDURE sp_daftar_antrean_pasien(VARCHAR, VARCHAR, DATE, VARCHAR, INT, DATE, JSONB) TO pendaftaran_role;


GRANT SELECT ON v_stok_obat_aktif TO dokter_role;
GRANT EXECUTE ON FUNCTION fn_hitung_subtotal_resep(DECIMAL, INT) TO dokter_role;
GRANT EXECUTE ON PROCEDURE sp_selesaikan_pemeriksaan(INT, TEXT, JSONB, JSONB) TO dokter_role;


GRANT SELECT ON v_tagihan_kasir TO kasir_role;
GRANT EXECUTE ON FUNCTION fn_hitung_total_bayar(INT, DECIMAL) TO kasir_role;
GRANT EXECUTE ON PROCEDURE sp_proses_pembayaran(INT, DECIMAL, JSONB) TO kasir_role;


GRANT SELECT ON v_rekam_medis_lengkap TO admin_role;
GRANT EXECUTE ON FUNCTION fn_total_pasien_bulanan(INT, INT) TO admin_role;
GRANT EXECUTE ON PROCEDURE sp_generate_laporan_bulanan(INT, INT) TO admin_role;


GRANT SELECT ON users TO pendaftaran_role, dokter_role, kasir_role;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin_role;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin_role;