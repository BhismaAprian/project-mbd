import { Router } from "express";
import { getObat, createPemeriksaan } from "@controllers/pemeriksaan.controller";

const router = Router();
router.get("/obat", getObat);
router.post("/simpan", createPemeriksaan);

export default router;