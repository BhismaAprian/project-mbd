import type { RekamMedisLengkapReport, LogAktivitasReport } from "@models/report.model";
import * as reportRepo from "@repositories/report.repository";

export async function getRekamMedisLengkap(): Promise<RekamMedisLengkapReport[]> {
  return await reportRepo.findRekamMedisLengkap();
}

export async function getRekamMedisByNik(nik: string): Promise<RekamMedisLengkapReport[]> {
  return await reportRepo.findRekamMedisByNik(nik);
}

export async function getLogAktivitasTerbaru(): Promise<LogAktivitasReport[]> {
  return await reportRepo.findLogAktivitasTerbaru();
}
