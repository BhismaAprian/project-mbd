DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'pendaftaran_role') THEN CREATE ROLE pendaftaran_role; END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'dokter_role') THEN CREATE ROLE dokter_role; END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'kasir_role') THEN CREATE ROLE kasir_role; END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'admin_role') THEN CREATE ROLE admin_role; END IF;
END $$;

REVOKE ALL ON ALL TABLES IN SCHEMA public FROM PUBLIC, pendaftaran_role, dokter_role, kasir_role;
GRANT USAGE ON SCHEMA public TO pendaftaran_role, dokter_role, kasir_role;

GRANT SELECT ON v_kuota_dokter_hari_ini, v_antrean_hari_ini TO pendaftaran_role;
GRANT EXECUTE ON FUNCTION fn_cek_sisa_kuota_dokter(INT, DATE) TO pendaftaran_role;
GRANT EXECUTE ON PROCEDURE sp_daftar_antrean_pasien(VARCHAR, VARCHAR, DATE, VARCHAR, INT, DATE) TO pendaftaran_role;
GRANT EXECUTE ON PROCEDURE sp_batalkan_antrean_pasien(INT, TEXT) TO pendaftaran_role;

GRANT SELECT ON v_stok_obat_aktif, v_rekam_medis_lengkap TO dokter_role;
GRANT EXECUTE ON FUNCTION fn_hitung_subtotal_resep(DECIMAL, INT) TO dokter_role;
GRANT EXECUTE ON PROCEDURE sp_selesaikan_pemeriksaan(INT, TEXT, TEXT, JSONB) TO dokter_role;

GRANT SELECT ON v_tagihan_kasir TO kasir_role;
GRANT EXECUTE ON FUNCTION fn_hitung_total_bayar(INT, DECIMAL), fn_total_pendapatan_hari_ini() TO kasir_role;
GRANT EXECUTE ON PROCEDURE sp_proses_pembayaran(INT, DECIMAL, VARCHAR) TO kasir_role;

GRANT SELECT ON v_rekam_medis_lengkap, v_log_aktivitas_terbaru TO admin_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin_role;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin_role;

GRANT SELECT ON v_master_pasien TO pendaftaran_role, admin_role;
GRANT SELECT ON v_master_dokter TO pendaftaran_role, dokter_role, kasir_role, admin_role;
GRANT EXECUTE ON PROCEDURE sp_restock_obat(INT, INT) TO dokter_role, admin_role;

ALTER TABLE rekam_medis ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS rls_dokter_rekam_medis ON rekam_medis;
DROP POLICY IF EXISTS rls_admin_rekam_medis ON rekam_medis;

CREATE POLICY rls_dokter_rekam_medis ON rekam_medis
    FOR SELECT
    TO dokter_role
    USING (
        antrean_id IN (
            SELECT id FROM antrean 
            WHERE dokter_id = NULLIF(current_setting('app.current_dokter_id', true), '')::INT
        )
    );

CREATE POLICY rls_admin_rekam_medis ON rekam_medis
    FOR ALL
    TO admin_role
    USING (true);