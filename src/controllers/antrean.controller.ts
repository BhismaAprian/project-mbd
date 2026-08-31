import type { Request, Response } from "express";
import * as antreanService from "@services/antrean.service";

export async function getKuota(_req: Request, res: Response) {
  try {
    const kuota = await antreanService.getKuotaDokter();
    return res.status(200).json({ success: true, data: kuota });
  } catch (err: any) {
    return res.status(500).json({ success: false, message: err.message });
  }
}

export async function createAntrean(req: Request, res: Response) {
  try {
    const { nik, nama, tanggal_lahir, telepon, dokter_id, tanggal, metadata } = req.body;

    if (!nik || typeof nik !== "string" || nik.trim().length !== 16) {
      return res.status(400).json({ success: false, message: "NIK wajib 16 digit" });
    }
    if (!nama || typeof nama !== "string" || nama.trim() === "") {
      return res.status(400).json({ success: false, message: "Nama pasien wajib diisi" });
    }
    if (!tanggal_lahir || typeof tanggal_lahir !== "string") {
      return res.status(400).json({ success: false, message: "Tanggal lahir wajib diisi (YYYY-MM-DD)" });
    }
    if (!dokter_id || typeof dokter_id !== "number") {
      return res.status(400).json({ success: false, message: "ID Dokter wajib berupa angka" });
    }
    if (!tanggal || typeof tanggal !== "string") {
      return res.status(400).json({ success: false, message: "Tanggal berobat wajib diisi (YYYY-MM-DD)" });
    }

    await antreanService.registerAntrean({ nik, nama, tanggal_lahir, telepon, dokter_id, tanggal, metadata });
    return res.status(201).json({ success: true, message: "Pendaftaran antrean berhasil" });
  } catch (err: any) {
    return res.status(400).json({ success: false, message: err.message });
  }
}

export async function fetchAntreanHariIni(_req: Request, res: Response): Promise<Response> {
  try {
    const data = await antreanService.fetchAntreanHariIni();
    return res.status(200).json({
      success: true,
      message: "Berhasil mengambil daftar antrean hari ini",
      data,
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : "Terjadi kesalahan pada server";
    return res.status(500).json({ 
      success: false, 
      message 
    });
  }
}

export async function cancelAntrean(req: Request, res: Response): Promise<Response> {
  try {
    const { antrean_id, alasan } = req.body;

    if (!antrean_id || !alasan) {
      return res.status(400).json({
        success: false,
        message: "antrean_id dan alasan wajib diisi",
      });
    }

    await antreanService.cancelAntrean(Number(antrean_id), alasan);

    return res.status(200).json({
      success: true,
      message: "Antrean pasien berhasil dibatalkan",
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : "Terjadi kesalahan pada server";
    return res.status(500).json({
      success: false,
      message,
    });
  }
}