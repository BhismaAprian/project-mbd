CREATE OR REPLACE FUNCTION fn_cek_sisa_kuota_dokter(p_dokter_id INT, p_tanggal DATE)
RETURNS INT LANGUAGE plpgsql AS $$
DECLARE
    v_kuota INT;
    v_terdaftar INT;
BEGIN
    SELECT kuota_harian INTO v_kuota FROM dokter WHERE id = p_dokter_id;
    IF NOT FOUND THEN RAISE EXCEPTION 'Dokter tidak ditemukan'; END IF;

    SELECT COUNT(*) INTO v_terdaftar FROM antrean 
    WHERE dokter_id = p_dokter_id AND tanggal_berobat = p_tanggal AND status != 'Batal';

    RETURN v_kuota - v_terdaftar;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_daftar_antrean_pasien(
    p_nik VARCHAR, p_nama VARCHAR, p_tgl_lahir DATE, p_telp VARCHAR, 
    p_dokter_id INT, p_tgl_berobat DATE
)
LANGUAGE plpgsql AS $$
DECLARE
    v_pasien_id INT;
    v_no_antrean INT;
BEGIN
    IF fn_cek_sisa_kuota_dokter(p_dokter_id, p_tgl_berobat) <= 0 THEN
        RAISE EXCEPTION 'Kuota dokter sudah penuh';
    END IF;

    SELECT id INTO v_pasien_id FROM pasien WHERE nik = p_nik;
    IF v_pasien_id IS NULL THEN
        INSERT INTO pasien (nik, nama_lengkap, tanggal_lahir, telepon)
        VALUES (p_nik, p_nama, p_tgl_lahir, p_telp) RETURNING id INTO v_pasien_id;
    END IF;

    SELECT COALESCE(MAX(nomor_antrean), 0) + 1 INTO v_no_antrean 
    FROM antrean WHERE dokter_id = p_dokter_id AND tanggal_berobat = p_tgl_berobat;

    INSERT INTO antrean (pasien_id, dokter_id, tanggal_berobat, nomor_antrean)
    VALUES (v_pasien_id, p_dokter_id, p_tgl_berobat, v_no_antrean);
END;
$$;

CREATE OR REPLACE PROCEDURE sp_batalkan_antrean_pasien(
    p_antrean_id INT,
    p_alasan TEXT
)
LANGUAGE plpgsql AS $$
DECLARE
    v_status VARCHAR(20);
BEGIN
    SELECT status INTO v_status FROM antrean WHERE id = p_antrean_id;

    IF v_status IS NULL THEN
        RAISE EXCEPTION 'Data antrean dengan ID % tidak ditemukan', p_antrean_id;
    END IF;

    IF v_status = 'Batal' THEN
        RAISE EXCEPTION 'Antrean ID % sudah dibatalkan sebelumnya', p_antrean_id;
    END IF;

    IF v_status = 'Selesai' THEN
        RAISE EXCEPTION 'Antrean ID % tidak dapat dibatalkan karena transaksi sudah selesai', p_antrean_id;
    END IF;

    UPDATE antrean
    SET status = 'Batal', alasan_batal = p_alasan
    WHERE id = p_antrean_id;
END;
$$;