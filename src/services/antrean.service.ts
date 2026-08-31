import type { CreateAntreanDto, KuotaDokterReport } from "@models/antrean.model";
import * as antreanRepo from "@repositories/antrean.repository";

export async function getKuotaDokter(): Promise<KuotaDokterReport[]> {
  return await antreanRepo.findKuotaDokter();
}

export async function registerAntrean(data: CreateAntreanDto): Promise<void> {
  return await antreanRepo.createAntreanRegistration(data);
}

export async function fetchAntreanHariIni(): Promise<unknown> {
  return antreanRepo.getAntreanHariIni();
}

export async function cancelAntrean(
  antreanId: number, 
  alasan: string
): Promise<unknown> {
  return antreanRepo.batalkanAntrean(antreanId, alasan);
}