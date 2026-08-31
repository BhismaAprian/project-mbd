CREATE OR REPLACE FUNCTION fn_hitung_total_bayar(
    p_antrean_id INT, 
    p_diskon_persen DECIMAL
)
RETURNS DECIMAL AS $$
DECLARE
    v_bruto DECIMAL;
BEGIN
    SELECT 
        d.tarif_jasa + COALESCE(SUM(rd.subtotal), 0) 
    INTO v_bruto
    FROM antrean a 
    JOIN dokter d ON a.dokter_id = d.id 
    LEFT JOIN rekam_medis rm ON a.id = rm.antrean_id
    LEFT JOIN resep_detail rd ON rm.id = rd.rekam_medis_id
    WHERE a.id = p_antrean_id
    GROUP BY d.tarif_jasa;

    RETURN v_bruto - (v_bruto * (p_diskon_persen / 100));
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE sp_proses_pembayaran(
    p_antrean_id INT, 
    p_diskon DECIMAL, 
    p_metode JSONB
)
AS $$
DECLARE
    v_netto DECIMAL;
    v_bruto DECIMAL;
BEGIN
    v_netto := fn_hitung_total_bayar(p_antrean_id, p_diskon);

    IF v_netto IS NULL THEN 
        RAISE EXCEPTION 'Tagihan tidak valid'; 
    END IF;

    v_bruto := v_netto / (1 - (p_diskon / 100));

    INSERT INTO pembayaran (
        antrean_id, 
        total_bruto, 
        diskon_persen, 
        total_netto, 
        metode_json
    ) VALUES (
        p_antrean_id, 
        v_bruto, 
        p_diskon, 
        v_netto, 
        p_metode
    );

    UPDATE antrean 
    SET status = 'Selesai' 
    WHERE id = p_antrean_id;
END;
$$ LANGUAGE plpgsql;