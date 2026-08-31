import type { RekamMedisLengkapReport } from "@models/report.model";
import * as reportRepo from "@repositories/report.repository";

export async function getRekamMedisLengkap(): Promise<RekamMedisLengkapReport[]> {
  return await reportRepo.findRekamMedisLengkap();
}