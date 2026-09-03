import type { Request, Response } from "express";
import * as pemeriksaanService from "@services/pemeriksaan.service";

export async function getObat(_req: Request, res: Response) {
  try {
    const obat = await pemeriksaanService.getStokObat();
    return res.status(200).json({ success: true, data: obat });
  } catch (err: any) {
    return res.status(500).json({ success: false, message: err.message });
  }
}

export async function createPemeriksaan(req: Request, res: Response) {
  try {
    const { antrean_id, diagnosa, catatan_dokter, resep_items } = req.body;

    if (!antrean_id || typeof antrean_id !== "number") {
      return res.status(400).json({ success: false, message: "ID Antrean wajib berupa angka" });
    }
    if (!diagnosa || typeof diagnosa !== "string" || diagnosa.trim() === "") {
      return res.status(400).json({ success: false, message: "Diagnosa medis wajib diisi" });
    }
    if (catatan_dokter !== undefined && typeof catatan_dokter !== "string") {
      return res.status(400).json({ success: false, message: "Catatan dokter harus berupa teks" });
    }
    if (resep_items && !Array.isArray(resep_items)) {
      return res.status(400).json({ success: false, message: "Resep items harus berupa array" });
    }

    await pemeriksaanService.processPemeriksaan({ antrean_id, diagnosa, catatan_dokter, resep_items });
    return res.status(201).json({ success: true, message: "Pemeriksaan medis berhasil disimpan" });
  } catch (err: any) {
    return res.status(400).json({ success: false, message: err.message });
  }
}