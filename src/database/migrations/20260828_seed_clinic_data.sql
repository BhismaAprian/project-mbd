INSERT INTO dokter (nama_dokter, spesialis, tarif_jasa, kuota_harian) VALUES
    ('dr. Bhisma Aprian, Sp.PD', 'Penyakit Dalam', 150000.00, 20),
    ('dr. Ferhan Irengnyo, Sp.A', 'Anak', 125000.00, 15),
    ('dr. Azriel Albanjari, Sp.THT', 'THT', 135000.00, 10);

INSERT INTO obat (nama_obat, harga_satuan, stok) VALUES
    ('Paracetamol 500mg', 5000.00, 100),
    ('Amoxicillin 500mg', 12000.00, 50),
    ('Ibuprofen 400mg', 8000.00, 60);

INSERT INTO pasien (nik, nama_lengkap, jenis_kelamin, tanggal_lahir, telepon, alamat) VALUES
    ('1234567890123456', 'Dylanda INGFINIT', 'Laki-laki', '1995-04-23', '081234567890', 'Balikpapan'),
    ('3201015508980002', 'Siti Aminah', 'Perempuan', '1998-08-15', '085712345678', 'Samarinda');

INSERT INTO users (email, password, role) VALUES
    ('admin@klinik.com', 'password123', 'admin'),
    ('frontdesk@klinik.com', 'password123', 'pendaftaran'),
    ('kasir@klinik.com', 'password123', 'kasir'),
    ('dr.budi@klinik.com', 'password123', 'dokter');