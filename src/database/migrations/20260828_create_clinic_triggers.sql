CREATE OR REPLACE FUNCTION trg_log_pendaftaran_fn()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO log_aktivitas (aksi, id_referensi, keterangan) 
    VALUES (
        'PENDAFTARAN_ANTREAN', 
        NEW.id,
        'Antrean No. ' || NEW.nomor_antrean || ' terdaftar untuk Pasien ID ' || NEW.pasien_id
    );
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_log_pendaftaran
    AFTER INSERT ON antrean
    FOR EACH ROW
    EXECUTE FUNCTION trg_log_pendaftaran_fn();

CREATE OR REPLACE FUNCTION trg_audit_stok_obat_fn()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    IF OLD.stok <> NEW.stok THEN
        INSERT INTO log_aktivitas (aksi, id_referensi, keterangan)
        VALUES (
            'UPDATE_STOK_OBAT', 
            NEW.id,
            'Stok obat "' || NEW.nama_obat || '" berkurang dari ' || OLD.stok || ' ke ' || NEW.stok
        );
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_audit_stok_obat
    AFTER UPDATE ON obat
    FOR EACH ROW
    EXECUTE FUNCTION trg_audit_stok_obat_fn();

CREATE OR REPLACE FUNCTION trg_log_pembayaran_fn()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO log_aktivitas (aksi, id_referensi, keterangan)
    VALUES (
        'PEMBAYARAN_SELESAI', 
        NEW.antrean_id,
        'Pelunasan Antrean ID ' || NEW.antrean_id || ' via ' || NEW.metode_pembayaran || ' sukses sejumlah Rp' || NEW.total_netto
    );
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_log_pembayaran
    AFTER INSERT ON pembayaran
    FOR EACH ROW
    EXECUTE FUNCTION trg_log_pembayaran_fn();

CREATE OR REPLACE FUNCTION trg_audit_rekam_medis_fn()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    IF OLD.diagnosa <> NEW.diagnosa THEN
        INSERT INTO log_aktivitas (aksi, id_referensi, keterangan)
        VALUES (
            'EDIT_DIAGNOSA', 
            NEW.id,
            'Perubahan diagnosa RM ID ' || NEW.id || ' dari: "' || OLD.diagnosa || '" ke: "' || NEW.diagnosa || '"'
        );
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_audit_rekam_medis
    AFTER UPDATE ON rekam_medis
    FOR EACH ROW
    EXECUTE FUNCTION trg_audit_rekam_medis_fn();