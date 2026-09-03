import type { Request, Response } from "express";
import * as dokterService from "@services/dokter.service";

export async function getDokter(_req: Request, res: Response) {
  try {
    const data = await dokterService.getDokterList();
    return res.status(200).json({ success: true, data });
  } catch (err: any) {
    return res.status(500).json({ success: false, message: err.message });
  }
}