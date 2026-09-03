import { Router } from "express";
import { getPasien } from "@controllers/pasien.controller";

const router = Router();

router.get("/", getPasien);

export default router;