import type { CreatePemeriksaanDto, StokObatReport } from "@models/pemeriksaan.model";
import * as pemeriksaanRepo from "@repositories/pemeriksaan.repository";

export async function getStokObat(): Promise<StokObatReport[]> {
  return await pemeriksaanRepo.findStokObatAktif();
}

export async function processPemeriksaan(data: CreatePemeriksaanDto): Promise<void> {
  return await pemeriksaanRepo.createPemeriksaanMedis(data);
}