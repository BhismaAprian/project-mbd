import { Router } from "express";
import { getObat, createPemeriksaan,restockObat } from "@controllers/pemeriksaan.controller";

const router = Router();
router.get("/obat", getObat);
router.post("/simpan", createPemeriksaan);
router.post("/obat/restock", restockObat);

export default router;