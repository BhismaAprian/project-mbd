import type { PasienModel } from "@models/pasien.model";
import * as pasienRepo from "@repositories/pasien.repository";

export async function getPasienList(query?: string): Promise<PasienModel[]> {
  return await pasienRepo.findPasienFromView(query);
}