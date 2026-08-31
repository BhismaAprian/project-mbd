import { Router } from "express";
import { indexRekamMedis } from "@controllers/report.controller";

const router = Router();
router.get("/rekam-medis", indexRekamMedis);

export default router;