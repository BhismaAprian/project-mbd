import type { Request, Response } from "express";
import * as kasirService from "@services/kasir.service";

export async function getTagihan(_req: Request, res: Response) {
  try {
    const tagihan = await kasirService.getTagihanKasir();
    return res.status(200).json({ success: true, data: tagihan });
  } catch (err: any) {
    return res.status(500).json({ success: false, message: err.message });
  }
}

export async function checkoutPembayaran(req: Request, res: Response) {
  try {
    const { antrean_id, diskon_persen, metode_json } = req.body;

    if (!antrean_id || typeof antrean_id !== "number") {
      return res.status(400).json({ success: false, message: "ID Antrean wajib berupa angka" });
    }
    if (diskon_persen !== undefined && (typeof diskon_persen !== "number" || diskon_persen < 0 || diskon_persen > 100)) {
      return res.status(400).json({ success: false, message: "Diskon persen harus berupa angka 0 - 100" });
    }

    await kasirService.processPembayaran({ antrean_id, diskon_persen, metode_json });
    return res.status(200).json({ success: true, message: "Pembayaran kasir berhasil diproses" });
  } catch (err: any) {
    return res.status(400).json({ success: false, message: err.message });
  }
}