import type { Request, Response } from "express";
import * as pasienService from "@services/pasien.service";

export async function getPasien(req: Request, res: Response) {
  try {
    const { q } = req.query;
    const data = await pasienService.getPasienList(q as string);
    return res.status(200).json({ success: true, data });
  } catch (err: any) {
    return res.status(500).json({ success: false, message: err.message });
  }
}