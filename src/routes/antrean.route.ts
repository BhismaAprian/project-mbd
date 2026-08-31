import { Router } from "express";
import { getKuota, createAntrean, fetchAntreanHariIni, cancelAntrean } from "@controllers/antrean.controller";

const router = Router();
router.get("/", fetchAntreanHariIni);
router.get("/kuota", getKuota);
router.post("/daftar", createAntrean);
router.patch("/batal", cancelAntrean);

export default router;