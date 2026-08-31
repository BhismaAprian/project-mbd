import { Router } from "express";
import { getKuota, createAntrean } from "@controllers/antrean.controller";

const router = Router();
router.get("/kuota", getKuota);
router.post("/daftar", createAntrean);

export default router;