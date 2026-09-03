import type { ProcessPembayaranDto, TagihanKasirReport } from "@models/kasir.model";
import * as kasirRepo from "@repositories/kasir.repository";

export async function getTagihanKasir(): Promise<TagihanKasirReport[]> {
  return await kasirRepo.findTagihanKasir();
}


export async function getPendapatanHariIni(): Promise<number>{
  return await kasirRepo.getPendapatanHariIni();
}


export async function processPembayaran(data: ProcessPembayaranDto): Promise<void> {
  return await kasirRepo.createPembayaranKasir(data);
}

