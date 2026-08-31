import type { Request, Response } from "express";
import * as reportService from "@services/report.service";

export async function indexRekamMedis(_req: Request, res: Response) {
  try {
    const reports = await reportService.getRekamMedisLengkap();
    return res.status(200).json({ success: true, data: reports });
  } catch (err: any) {
    return res.status(500).json({ success: false, message: err.message });
  }
}