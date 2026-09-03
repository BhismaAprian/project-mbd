import type { BatalkanAntreanDto, CreateAntreanDto, KuotaDokterReport } from "@models/antrean.model";
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

export async function cancelAntrean(data: BatalkanAntreanDto): Promise<unknown> {
  return antreanRepo.batalkanAntrean(data);
}