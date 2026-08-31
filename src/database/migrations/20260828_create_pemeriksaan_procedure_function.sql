CREATE OR REPLACE FUNCTION fn_hitung_subtotal_resep(p_harga DECIMAL, p_jumlah INT)
RETURNS DECIMAL LANGUAGE plpgsql AS $$
BEGIN
    RETURN p_harga * p_jumlah;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_selesaikan_pemeriksaan(
    p_antrean_id INT, p_diagnosa TEXT, p_catatan JSONB, p_resep JSONB
)
LANGUAGE plpgsql AS $$
DECLARE
    v_rm_id INT;
    item RECORD;
    v_stok INT;
    v_harga DECIMAL;
BEGIN
    INSERT INTO rekam_medis (antrean_id, diagnosa, catatan_json)
    VALUES (p_antrean_id, p_diagnosa, p_catatan) RETURNING id INTO v_rm_id;

    IF p_resep IS NOT NULL THEN
        FOR item IN SELECT (value->>'obat_id')::INT AS o_id, (value->>'jumlah')::INT AS qty 
                    FROM jsonb_array_elements(p_resep)
        LOOP
            SELECT stok, harga_satuan INTO v_stok, v_harga FROM obat WHERE id = item.o_id FOR UPDATE;
            
            IF v_stok < item.qty THEN
                RAISE EXCEPTION 'Stok obat ID % tidak mencukupi', item.o_id;
            END IF;

            INSERT INTO resep_detail (rekam_medis_id, obat_id, jumlah, subtotal)
            VALUES (v_rm_id, item.o_id, item.qty, fn_hitung_subtotal_resep(v_harga, item.qty));

            UPDATE obat SET stok = stok - item.qty WHERE id = item.o_id;
        END LOOP;
    END IF;

    UPDATE antrean SET status = 'Periksa' WHERE id = p_antrean_id;
END;
$$;