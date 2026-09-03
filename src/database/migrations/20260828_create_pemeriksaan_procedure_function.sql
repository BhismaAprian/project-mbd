CREATE OR REPLACE FUNCTION fn_hitung_subtotal_resep(p_harga DECIMAL, p_jumlah INT)
RETURNS DECIMAL LANGUAGE plpgsql AS $$
BEGIN
    RETURN p_harga * p_jumlah;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_selesaikan_pemeriksaan(
    p_antrean_id INT, 
    p_diagnosa TEXT, 
    p_catatan_dokter TEXT, 
    p_resep JSONB DEFAULT NULL
)
LANGUAGE plpgsql AS $$
DECLARE
    v_pasien_id INT;
    v_status VARCHAR(20);
    v_rm_id INT;
    item RECORD;
    v_stok INT;
    v_harga DECIMAL;
BEGIN
    SELECT pasien_id, status 
    INTO v_pasien_id, v_status 
    FROM antrean 
    WHERE id = p_antrean_id;

    IF v_pasien_id IS NULL THEN
        RAISE EXCEPTION 'Antrean ID % tidak ditemukan', p_antrean_id;
    END IF;

    IF v_status = 'Batal' THEN
        RAISE EXCEPTION 'Pemeriksaan gagal: Antrean ID % sudah dibatalkan', p_antrean_id;
    END IF;

    IF v_status = 'Selesai' THEN
        RAISE EXCEPTION 'Pemeriksaan gagal: Antrean ID % sudah selesai diproses dan dilunasi', p_antrean_id;
    END IF;

    IF v_status = 'Periksa' THEN
        RAISE EXCEPTION 'Pemeriksaan gagal: Antrean ID % sudah pernah diperiksa sebelumnya', p_antrean_id;
    END IF;

    INSERT INTO rekam_medis (pasien_id, antrean_id, diagnosa, catatan_dokter)
    VALUES (v_pasien_id, p_antrean_id, p_diagnosa, p_catatan_dokter) 
    RETURNING id INTO v_rm_id;

    IF p_resep IS NOT NULL THEN
        FOR item IN SELECT (value->>'obat_id')::INT AS o_id, (value->>'jumlah')::INT AS qty 
                    FROM jsonb_array_elements(p_resep)
        LOOP
            SELECT stok, harga_satuan 
            INTO v_stok, v_harga 
            FROM obat 
            WHERE id = item.o_id 
            FOR UPDATE;
            
            IF v_stok < item.qty THEN
                RAISE EXCEPTION 'Stok obat ID % tidak mencukupi (Sisa: %, Diminta: %)', item.o_id, v_stok, item.qty;
            END IF;

            INSERT INTO resep_detail (rekam_medis_id, obat_id, jumlah, subtotal)
            VALUES (v_rm_id, item.o_id, item.qty, fn_hitung_subtotal_resep(v_harga, item.qty));

            UPDATE obat SET stok = stok - item.qty WHERE id = item.o_id;
        END LOOP;
    END IF;

    UPDATE antrean SET status = 'Periksa' WHERE id = p_antrean_id;
END;
$$;