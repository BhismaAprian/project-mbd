CREATE OR REPLACE FUNCTION trg_log_pendaftaran_fn()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO log_aktivitas (sumber_event, keterangan) 
    VALUES (
        'PENDAFTARAN', 
        'Antrean No. ' || NEW.nomor_antrean || ' terdaftar untuk Pasien ID ' || NEW.pasien_id
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_log_pendaftaran
    AFTER INSERT ON antrean
    FOR EACH ROW
    EXECUTE FUNCTION trg_log_pendaftaran_fn();


CREATE OR REPLACE FUNCTION trg_audit_stok_obat_fn()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.stok <> NEW.stok THEN
        INSERT INTO log_aktivitas (sumber_event, keterangan)
        VALUES (
            'STOK_OBAT', 
            'Obat ID ' || NEW.id || ' (' || NEW.nama_obat || ') berkurang dari ' || OLD.stok || ' ke ' || NEW.stok
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_stok_obat
    AFTER UPDATE ON obat
    FOR EACH ROW
    EXECUTE FUNCTION trg_audit_stok_obat_fn();


CREATE OR REPLACE FUNCTION trg_log_pembayaran_fn()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO log_aktivitas (sumber_event, keterangan)
    VALUES (
        'PEMBAYARAN', 
        'Pelunasan Antrean ID ' || NEW.antrean_id || ' sukses sejumlah Rp' || NEW.total_netto
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_log_pembayaran
    AFTER INSERT ON pembayaran
    FOR EACH ROW
    EXECUTE FUNCTION trg_log_pembayaran_fn();


CREATE OR REPLACE FUNCTION trg_audit_rekam_medis_fn()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.diagnosa <> NEW.diagnosa THEN
        INSERT INTO log_aktivitas (sumber_event, keterangan)
        VALUES (
            'REKAM_MEDIS', 
            'Perubahan diagnosa RM ID ' || NEW.id || ' dari: "' || OLD.diagnosa || '" ke: "' || NEW.diagnosa || '"'
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_rekam_medis
    AFTER UPDATE ON rekam_medis
    FOR EACH ROW
    EXECUTE FUNCTION trg_audit_rekam_medis_fn();