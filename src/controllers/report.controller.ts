import type { Request, Response } from "express";
import * as reportService from "@services/report.service";

export async function indexRekamMedis(req: Request, res: Response) {
  try {
    const { nik } = req.query;

    if (nik && typeof nik === "string") {
      if (nik.trim().length !== 16) {
        return res.status(400).json({ 
          success: false, 
          message: "NIK pasien harus berukuran 16 digit" 
        });
      }

      const reports = await reportService.getRekamMedisByNik(nik.trim());
      return res.status(200).json({ success: true, data: reports });
    }

    const reports = await reportService.getRekamMedisLengkap();
    return res.status(200).json({ success: true, data: reports });
  } catch (err: any) {
    return res.status(500).json({ success: false, message: err.message });
  }
}


export async function indexLogAktivitas(_req: Request, res: Response) {
  try {
    const logs = await reportService.getLogAktivitasTerbaru();
    return res.status(200).json({ success: true, data: logs });
  } catch (err: any) {
    return res.status(500).json({ success: false, message: err.message });
  }
}