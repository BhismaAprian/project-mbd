CREATE OR REPLACE FUNCTION fn_hitung_total_bayar(
    p_antrean_id INT, 
    p_diskon_persen DECIMAL
)
RETURNS DECIMAL LANGUAGE plpgsql AS $$
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
$$;

CREATE OR REPLACE PROCEDURE sp_proses_pembayaran(
    p_antrean_id INT, 
    p_diskon DECIMAL, 
    p_metode_pembayaran VARCHAR DEFAULT 'Cash'
)
LANGUAGE plpgsql 
SECURITY DEFINER
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
        metode_pembayaran
    ) VALUES (
        p_antrean_id, 
        v_bruto, 
        p_diskon, 
        v_netto, 
        p_metode_pembayaran
    );

    UPDATE antrean SET status = 'Selesai' WHERE id = p_antrean_id;
END;
$$;

CREATE OR REPLACE FUNCTION fn_total_pasien_bulanan(p_bulan INT, p_tahun INT)
RETURNS INT LANGUAGE plpgsql AS $$
DECLARE v_total INT;
BEGIN
    SELECT COUNT(id) INTO v_total 
    FROM antrean 
    WHERE EXTRACT(MONTH FROM tanggal_berobat) = p_bulan 
      AND EXTRACT(YEAR FROM tanggal_berobat) = p_tahun;
    RETURN v_total;
END;
$$;

CREATE OR REPLACE FUNCTION fn_total_pendapatan_hari_ini()
RETURNS DECIMAL AS $$
BEGIN
    RETURN (
        SELECT COALESCE(SUM(total_netto), 0) 
        FROM pembayaran 
        WHERE DATE(created_at) = CURRENT_DATE
    );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE sp_generate_laporan_bulanan(p_bulan INT, p_tahun INT)
LANGUAGE plpgsql AS $$
DECLARE v_total_pasien INT;
BEGIN
    v_total_pasien := fn_total_pasien_bulanan(p_bulan, p_tahun);
    RAISE NOTICE 'Laporan Bulan % Tahun %: Total Pasien = %', p_bulan, p_tahun, v_total_pasien;
END;
$$;
