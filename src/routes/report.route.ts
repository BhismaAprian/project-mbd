import { Router } from "express";
import { indexLogAktivitas, indexRekamMedis, } from "@controllers/report.controller";

const router = Router();
router.get("/rekam-medis", indexRekamMedis);
router.get("/logs", indexLogAktivitas); 
export default router;