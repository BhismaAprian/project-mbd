import type { DokterModel } from "@models/dokter.model";
import * as dokterRepo from "@repositories/dokter.repository";

export async function getDokterList(): Promise<DokterModel[]> {
  return await dokterRepo.findDokterFromView();
}